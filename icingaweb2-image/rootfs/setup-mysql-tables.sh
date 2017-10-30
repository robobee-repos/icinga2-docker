#!/bin/bash
set -e

function create_icingaweb() {
  script_file=/usr/share/icingaweb2/etc/schema/mysql.schema.sql
  ICINGAWEB2_ADMIN_PASS_HASH=$(openssl passwd -1 "${ICINGAWEB2_ADMIN_PASSWORD}")
  export MYSQL_PWD="${ICINGAWEB2_FEATURE_MYSQL_PASSWORD}"
  set +e
  mysql -h ${ICINGAWEB2_FEATURE_MYSQL_HOST} \
    -u ${ICINGAWEB2_FEATURE_MYSQL_USER} \
    -D ${ICINGAWEB2_FEATURE_MYSQL_DATABASE} \
    -e 'SELECT * from icingaweb_group'
  ret=$?
  set -e
  if [[ $ret -ne 0 ]]; then
    mysql -h ${ICINGAWEB2_FEATURE_MYSQL_HOST} \
      -u ${ICINGAWEB2_FEATURE_MYSQL_USER} \
      -D ${ICINGAWEB2_FEATURE_MYSQL_DATABASE} << EOF
ALTER DATABASE ${ICINGAWEB2_FEATURE_MYSQL_DATABASE} CHARACTER SET latin1 COLLATE latin1_general_ci;
EOF
    mysql -h ${ICINGAWEB2_FEATURE_MYSQL_HOST} \
      -u ${ICINGAWEB2_FEATURE_MYSQL_USER} \
      -D ${ICINGAWEB2_FEATURE_MYSQL_DATABASE} < $script_file
  fi
  mysql -h ${ICINGAWEB2_FEATURE_MYSQL_HOST} \
    -u ${ICINGAWEB2_FEATURE_MYSQL_USER} \
    -D ${ICINGAWEB2_FEATURE_MYSQL_DATABASE} << EOF
INSERT IGNORE INTO icingaweb_user (name, active, password_hash) VALUES ('${ICINGAWEB2_ADMIN_USER}', 1, '${ICINGAWEB2_ADMIN_PASS_HASH}');
EOF
}

function create_director() {
  script_file=/usr/local/share/icingaweb2/modules/director/schema/mysql.sql
  export MYSQL_PWD="${ICINGAWEB2_FEATURE_DIRECTOR_MYSQL_PASSWORD}"
  set +e
  mysql -h ${ICINGAWEB2_FEATURE_DIRECTOR_MYSQL_HOST} \
    -u ${ICINGAWEB2_FEATURE_DIRECTOR_MYSQL_USER} \
    -D ${ICINGAWEB2_FEATURE_DIRECTOR_MYSQL_DATABASE} \
    -e 'SELECT * from director_setting'
  ret=$?
  set -e
  if [[ $ret -ne 0 ]]; then
    mysql -h ${ICINGAWEB2_FEATURE_DIRECTOR_MYSQL_HOST} \
      -u ${ICINGAWEB2_FEATURE_DIRECTOR_MYSQL_USER} \
      -D ${ICINGAWEB2_FEATURE_DIRECTOR_MYSQL_DATABASE} < $script_file
  fi
}

source /docker-entrypoint-utils.sh
set_debug

if [[ "${ICINGAWEB2_FEATURE_MYSQL}" == "true" ]]; then
  create_icingaweb
fi

if [[ "${ICINGAWEB2_FEATURE_DIRECTOR_MYSQL}" == "true" ]]; then
  create_director
fi
