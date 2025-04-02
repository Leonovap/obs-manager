#!/bin/bash

# Получаем даты
yesterday=$(date +"%Y-%m-%d")
today=$(date -d "yesterday" +"%Y-%m-%d")

# Пути к файлам
source_dir="/data/data/com.termux/files/home/storage/shared/Documents/GIT/Obsidian/Trackers/"
dest_dir="/data/data/com.termux/files/home/storage/downloads/Data_an/Daily_note/"

source_file="${source_dir}${yesterday} Трекер привычек и состояний.md"
dest_file="${dest_dir}${yesterday} Трекер привычек и состояний.md"
old_file="${dest_dir}${today} Трекер привычек и состояний.md"

# Проверяем, существует ли исходный файл перед копированием
if [ -f "$source_file" ]; then
    cp "$source_file" "$dest_dir"
    echo "Файл скопирован: $source_file → $dest_dir"
else
    echo "Ошибка: исходный файл не найден: $source_file"
    exit 1
fi

# Проверяем, существует ли старый файл перед удалением
if [ -f "$old_file" ]; then
    if rm "$old_file"; then
        echo "Старый трекер удалён: $old_file"
    else
        echo "Ошибка при удалении файла: $old_file"
    fi
else
    echo "Старый трекер не найден: $old_file (пропускаем удаление)"
fi

echo "Tracker was sent! ^^"
