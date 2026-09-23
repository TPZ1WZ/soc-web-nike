#!/usr/bin/env bash
# ⚠️ LAB SOC — cập nhật app trên EC2 sau khi sửa code.
# Dùng: ./update.sh          (git pull + build lại web)
#       ./update.sh --no-pull (bỏ qua git pull, chỉ build lại)
set -e
cd "$(dirname "$0")"

if [ "$1" != "--no-pull" ]; then
  echo "==> git pull..."
  git pull --ff-only || echo "(bỏ qua git pull — không phải git repo hoặc có xung đột)"
fi

echo "==> Build lại & khởi động lại service web (PostgreSQL giữ nguyên)..."
docker compose -f docker-compose.prod.yml up -d --build web

echo "==> Chờ app sẵn sàng..."
for i in $(seq 1 30); do
  code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/api/v1/products 2>/dev/null || echo 000)
  if [ "$code" = "200" ]; then echo "✅ App UP (http 200)"; break; fi
  sleep 3
done

echo "==> Log gần nhất:"
docker compose -f docker-compose.prod.yml logs --tail=15 web
