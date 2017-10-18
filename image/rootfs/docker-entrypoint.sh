#!/bin/bash
set -e

if [[ "$DEBUG" == "true" ]]; then
  set -x
fi

function check_files_exists() {
  ls "$1" 1> /dev/null 2>&1
}

function api_user_conf() {
  if [[ "${ICINGA2_FEATURE_API}" != "true" ]]; then
    return
  fi
  cat << EOF > /etc/icinga2/conf.d/api-user.conf
object ApiUser "${ICINGA2_FEATURE_API_USER}" {
  password = "${ICINGA2_FEATURE_API_PASSWORD}"
  permissions = ${ICINGA2_FEATURE_API_PERMISSIONS}
}
EOF
}

function copy_conf() {
  dir="$1"; shift
  dest="$1"; shift
  if [ ! -d ${dir} ]; then
    return
  fi
  cd "${dir}"
  if ! check_files_exists "*.conf"; then
    return
  fi
  rsync -v "${dir}/*.conf" ${dest}/
}

function sync_icinga() {
  cd /etc/icinga2
  rsync -rlD -u /etc/icinga2.dist/. .
}
 
echo "Running as `id`"

sync_icinga
copy_conf /icinga2-in /etc/icinga2
copy_conf /conf-in /etc/icinga2/conf.d
copy_conf /features-in /etc/icinga2/features-available
copy_conf /repository-in /etc/icinga2/repository.d
copy_conf /zones-in /etc/icinga2/zones.d
api_user_conf

exec "$@"
