#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  TARGET="$(readlink "$SOURCE")"
  if [[ $TARGET == /* ]]; then
    SOURCE="$TARGET"
  else
    DIR="$(dirname "$SOURCE")"
    SOURCE="$DIR/$TARGET"
  fi
done
DIR="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)"
cd "$DIR/../"
DIR_PATH=$PWD

# Dừng và xóa các container nếu đang chạy
docker-compose down

# Xóa các image custom đã tạo hay không
while true; do
  read -p "Xóa các docker image custom đã tạo [y/n(mặc định)]? " yn
  if [[ "$yn" = "y" || "$yn" = "y" ]]; then
    echo "Xóa các image nas-*"
    for Repository in $(docker images --format '{{.Repository}}'); do
      if [[ "$Repository" =~ ^nas- ]]; then
        docker image rm -f "$Repository"
      fi
    done
    break
  elif [[ "$yn" = "n" || "$yn" = "N" || "$yn" = "" ]]; then
    echo "Giữ lại các image nas-* nếu có"
    break
  else
    echo "Vui lòng nhập y hoặc n hoặc để trống"
  fi
done

# Hỏi dùng database có sẵn hay không
REIMPORT_DB=0
if [ ! -d "$DIR_PATH/_docker/mysql/nas" ]; then
  # Không tồn tại thư mục DB thì luôn tạo mới DB
  REIMPORT_DB=1
else
  while true; do
    read -p "Sử dụng các database đang có [y(mặc định)/n]? " yn
    if [[ "$yn" = "y" || "$yn" = "y" || "$yn" = "" ]]; then
      REIMPORT_DB=0
      break
    elif [[ "$yn" = "n" || "$yn" = "N" ]]; then
      REIMPORT_DB=1
      break
    else
      echo "Vui lòng nhập y hoặc n hoặc để trống"
    fi
  done
fi

if [[ "$REIMPORT_DB" -eq 1 ]]; then
  echo "Xóa toàn bộ database tạo lại"
  rm -rf "$DIR_PATH/_docker"
  mkdir -p "$DIR_PATH/_docker/mysql"
  echo "" > "$DIR_PATH/_docker/mysql/.gitkeep"
  mkdir -p "$DIR_PATH/_docker/nas"
  echo "" > "$DIR_PATH/_docker/nas/.gitkeep"

  rm -f "$DIR_PATH/src/data/config/config_global.php"
  rm -f "$DIR_PATH/src/data/config/config_ini.http.blanas.local.php"
  rm -f "$DIR_PATH/src/data/config/config_ini.https.blanas.local.php"
  rm -f "$DIR_PATH/src/config.php"
else
  echo "Dùng các database sẵn có (nếu tồn tại)"
fi

if [ ! -f "$DIR_PATH/src/data/config/config_global.php" ]; then
  echo "Tạo file config_global.php"
  cp "$DIR_PATH/setup/config_global.php" "$DIR_PATH/src/data/config/config_global.php"
  sleep 1
fi
if [ ! -f "$DIR_PATH/config.php" ]; then
  echo "Tạo file config.php"
  cp "$DIR_PATH/setup/config.php" "$DIR_PATH/src/config.php"
  sleep 1
fi
if [ ! -f "$DIR_PATH/.env" ]; then
  echo "Tạo file .env"
  cp "$DIR_PATH/.env.example" "$DIR_PATH/.env"
  sleep 1
fi

docker-compose up -d

# Chờ MariaDB chạy hoàn tất
attempt=0
DB_READY=0
while [ $attempt -le 59 ]; do
  attempt=$(($attempt + 1))
  echo "Đợi mariadb sẵn sàng (lần $attempt)..."
  result=$( (docker logs db) 2>&1)
  if grep -q 'mariadbd: ready for connections' <<<$result; then
    echo "MariaDB sẵn sàng!"
    DB_READY=1
    break
  fi
  sleep 2
done
if [[ ! "$DB_READY" -eq 1 ]]; then
  echo "Không khởi chạy MariaDB thành công, vui lòng kiểm tra lại"
  exit
fi

# Chờ nginx chạy hoàn tất
attempt=0
NGINX_READY=0
while [ $attempt -le 59 ]; do
  attempt=$(($attempt + 1))
  echo "Đợi nginx sẵn sàng (lần $attempt)..."
  result=$( (docker logs proxy) 2>&1)
  if grep -q 'Configuration complete; ready for start up' <<<$result; then
    echo "Nginx sẵn sàng!"
    NGINX_READY=1
    break
  fi
  sleep 2
done
if [[ ! "$NGINX_READY" -eq 1 ]]; then
  echo "Không khởi chạy nginx thành công, vui lòng kiểm tra lại"
  exit
fi

if [ ! -d "$DIR_PATH/_docker/mysql/nas" ]; then
  echo "Tạo và import CSDL nas"
  sleep 5
  docker exec db bin/bash -c "mariadb -u root -e 'CREATE DATABASE nas;'"
  docker exec db bin/bash -c "mariadb -u root nas < /home/nas.sql"
fi

echo "Xong!"
