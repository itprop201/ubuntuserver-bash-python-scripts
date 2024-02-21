#!/bin/bash

# Путь для сохранения резервной копии
backup_file="/your_folder/backup.img"

# Создание резервного образа
dd if=/dev/sda of=$backup_file bs=4M &

# PID последнего фонового процесса
dd_pid=$!

# Ожидание завершения процесса
while true; do
    if ps -p $dd_pid > /dev/null; then
        # Процесс еще работает, отправляем уведомление в телеграм
        curl -s -X POST https://api.telegram.org/{CHAT_ID}/sendMessage -d text="Процесс резервного копирования еще выполняется..." -d chat_id=ваш_идентификатор_чата &> /dev/null
        sleep 300  # ожидание 300 секунд
    else
        # Процесс завершился, отправляем уведомление в телеграм
        if [ $? -eq 0 ]; then
            message="Резервное копирование завершено успешно! Образ сохранен в $backup_file"
        else
            message="Ошибка при создании резервной копии!"
        fi
        curl -s -X POST https://api.telegram.org//sendMessage -d text="$message" -d chat_id={CHAT_ID} &> /dev/null
        break
    fi
done
