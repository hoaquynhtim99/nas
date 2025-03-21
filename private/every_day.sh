#!/bin/bash

DIR_PATH=$(dirname ${BASH_SOURCE[0]})
echo $DIR_PATH

if [ -f "$DIR_PATH/logs/every_day.txt" ]; then
  if [ -n "$(find $DIR_PATH/logs/ -type f -name every_day.txt -mmin +120)" ]; then
    # 10 phút mà còn file này thì xóa để chạy đè tiến trình
    rm -f $DIR_PATH/logs/every_day.txt
  else
    echo "Đang bận"
    exit
  fi
fi

echo "$(date +%Y-%m-%d-%T)" >"$DIR_PATH/logs/every_day.txt"

START=$(date +%s)
file_logs="$DIR_PATH/logs/every_day_$(date +%Y-%m-%d).txt"
echo "$(date +%Y-%m-%d-%T)" >> $file_logs

yesterday=$(date +%Y-%m-%d -d "yesterday")

echo "----- Kiểm tra tự động các APP ------"
basetime=$(date +%s%N)
php "${DIR_PATH}/auto-check-app.php"
echo "$(awk "BEGIN {printf \"%.4f\", ($(date +%s%N) - ${basetime})/(1*10^09)}") seconds auto-check-app" >> $file_logs

echo "----- Dọn dẹp file log quá hạn ------"
basetime=$(date +%s%N)
find "${DIR_PATH}/logs" -type f \( -name '*.log' -o -name '*.txt' \) -mtime +30 | xargs /bin/rm -f
echo "$(awk "BEGIN {printf \"%.4f\", ($(date +%s%N) - ${basetime})/(1*10^09)}") seconds clear timeout log" >> $file_logs

echo "Kết thúc"
echo "Tổng cộng: $(($(date +%s) - $START)) giây"

rm -f "$DIR_PATH/logs/every_day.txt"

echo "Total time : $(($(date +%s) - $START))" >> $file_logs
echo "--------------------END---------------------------" >> $file_logs
