#!/bin/bash
set -e

if [[ "$DEBUG" == "true" ]]; then
  set -x
fi

function create_tables() {
  set +e
  MYSQL_PWD="${ICINGA2_FEATURE_MYSQL_PASSWORD}" \
    mysql -h ${ICINGA2_FEATURE_MYSQL_HOST} \
      -u ${ICINGA2_FEATURE_MYSQL_USER} \
      -D ${ICINGA2_FEATURE_MYSQL_DATABASE} \
      -e 'SELECT * from icinga_dbversion'
  ret=$?
  set -e
  if [[ $ret -eq 0 ]]; then
    return
  fi
  script_file=/usr/share/icinga2-ido-mysql/schema/mysql.sql
  MYSQL_PWD="${ICINGA2_FEATURE_MYSQL_PASSWORD}" \
    mysql -h ${ICINGA2_FEATURE_MYSQL_HOST} \
      -u ${ICINGA2_FEATURE_MYSQL_USER} \
      -D ${ICINGA2_FEATURE_MYSQL_DATABASE} < $script_file
}

if [[ "${ICINGA2_FEATURE_MYSQL}" != "true" ]]; then
  exit
fi

create_tables
