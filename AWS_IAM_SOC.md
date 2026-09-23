# LAB SOC — Kịch bản AWS IAM Privilege Escalation (CloudTrail → Wazuh)

> Đây là kịch bản **Cloud/Identity Security**, TÁCH BIỆT với web `nike`. Log đến từ
> **AWS CloudTrail** (không phải app Java). Dùng tài khoản **AWS Free Tier**.
>
> Chi phí: trail CloudTrail đầu tiên ghi *management events* là **miễn phí**; S3 lưu
> log vài chục KB → gần như 0đ. Nhớ **xóa tài nguyên** khi xong (mục 8).

MITRE ATT&CK: **T1098 Account Manipulation** / **T1078.004 Valid Accounts: Cloud** —
attacker là user quyền thấp (`developer`) tự gắn `AdministratorAccess` để leo thang.

---

## 0. Chuẩn bị
- Tài khoản AWS (root chỉ để tạo IAM ban đầu; sau đó dùng IAM admin cá nhân).
- Máy có **AWS CLI v2**: `aws --version`.
- Wazuh manager đã chạy (SOC-server). Sẽ dùng **module aws-s3** của Wazuh để kéo CloudTrail.
- Chọn 1 region cố định, ví dụ `ap-southeast-1` (Singapore).

```bash
export AWS_REGION=ap-southeast-1
aws configure          # nhập Access Key admin của bạn, region ap-southeast-1
aws sts get-caller-identity   # kiểm tra đăng nhập OK
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
echo "Account: $ACCOUNT_ID"
```

---

## 1. Bật CloudTrail ghi ra S3

```bash
# 1.1 Tạo bucket S3 lưu log (tên phải toàn cầu duy nhất)
BUCKET="soc-cloudtrail-$ACCOUNT_ID"
aws s3api create-bucket --bucket "$BUCKET" --region $AWS_REGION \
  --create-bucket-configuration LocationConstraint=$AWS_REGION

# 1.2 Gắn bucket policy cho CloudTrail được ghi (lưu file rồi apply)
cat > /tmp/ct-bucket-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailAclCheck",
      "Effect": "Allow",
      "Principal": {"Service": "cloudtrail.amazonaws.com"},
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::$BUCKET"
    },
    {
      "Sid": "AWSCloudTrailWrite",
      "Effect": "Allow",
      "Principal": {"Service": "cloudtrail.amazonaws.com"},
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::$BUCKET/AWSLogs/$ACCOUNT_ID/*",
      "Condition": {"StringEquals": {"s3:x-amz-acl": "bucket-owner-full-control"}}
    }
  ]
}
EOF
aws s3api put-bucket-policy --bucket "$BUCKET" --policy file:///tmp/ct-bucket-policy.json

# 1.3 Tạo & bật trail (multi-region, ghi management events - miễn phí)
aws cloudtrail create-trail --name soc-trail --s3-bucket-name "$BUCKET" \
  --is-multi-region-trail
aws cloudtrail start-logging --name soc-trail
aws cloudtrail get-trail-status --name soc-trail --query IsLogging
```

---

## 2. Tạo "attacker" — IAM user quyền thấp NHƯNG bị cấu hình sai

Đây chính là **lỗ hổng**: `developer` được cấp quyền `iam:AttachUserPolicy` (đáng lẽ không nên) → tự leo thang thành admin.

```bash
# 2.1 Tạo user + access key
aws iam create-user --user-name developer
aws iam create-access-key --user-name developer > /tmp/dev-key.json
cat /tmp/dev-key.json    # lưu AccessKeyId + SecretAccessKey

# 2.2 Gắn policy "cố tình sai": cho phép tự attach policy cho chính mình
cat > /tmp/dev-misconfig.json <<'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    { "Effect": "Allow",
      "Action": ["iam:AttachUserPolicy","iam:ListPolicies","iam:GetUser","iam:ListAttachedUserPolicies"],
      "Resource": "*" }
  ]
}
EOF
aws iam put-user-policy --user-name developer \
  --policy-name dev-misconfig --policy-document file:///tmp/dev-misconfig.json
```

---

## 3. Thực hiện tấn công (Privilege Escalation)

Cấu hình profile dùng access key của `developer` rồi tự gắn quyền Admin:

```bash
aws configure --profile attacker    # nhập AccessKeyId/Secret của developer, region ap-southeast-1

# HÀNH VI TẤN CÔNG: user thường tự gắn AdministratorAccess
aws --profile attacker iam attach-user-policy \
  --user-name developer \
  --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

# Kiểm chứng đã thành admin:
aws --profile attacker iam list-attached-user-policies --user-name developer
```

CloudTrail sẽ ghi event `AttachUserPolicy`. Log xuất hiện trong S3 sau **~5–15 phút**
(CloudTrail có độ trễ). Xem thử:
```bash
aws s3 ls "s3://$BUCKET/AWSLogs/$ACCOUNT_ID/CloudTrail/$AWS_REGION/" --recursive | tail
```
Nội dung 1 record điển hình:
```json
{
  "eventTime": "2026-09-22T16:50:00Z",
  "eventSource": "iam.amazonaws.com",
  "eventName": "AttachUserPolicy",
  "awsRegion": "us-east-1",
  "sourceIPAddress": "1.2.3.4",
  "userIdentity": { "type": "IAMUser", "userName": "developer", "arn": "arn:aws:iam::123:user/developer" },
  "requestParameters": {
    "userName": "developer",
    "policyArn": "arn:aws:iam::aws:policy/AdministratorAccess"
  }
}
```

---

## 4. Cho Wazuh đọc CloudTrail từ S3

### 4.1 Tạo IAM user riêng cho Wazuh (chỉ đọc bucket)
```bash
aws iam create-user --user-name wazuh-reader
cat > /tmp/wazuh-read.json <<EOF
{ "Version": "2012-10-17",
  "Statement": [
    { "Effect":"Allow", "Action":["s3:GetObject","s3:ListBucket"],
      "Resource":["arn:aws:s3:::$BUCKET","arn:aws:s3:::$BUCKET/*"] } ] }
EOF
aws iam put-user-policy --user-name wazuh-reader --policy-name read-ct --policy-document file:///tmp/wazuh-read.json
aws iam create-access-key --user-name wazuh-reader     # lưu key cho Wazuh
```

### 4.2 Trên Wazuh manager: khai báo credentials
File `/root/.aws/credentials` (user chạy wodle, thường root):
```ini
[wazuh]
aws_access_key_id = <AccessKeyId của wazuh-reader>
aws_secret_access_key = <SecretAccessKey của wazuh-reader>
```

### 4.3 Thêm module vào `/var/ossec/etc/ossec.conf`
```xml
<wodle name="aws-s3">
  <disabled>no</disabled>
  <interval>10m</interval>
  <run_on_start>yes</run_on_start>
  <bucket type="cloudtrail">
    <name>soc-cloudtrail-XXXXXXXXXXXX</name>   <!-- = $BUCKET của bạn -->
    <aws_profile>wazuh</aws_profile>
  </bucket>
</wodle>
```
Khởi động lại: `systemctl restart wazuh-manager`.
Kiểm tra kéo log: `tail -f /var/ossec/logs/ossec.log | grep -i aws`.

> Wazuh có sẵn decoder + ruleset nhóm `amazon`/`aws` (rule nền ~80200) tự parse CloudTrail.

---

## 5. Rule cảnh báo Privilege Escalation

Thêm vào `/var/ossec/etc/rules/local_rules.xml`:
```xml
<group name="amazon,aws,iam,privilege_escalation,">

  <!-- Bất kỳ AttachUserPolicy nào cũng đáng chú ý -->
  <rule id="100200" level="8">
    <if_group>amazon</if_group>
    <field name="aws.eventName">AttachUserPolicy</field>
    <description>AWS IAM: AttachUserPolicy gắn policy cho user $(aws.requestParameters.userName)</description>
    <mitre><id>T1098</id></mitre>
  </rule>

  <!-- Gắn quyền ADMIN => leo thang đặc quyền, mức cao -->
  <rule id="100201" level="12">
    <if_sid>100200</if_sid>
    <field name="aws.requestParameters.policyArn">AdministratorAccess</field>
    <description>AWS IAM PRIVILEGE ESCALATION: AdministratorAccess gắn cho $(aws.requestParameters.userName) bởi $(aws.userIdentity.userName) từ $(aws.sourceIPAddress)</description>
    <mitre><id>T1098</id><id>T1078</id></mitre>
    <group>privilege_escalation,</group>
  </rule>

</group>
```
Restart manager. Khi log CloudTrail được kéo về, alert `100201 level=12` sẽ bắn →
đưa sang AI phân tích như các kịch bản web.

> Tên field (`aws.eventName`, `aws.requestParameters.policyArn`...) theo decoder AWS của
> Wazuh. Nếu phiên bản khác, kiểm tra bằng: cho 1 log mẫu qua
> `/var/ossec/bin/wazuh-logtest` để xem field đã decode.

---

## 6. Kiểm thử nhanh rule không cần chờ S3

Dán 1 dòng CloudTrail JSON vào `wazuh-logtest` để xác minh rule khớp trước khi chờ log thật:
```bash
/var/ossec/bin/wazuh-logtest
# rồi dán JSON event ở mục 3
```

## 7. Các event leo thang khác nên bắt (mở rộng)
`AttachUserPolicy`, `AttachRolePolicy`, `PutUserPolicy`, `CreateAccessKey`,
`CreateLoginProfile`, `UpdateAssumeRolePolicy`, `AddUserToGroup` (group admin).

## 8. Dọn dẹp (tránh phát sinh phí / rủi ro)
```bash
aws iam detach-user-policy --user-name developer --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
aws iam delete-user-policy --user-name developer --policy-name dev-misconfig
# xóa access keys rồi xóa user
aws iam delete-user --user-name developer
aws iam delete-user --user-name wazuh-reader
aws cloudtrail stop-logging --name soc-trail
aws cloudtrail delete-trail --name soc-trail
aws s3 rb "s3://$BUCKET" --force
```
