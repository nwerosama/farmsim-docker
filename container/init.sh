#!/bin/bash

set -e

XML_BASE_DIR="/home/nobody/xml"

for DIR in "$XML_BASE_DIR"/*/; do
  if [ -n "$WEB_USERNAME" ]; then
    sed -i "s/<username>admin<\/username>/<username>$WEB_USERNAME<\/username>/" "$DIR/default_dedicatedServer.xml"
  fi

  if [ -n "$WEB_PASSWORD" ]; then
    sed -i "s/<passphrase>password<\/passphrase>/<passphrase>$WEB_PASSWORD<\/passphrase>/" "$DIR/default_dedicatedServer.xml"
  fi

  if [ -n "$GAME_PORT" ]; then
    sed -i "s/<port>10823<\/port>/<port>$GAME_PORT<\/port>/" "$DIR/default_dedicatedServerConfig.xml"
  fi

  if [ -n "$GAME_NAME" ]; then
    sed -i "s/<game_name>.*<\/game_name>/<game_name>$GAME_NAME<\/game_name>/" "$DIR/default_dedicatedServerConfig.xml"
  fi

  if [ "${GAME_PASSWORD+x}" ]; then
    sed -i "s|<game_password>.*</game_password>|<game_password>$GAME_PASSWORD</game_password>|" "$DIR/default_dedicatedServerConfig.xml"
  else
    sed -i "s|<game_password>.*</game_password>|<game_password>$(tr -dc 'A-Z' < /dev/urandom | head -c8)</game_password>|" "$DIR/default_dedicatedServerConfig.xml"
  fi

  if [ -n "$GAME_PASSWORD_ADMIN" ]; then
    sed -i "s|<admin_password>.*</admin_password>|<admin_password>$GAME_PASSWORD_ADMIN</admin_password>|" "$DIR/default_dedicatedServerConfig.xml"
  else
    sed -i "s|<admin_password>.*</admin_password>|<admin_password>$(tr -dc 'A-Z' < /dev/urandom | head -c8)</admin_password>|" "$DIR/default_dedicatedServerConfig.xml"
  fi
done

exec /root/supervisor.sh
