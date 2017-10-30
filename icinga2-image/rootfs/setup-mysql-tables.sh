#!/bin/bash
set -e

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
  export MYSQL_PWD="${ICINGA2_FEATURE_MYSQL_PASSWORD}"
    mysql -h ${ICINGA2_FEATURE_MYSQL_HOST} \
      -u ${ICINGA2_FEATURE_MYSQL_USER} \
      -D ${ICINGA2_FEATURE_MYSQL_DATABASE} << EOF
ALTER DATABASE ${ICINGA2_FEATURE_MYSQL_DATABASE} CHARACTER SET latin1 COLLATE latin1_general_ci;
EOF
  mysql -h ${ICINGA2_FEATURE_MYSQL_HOST} \
    -u ${ICINGA2_FEATURE_MYSQL_USER} \
    -D ${ICINGA2_FEATURE_MYSQL_DATABASE} < $script_file
}

if [[ "${ICINGA2_FEATURE_MYSQL}" != "true" ]]; then
  exit
fi

source /docker-entrypoint-utils.sh
set_debug
create_tables
