# Deploy LAB SOC lên AWS EC2

> ⚠️⚠️ **CẢNH BÁO AN TOÀN — ĐỌC TRƯỚC**
> App này **cố tình dính lỗ hổng** (SQLi, upload webshell, path traversal ghi file tuỳ ý…).
> Nếu mở ra toàn Internet, **bot/hacker thật sẽ chiếm EC2 của bạn trong vài giờ** và có thể
> dùng nó tấn công người khác (bạn chịu trách nhiệm).
> **BẮT BUỘC:** trong AWS Security Group, chỉ mở port cho **đúng IP của bạn** (My IP),
> KHÔNG để `0.0.0.0/0`. Tắt/terminate instance khi làm xong.

---

## 0. Kiến trúc 2 EC2 (target + SOC riêng)

```
  Kali/máy bạn ──tấn công──►  ┌─ TARGET EC2 (10.0.0.59 / 3.231.211.194) ─┐
                              │  Docker: web app (8080) + PostgreSQL      │
                              │  logs/ (security.log, app.log)            │
                              │  Wazuh AGENT ──gửi log qua 1514/1515──┐   │
                              └───────────────────────────────────────┼───┘
                                                                      ▼
                              ┌─ SOC EC2 (cần tạo mới, ≥ 8GB RAM) ─────────┐
                              │  Wazuh MANAGER + Indexer + Dashboard (443) │
                              │  Decoder + Rule (local_decoder/local_rules)│
                              └────────────────────────────────────────────┘
```
- **TARGET EC2**: máy hiện tại (`3.231.211.194`, private `10.0.0.59`). Chạy app + agent. RAM 2GB là đủ.
- **SOC EC2**: **phải tạo thêm 1 instance** (cùng VPC), RAM **≥ 8GB** (vd `t3.large`) cho Wazuh Manager + Dashboard.
- Agent (target) gửi log tới Manager (SOC) qua **private IP** trong cùng VPC — nhanh, không lộ ra Internet.

Kiểm tra máy: `free -h && nproc && df -h /`

### Tạo SOC EC2
AWS Console → Launch instance → Ubuntu 24.04/26.04 → `t3.large` (8GB) → **cùng VPC/subnet** với target →
tải cùng key `soc-lab-key.pem`. Ghi lại **private IP** của SOC (vd `10.0.0.x`) để agent trỏ vào.

---

## 1. [TARGET EC2] Cài Docker
```bash
sudo apt update
sudo apt install -y docker.io docker-compose-v2 git
sudo usermod -aG docker $USER
newgrp docker   # hoặc logout/login lại
docker --version
```

## 2. [TARGET EC2] Đưa mã nguồn lên
Cách A — clone từ GitHub (nếu bạn đã push):
```bash
sudo mkdir -p /opt && cd /opt
sudo git clone <URL_REPO_CUA_BAN> nike
sudo chown -R $USER:$USER /opt/nike
cd /opt/nike
```
Cách B — copy từ máy Windows lên (chạy ở PowerShell máy bạn):
```powershell
scp -i "soc-lab-key.pem" -r D:\TLCN_ATTT\web-attack\nike ubuntu@3.231.211.194:/home/ubuntu/nike
# rồi trên EC2: sudo mv /home/ubuntu/nike /opt/nike
```

## 3. [TARGET EC2] Chạy web app + PostgreSQL (Docker)
```bash
cd /opt/nike
docker compose -f docker-compose.prod.yml up -d --build   # build lần đầu vài phút
docker compose -f docker-compose.prod.yml ps
# kiểm tra:
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:8080/api/v1/products   # mong đợi 200
ls -la logs/    # phải thấy app.log, security.log sau khi có request
```
Mở trình duyệt: `http://3.231.211.194:8080` (sau khi mở Security Group — mục 6).

## 4. [SOC EC2] Cài Wazuh (Manager + Indexer + Dashboard)
SSH vào **SOC EC2** rồi chạy:
```bash
curl -sO https://packages.wazuh.com/4.9/wazuh-install.sh
sudo bash ./wazuh-install.sh -a
# Xong sẽ in ra user/mật khẩu 'admin' của Dashboard. LƯU LẠI.
```
Truy cập Dashboard: `https://<PUBLIC_IP_SOC>` (chấp nhận cảnh báo TLS tự ký).
Lấy **private IP** của SOC để agent trỏ vào: `hostname -I` (vd `10.0.0.123`).

## 5. [TARGET EC2] Cài & ghép Wazuh Agent (đọc log app)
Trên **TARGET EC2**, cài agent trỏ về **private IP của SOC** (thay `10.0.0.123`):
```bash
SOC_IP="10.0.0.123"
curl -sO https://packages.wazuh.com/4.9/wazuh-agent-amd64.deb
sudo WAZUH_MANAGER="$SOC_IP" WAZUH_AGENT_NAME="target-nike" dpkg -i ./wazuh-agent-amd64.deb
```
Thêm nguồn log (dùng file có sẵn `wazuh/ossec-localfile.xml`):
```bash
# chèn 2 khối <localfile> vào ossec.conf (trước </ossec_config>)
sudo sed -i "/<\/ossec_config>/e cat /opt/nike/wazuh/ossec-localfile.xml" /var/ossec/etc/ossec.conf
sudo systemctl enable --now wazuh-agent
sudo systemctl restart wazuh-agent
```
> Đảm bảo Wazuh đọc được `/opt/nike/logs/` (quyền đọc). Nếu cần: `sudo chmod -R a+rX /opt/nike/logs`.

## 6. [SOC EC2] Nạp Decoder + Rule vào Manager
Copy 2 file `wazuh/local_decoder.xml` và `wazuh/local_rules.xml` từ repo lên **SOC EC2**
(scp hoặc git clone repo trên SOC), rồi:
```bash
sudo cp local_decoder.xml /var/ossec/etc/decoders/local_decoder.xml
sudo cp local_rules.xml   /var/ossec/etc/rules/local_rules.xml
# kiểm tra cú pháp rồi restart
sudo /var/ossec/bin/wazuh-logtest -t   # test cấu hình
sudo systemctl restart wazuh-manager
```
Test decoder bằng 1 dòng log mẫu:
```bash
echo '2026-09-23T00:00:00.000+07:00 WARN  SECURITY event=SQLI_ERROR ip=1.2.3.4 method=GET uri="/api/v1/products/1%27" ua="curl" x' | sudo /var/ossec/bin/wazuh-logtest
```

## 7. Mở AWS Security Group (CHỈ IP CỦA BẠN)
Lấy IP tại https://checkip.amazonaws.com. **KHÔNG dùng `0.0.0.0/0`.**

**SG của TARGET EC2** (web app):
| Type | Port | Source | Dùng cho |
|------|------|--------|----------|
| SSH | 22 | My IP | SSH |
| Custom TCP | 8080 | My IP | Web app / tấn công |

**SG của SOC EC2** (Wazuh):
| Type | Port | Source | Dùng cho |
|------|------|--------|----------|
| SSH | 22 | My IP | SSH |
| HTTPS | 443 | My IP | Wazuh Dashboard |
| Custom TCP | 1514 | SG của TARGET (hoặc `10.0.0.0/16`) | Agent gửi log |
| Custom TCP | 1515 | SG của TARGET (hoặc `10.0.0.0/16`) | Agent đăng ký |

> Vì 2 máy cùng VPC, agent→manager đi qua **private IP** (10.0.0.x), chỉ cần mở 1514/1515
> giữa 2 SG, KHÔNG mở ra Internet.

## 8. Tấn công & xem alert
Từ Kali/máy bạn (thay HOST=http://3.231.211.194:8080), chạy các payload trong
`VULN_LAB_SOC.md` (mục 2b–2d, 3). Ví dụ nhanh:
```bash
HOST=http://3.231.211.194:8080
curl "$HOST/api/v1/products/1%27"                                   # SQLi -> SQLI_ERROR
for p in 123456 admin password; do curl -s -X POST "$HOST/api/v1/auth/login" \
  -H "Content-Type: application/json" -d "{\"username\":\"admin@example.com\",\"password\":\"$p\"}"; done
curl -X DELETE "$HOST/api/admin/users/9999"                         # Broken Access
```
→ Mở **Wazuh Dashboard → Security events**, lọc rule id `100110/100121/100130/100140/100150`.

## 9. Dọn dẹp
```bash
cd /opt/nike && docker compose -f docker-compose.prod.yml down -v
```
Rồi **Stop/Terminate EC2** trong AWS Console để khỏi tốn tiền & tránh rủi ro.

---

## Sự cố thường gặp
- **RAM thiếu** → Wazuh indexer không start: dùng instance ≥ 8GB, hoặc tách server.
- **Dashboard không vào được** → chưa mở 443 hoặc dùng `http` thay vì `https`.
- **Không thấy log trong logs/** → app chưa nhận request nào, hoặc volume mount sai; kiểm tra `docker logs cps_spring_app`.
- **Agent không gửi log** → sai `WAZUH_MANAGER`, hoặc agent chưa được xác thực: xem `/var/ossec/logs/ossec.log`.
