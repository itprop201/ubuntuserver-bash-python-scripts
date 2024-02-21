#!/bin/bash

# Скрипт для мониторинга состояния аккумулятора ноутбука и отправки уведомлений в Telegram

# Определение наличия установленного `acpi`
if ! command -v acpi &> /dev/null
then
    echo "acpi не установлен. Установите пакет acpi для продолжения."
    exit
fi

# Токен бота Telegram и чат ID
TELEGRAM_BOT_TOKEN="{YOUR_BOT_TOKEN}"
CHAT_ID="{YOUR_CHAT_ID}"

# Функция отправки сообщения в Telegram
send_message() {
    message="$1"
    curl -s -X POST https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage -d text="$message" -d chat_id=$CHAT_ID
}

# Мониторим статус аккумулятора каждые 20 секунд
while true
do
    battery_status=$(acpi -b | awk '{print $3}' | tr -d ',')
    if [ "$battery_status" == "Discharging" ]
    then
        send_message "ВНИМАНИЕ! БП отключен от ноутбука, аккумулятор разряжается. Уровень заряда: $(acpi -b | awk '{print $4}' | tr -d ',')"
    elif [ "$battery_status" == "Charging" ]
    then
	echo 0 > /dev/null
        # send_message "Аккумулятор подключен и заряжается. Уровень заряда: $(acpi -b | awk '{print $4}' | tr -d ',')"
    fi
    sleep 20
done
