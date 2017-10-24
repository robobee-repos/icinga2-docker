#!/bin/bash
set -e

if [[ "$DEBUG" == "true" ]]; then
  set -x
fi

function check_files_exists() {
  ls $1 1> /dev/null 2>&1
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
  rsync -vL ${dir}/*.conf ${dest}/
}

function copy_pki() {
  dir="pki-in";
  if [ ! -d ${dir} ]; then
    return
  fi
  cd "${dir}"
  if ! check_files_exists "*.crt"; then
    return
  fi
  rsync -vL ${dir}/*.crt /etc/icinga2/pki/
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
copy_pki

exec "$@"
