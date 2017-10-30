#!/bin/bash
set -e

source /docker-entrypoint-utils.sh
set_debug
echo "Running as `id`"
sync_dir "/etc/icinga2.dist" "/etc/icinga2"
copy_files "/icinga2-in" "/etc/icinga2" "*.conf"
copy_files "/conf-in" "/etc/icinga2/conf.d" "*.conf"
copy_files "/features-in" "/etc/icinga2/features-available" "*.conf"
copy_files "/repository-in" "/etc/icinga2/repository.d" "*.conf"
copy_files "/zones-in" "/etc/icinga2/zones.d" "*.conf"
copy_files "/pki-in" "/etc/icinga2/pki" "*.crt"
copy_files "/pki-in" "/etc/icinga2/pki" "*.key"

exec "$@"
