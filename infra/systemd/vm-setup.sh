#!/bin/bash
# Скрипт для одноразовой настройки VM. Запускать на VM от root или через sudo.
set -e

echo "Создание пользователя tripplanner..."
useradd -r -s /bin/false tripplanner 2>/dev/null || true

echo "Создание директории /opt/tripplanner..."
mkdir -p /opt/tripplanner
chown tripplanner:tripplanner /opt/tripplanner

echo "Копирование systemd-сервиса..."
# Запускать из корня репо или передать путь к tripplanner.service
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp "$SCRIPT_DIR/tripplanner.service" /etc/systemd/system/
chmod 644 /etc/systemd/system/tripplanner.service

echo "daemon-reload и enable..."
systemctl daemon-reload
systemctl enable tripplanner

echo ""
echo "Готово! Дальше:"
echo "  1. Создай /opt/tripplanner/env с TELEGRAM_BOT_TOKEN, SPRING_DATA_MONGODB_URI и др."
echo "  2. chown tripplanner:tripplanner /opt/tripplanner/env && chmod 600 /opt/tripplanner/env"
echo "  3. Первый deploy положит app.jar; затем: systemctl start tripplanner"
