#!/bin/bash

set -e

# redirect new file descriptors and then tee stdout & stderr to supervisor log and console (captures output from this script)
exec 3>&1 4>&2 &> >(tee -a /var/log/supervisord.log)

chmod 666 /var/log/supervisord.log

echo "[info] Starting Supervisor..." | ts '%Y-%m-%d %H:%M:%.S'

# restore file descriptors
exec 1>&3 2>&4

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf -n
