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

rm -f $DIR_PATH/server.key
rm -f $DIR_PATH/server.crt

openssl req -config $DIR_PATH/cert.conf -newkey rsa:2048 -nodes -keyout $DIR_PATH/server.key -x509 -days 3650 -out $DIR_PATH/server.crt

echo "Done"
