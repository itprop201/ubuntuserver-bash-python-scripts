#!/bin/bash
# Токен бота Telegram и чат ID
TELEGRAM_BOT_TOKEN="{YOUR_TG_TOKEN}"
CHAT_ID="{YOUR_CHAT_ID}"

# Функция отправки сообщения в Telegram
send_message() {
    message="$1"
    curl -s -X POST https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage -d text="$message" -d chat_id=$CHAT_ID
}

# Основной мониторинг системы
while true
do
    # Получение загрузки ЦП
    cpu_load=$(top -bn1 | grep "Cpu(s)" | awk '{print $2+$4}')

    # Получение загрузки ОЗУ
    memory_usage=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')

    # Получение количества запущенных процессов
    process_count=$(ps -A --no-headers | wc -l)

    # Получение загруженности ПЗУ
    disk_usage=$(df -h / | awk '/\// {print $5}')

    # Получение количества занятой памяти в разделе sda6
    sda_usage1=$(df -h | awk '$1~"/dev/sda6"{print $5}')

    # Получение количества занятой памяти в разделе sdb1
    sda_usage2=$(df -h | awk '$1~"/dev/sdb1"{print $5}')

    # Получение количества занятой памяти в разделе sdb2
    sda_usage3=$(df -h | awk '$1~"/dev/sdb2"{print $5}')

    # Получение температуры ЦП
    cpu_temp=$(sensors | grep "high" | awk '{print $2}')

    # Получение температуры 1 жесткого диска
    hdd_temp1=$(smartctl -a /dev/sda | grep "Temperature_Celsius" | awk '{print $10}')

    # Получение температуры 2 жесткого диска
    hdd_temp2=$(smartctl -a /dev/sdb | grep "Temperature_Celsius" | awk '{print $10}')

    # Получение скорости загрузки сетевой платы
    netspeed1=$(ifstat -i enx00e04c680f56 1 1 | tail -1 | awk '{print $1}')

    # Получение скорости отдачи сетевой платы
    netspeed2=$(ifstat -i enx00e04c680f56 1 1 | tail -1 | awk '{print $2}')

    # Отправка данных в Telegram
    send_message "Мониторинг:
-----------------------------------------------------------------------------------------------------
    - Загрузка ЦП: $cpu_load%
    - Загрузка ОЗУ: $memory_usage%
    - Температура ЦП: $cpu_temp
    - Температура системного ЖД: $hdd_temp1°C
    - Температура ЖД 4TB: $hdd_temp2°C
    - Занятая память в разделе sda6 (корневой раздел): $sda_usage1
    - Занятая память в разделе для рез. копий (sdb1): $sda_usage2
    - Занятая память в разделе для медиа (sdb2): $sda_usage3
    - Количество процессов: $process_count
    - Скорость загрузки сетевой платы: $netspeed1 KB/s
    - Скорость отдачи сетевой платы: $netspeed2 KB/s
-----------------------------------------------------------------------------------------------------"

    # Дополнительный мониторинг работы программ (AdGuardHome)
    if pgrep AdGuardHome > /dev/null
    then
        send_message "Сервис AdGuardHome работает нормально."
    else
        send_message "Внимание! Сервис AdGuardHome не запущен."
    fi

    # Дополнительный мониторинг работы программ (sshd)
    if pgrep sshd > /dev/null
    then
        send_message "Сервис SSH работает нормально."
    else
        send_message "Внимание! Сервис SSH не запущен."
    fi

    # Дополнительный мониторинг работы программ (smbd)
    if pgrep smbd > /dev/null
    then
        send_message "Сервис Samba работает нормально."
    else
        send_message "Внимание! Сервис Samba не запущен."
    fi

    # Дополнительный мониторинг работы программ (minidlna)
    if pgrep minidlna > /dev/null
    then
        send_message "Сервис miniDLNA работает нормально."
    else
        send_message "Внимание! Сервис miniDLNA не запущен."
    fi

    # Дополнительный мониторинг работы программ (transmission)
    if pgrep transmission > /dev/null
    then
    	send_message "Сервис Transmission работает нормально."
    else
	send_message "Сервис Transmission не запущен."
    fi
    sleep 7500
done
