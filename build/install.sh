#!/bin/bash

set -e

# create file with contents of here doc, note EOF is NOT quoted to allow us to expand current variable 'install_paths'
# we use escaping to prevent variable expansion for PUID and PGID, as we want these expanded at runtime of init.sh

# env vars
####

cat <<'EOF' > /tmp/envvars_heredoc

# Webserver

if [ -n "$WEB_USERNAME" ]; then
  sed -i "s/<username>admin<\/username>/<username>$WEB_USERNAME<\/username>/" /opt/fs25/xml/default_dedicatedServer.xml
fi

if [ -n "$WEB_PASSWORD" ]; then
  sed -i "s/<passphrase>password<\/passphrase>/<passphrase>$WEB_PASSWORD<\/passphrase>/" /opt/fs25/xml/default_dedicatedServer.xml
fi

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
