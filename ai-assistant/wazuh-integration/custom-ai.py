#!/usr/bin/env python3
"""
Wazuh Integrator -> AI Assistant.
Wazuh gọi script này mỗi khi có alert (level đủ cao), đẩy alert sang AI /api/ingest.

CÀI (trên Wazuh manager / container):
  1. Copy file này vào /var/ossec/integrations/custom-ai  (bỏ đuôi .py) + chmod 750, chown root:wazuh
  2. Thêm vào /var/ossec/etc/ossec.conf trong <ossec_config>:

     <integration>
       <name>custom-ai</name>
       <hook_url>http://<AI_HOST>:8000/api/ingest</hook_url>
       <level>10</level>                <!-- chỉ đẩy alert level >=10 -->
       <group>web_attack</group>
       <alert_format>json</alert_format>
     </integration>

  3. Restart manager. Từ đó mỗi alert web_attack tự sang AI phân tích + gửi Telegram.

Ghi chú: Wazuh gọi:  custom-ai <alert_file> <api_key> <hook_url>
"""
import sys
import json
import requests

def main():
    alert_file = sys.argv[1]
    hook_url = sys.argv[3] if len(sys.argv) > 3 else "http://localhost:8000/api/ingest"
    with open(alert_file, encoding="utf-8") as f:
        alert = json.load(f)
    try:
        requests.post(hook_url, json=alert, timeout=30)
    except Exception as e:
        # Wazuh integrator nuốt output; ghi ra log để debug nếu cần
        with open("/tmp/custom-ai.log", "a") as lg:
            lg.write(f"error: {e}\n")

if __name__ == "__main__":
    main()
