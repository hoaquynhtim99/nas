#!/bin/bash

DIR_PATH=$(dirname ${BASH_SOURCE[0]})
echo "$DIR_PATH"

if [ -f "$DIR_PATH/logs/every_minute.txt" ]; then
  if [ -n "$(find $DIR_PATH/logs/ -type f -name every_minute.txt -mmin +10)" ]; then
    # 10 phút mà còn file này thì xóa để chạy đè tiến trình
    rm -f $DIR_PATH/logs/every_minute.txt
  else
    echo "Đang bận"
    exit
  fi
fi

echo "$(date +%Y-%m-%d-%T)" >"$DIR_PATH/logs/every_minute.txt"

START=$(date +%s)
file_logs="$DIR_PATH/logs/every_minute_$(date +%Y-%m-%d).txt"
echo "$(date +%Y-%m-%d-%T)" >> $file_logs

echo "----- Xóa tự động thùng rác ------"
basetime=$(date +%s%N)
php $DIR_PATH/auto-remove-trash.php
echo "$(awk "BEGIN {printf \"%.4f\", ($(date +%s%N) - ${basetime})/(1*10^09)}") seconds auto-remove-trash" >> $file_logs

echo "----- Xóa tự động file upload tạm bị lỗi sau 1 ngày ------"
basetime=$(date +%s%N)
php $DIR_PATH/auto-remove-tmp-uploaded.php
echo "$(awk "BEGIN {printf \"%.4f\", ($(date +%s%N) - ${basetime})/(1*10^09)}") seconds auto-remove-tmp-uploaded" >> $file_logs

echo "----- Đồng bộ lên Google Drive ------"
basetime=$(date +%s%N)
php $DIR_PATH/sync-google-drive.php
echo "$(awk "BEGIN {printf \"%.4f\", ($(date +%s%N) - ${basetime})/(1*10^09)}") seconds sync-google-drive" >> $file_logs

echo "----- Xử lý video ------"
basetime=$(date +%s%N)
bash $DIR_PATH/processing-video.sh
echo "$(awk "BEGIN {printf \"%.4f\", ($(date +%s%N) - ${basetime})/(1*10^09)}") seconds processing-video" >> $file_logs

echo "----- Gửi thông báo các lỗi gặp phải qua email ------"
basetime=$(date +%s%N)
php $DIR_PATH/send-notice.php
echo "$(awk "BEGIN {printf \"%.4f\", ($(date +%s%N) - ${basetime})/(1*10^09)}") seconds send-notice" >> $file_logs

echo "Kết thúc"
echo "Tổng cộng: $(($(date +%s) - $START)) giây"

rm -f "$DIR_PATH/logs/every_minute.txt"

echo "Total time : $(($(date +%s) - $START))" >> $file_logs
echo "--------------------END---------------------------" >> $file_logs
