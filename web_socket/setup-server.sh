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
cd "$DIR/"
DIR_PATH=$PWD

if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root." >&2
  exit 1
fi

if [ ! -f "$DIR_PATH/blanas_signaling_server" ]; then
  echo "blanas_signaling_server not exists"
  exit
fi

serviceName="blanas_signaling_server.service"
if systemctl --all --type service | grep -q "$serviceName"; then
  echo "$serviceName exists. Delete and reset"
  systemctl stop $serviceName
  systemctl disable $serviceName
  rm -f /etc/systemd/system/$serviceName
fi

user="blanas"
if [ ! -d "/home/${user}/blanas.local/private" ]; then
  echo "/home/${user}/blanas.local/private not exists!"
  exit
fi

mkdir -p "/home/${user}/blanas.local/private/blanas_signaling_server"
pathService="/home/"${user}"/blanas.local/private/blanas_signaling_server/blanas_signaling_server"
cp "$DIR_PATH/blanas_signaling_server" "$pathService"
chmod 700 -R /home/"${user}"/blanas.local/private/blanas_signaling_server
chown -R "${user}":"${user}" /home/"${user}/blanas.local/private/blanas_signaling_server"
chmod +x $pathService

cat >"/etc/systemd/system/$serviceName" <<END
[Unit]
Description=BlaNAS Signaling Server
After=network.target

[Service]
User=${user}
Group=${user}

WorkingDirectory=/home/${user}/blanas.local/private/blanas_signaling_server
ExecStart=${pathService}
Restart=always
Environment=GO_ENV=production

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl reset-failed
systemctl start "${serviceName}"
sleep 1
systemctl enable "${serviceName}"

systemctl status "${serviceName}"
#systemctl status blanas_signaling_server.service
#journalctl -u blanas_signaling_server.service -f
#journalctl -u blanas_signaling_server.service -b
