#!/bin/bash

set -e

# create file with contents of here doc, note EOF is NOT quoted to allow us to expand current variable 'install_paths'
# we use escaping to prevent variable expansion for PUID and PGID, as we want these expanded at runtime of init.sh

# env vars
cat <<'EOF' > /tmp/envvars_heredoc

# Webserver

if [ -n "$WEB_USERNAME" ]; then
  sed -i "s/<username>admin<\/username>/<username>$WEB_USERNAME<\/username>/" /opt/fs25/xml/default_dedicatedServer.xml
fi

if [ -n "$WEB_PASSWORD" ]; then
  sed -i "s/<passphrase>password<\/passphrase>/<passphrase>$WEB_PASSWORD<\/passphrase>/" /opt/fs25/xml/default_dedicatedServer.xml
fi

if [ -n "$WEB_PORT" ]; then
  sed -i "s/<webserver port=\"8080\">/<webserver port=\"${WEB_PORT}\">/" /opt/fs25/xml/default_dedicatedServer.xml
fi

if [ -n "$GAME_PORT" ]; then
  sed -i "s/<port>10823<\/port>/<port>$GAME_PORT<\/port>/" /opt/fs25/xml/default_dedicatedServerConfig.xml
fi

if [ -n "$GAME_NAME" ]; then
  sed -i "s/<game_name>.*<\/game_name>/<game_name>$GAME_NAME<\/game_name>/" /opt/fs25/xml/default_dedicatedServerConfig.xml
fi

sed -i "s|<admin_password>.*</admin_password>|<admin_password>$(tr -dc 'A-Z' < /dev/urandom | head -c8)</admin_password>|" /opt/fs25/xml/default_dedicatedServerConfig.xml
sed -i "s|<game_password>.*</game_password>|<game_password>$(tr -dc 'A-Z' < /dev/urandom | head -c8)</game_password>|" /opt/fs25/xml/default_dedicatedServerConfig.xml

EOF

# replace env vars placeholder string with contents of file (here doc)

sed -i '/# ENVVARS_PLACEHOLDER/{
    s/# ENVVARS_PLACEHOLDER//g
    r /tmp/envvars_heredoc
}' /usr/local/bin/init.sh
rm /tmp/envvars_heredoc

# Symlinks
ln -s /opt/fs25/setup_giants.sh /home/nobody/setup_giants.sh
ln -s /opt/fs25/start_webserver.sh /home/nobody/start_webserver.sh
ln -s /opt/fs25/start_gameserver.sh /home/nobody/start_gameserver.sh
