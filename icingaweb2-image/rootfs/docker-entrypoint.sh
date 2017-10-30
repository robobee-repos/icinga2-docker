#!/bin/bash
set -e

source /docker-entrypoint-utils.sh
set_debug
echo "Running as `id`"
sync_dir "/etc/icingaweb2.dist" "/etc/icingaweb2"
sync_dir "/usr/share/icingaweb2.dist" "/usr/share/icingaweb2"

exec "$@"
