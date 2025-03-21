#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  TARGET="$(readlink "$SOURCE")"
  if [[ $TARGET == /* ]]; then
    SOURCE="$TARGET"
  else
    DIR="$( dirname "$SOURCE" )"
    SOURCE="$DIR/$TARGET"
  fi
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
cd "$DIR/"
DIR_PATH=$PWD

function endloop {
  php "$DIR_PATH/processing-video-set.php"
}

# Lấy 10 video
for i in {1..10}; do
  rm -f "${DIR_PATH}/logs/processing-video/path.txt"
  rm -f "${DIR_PATH}/logs/processing-video/cover.txt"
  rm -f "${DIR_PATH}/logs/processing-video/id.txt"
  rm -f "${DIR_PATH}/logs/processing-video/error.txt"
  rm -f "${DIR_PATH}/logs/processing-video/resolution.txt"
  rm -f "${DIR_PATH}/logs/processing-video/duration.txt"

  php "$DIR_PATH/processing-video-get.php"
  code=$?
  if [[ $code == 0 ]]; then
    # Hết video
    exit
  fi
  VPATH=$(cat "${DIR_PATH}/logs/processing-video/path.txt")
  VCOVER=$(cat "${DIR_PATH}/logs/processing-video/cover.txt")
  VID=$(cat "${DIR_PATH}/logs/processing-video/id.txt")

  # Đọc độ phân giải
  RESOLUTION=$(ffmpeg -i $VPATH 2>&1 | grep -oP '(\d{2,5})x(\d{2,5})')
  if [[ $? > 0 ]]; then
    echo "Error get resolution"
    echo "Error get resolution" > "${DIR_PATH}/logs/processing-video/error.txt"
    endloop
    continue
  fi
  echo "$RESOLUTION" > "${DIR_PATH}/logs/processing-video/resolution.txt"
  echo "$RESOLUTION"

  # Chụp ảnh
  duration=$(ffprobe -i "$VPATH" -show_entries format=duration -v quiet -of csv="p=0")
  if [[ $? > 0 ]]; then
    echo "Error get duration"
    echo "Error get duration" > "${DIR_PATH}/logs/processing-video/error.txt"
    endloop
    continue
  fi
  duration=$(printf "%.0f" "$duration")
  echo "$duration" > "${DIR_PATH}/logs/processing-video/duration.txt"
  echo "Time: ${duration}s"

  random_time=$(shuf -i 0-$duration -n 1)
  hours=$((random_time / 3600))
  minutes=$(( (random_time % 3600) / 60 ))
  seconds=$((random_time % 60))
  time_str=$(printf "%02d:%02d:%02d" $hours $minutes $seconds)
  echo "Take cover at: $time_str"

  # Tạo thư mục
  cover_dir="${VCOVER%/*}"
  mkdir -p "$cover_dir"

  ffmpeg -ss $time_str -i "$VPATH" -frames:v 1 -q:v 2 -vf scale=320:-1 "$VCOVER" -loglevel error
  if [[ $? > 0 ]]; then
    echo "Error take image"
    echo "Error take image" > "${DIR_PATH}/logs/processing-video/error.txt"
    endloop
    continue
  fi
  if ! [ -f "$VCOVER" ]; then
    echo "Error save image"
    echo "Error save image" > "${DIR_PATH}/logs/processing-video/error.txt"
    endloop
    continue
  fi

  echo "Success"
  endloop
done

echo "Finish!"
