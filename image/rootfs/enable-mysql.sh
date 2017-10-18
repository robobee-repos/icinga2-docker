#!/bin/bash
set -e

function mysql_conf() {
  cat << EOF > /etc/icinga2/features-available/ido-mysql.conf
library "db_ido_mysql"

object IdoMysqlConnection "mysql-ido" {
    host = "${ICINGA2_FEATURE_MYSQL_HOST}"
    port = ${ICINGA2_FEATURE_MYSQL_PORT}
    user = "${ICINGA2_FEATURE_MYSQL_USER}"
    password = "${ICINGA2_FEATURE_MYSQL_PASSWORD}"
    database = "${ICINGA2_FEATURE_MYSQL_DATABASE}"

    cleanup = {
        downtimehistory_age = 48h
        contactnotifications_age = 31d
    }
}
EOF
}

if [[ "${ICINGA2_FEATURE_MYSQL}" != "true" ]]; then
  exit
fi
mysql_conf
icinga2 feature enable ido-mysql
