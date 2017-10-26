#!/bin/bash
set -e

if [[ "$DEBUG" == "true" ]]; then
  set -x
fi

function do_sed() {
  ## TEMP File
  TFILE=`mktemp --tmpdir tfile.XXXXX`
  trap "rm -f $TFILE" EXIT

  file="$1"; shift
  search="$1"; shift
  replace="$1"; shift
  sed -r -e "s|(${search})|${replace}|g" $file > $TFILE
  cat $TFILE > $file
}

do_sed /etc/icingaweb2/resources.ini '%ICINGAWEB2_FEATURE_MYSQL_HOST%' "${ICINGAWEB2_FEATURE_MYSQL_HOST}"
do_sed /etc/icingaweb2/resources.ini '%ICINGAWEB2_FEATURE_MYSQL_PORT%' "${ICINGAWEB2_FEATURE_MYSQL_PORT}"
do_sed /etc/icingaweb2/resources.ini '%ICINGAWEB2_FEATURE_MYSQL_DATABASE%' "${ICINGAWEB2_FEATURE_MYSQL_DATABASE}"
do_sed /etc/icingaweb2/resources.ini '%ICINGAWEB2_FEATURE_MYSQL_USER%' "${ICINGAWEB2_FEATURE_MYSQL_USER}"
do_sed /etc/icingaweb2/resources.ini '%ICINGAWEB2_FEATURE_MYSQL_PASSWORD%' "${ICINGAWEB2_FEATURE_MYSQL_PASSWORD}"

do_sed /etc/icingaweb2/resources.ini '%ICINGA2_FEATURE_MYSQL_HOST%' "${ICINGA2_FEATURE_MYSQL_HOST}"
do_sed /etc/icingaweb2/resources.ini '%ICINGA2_FEATURE_MYSQL_PORT%' "${ICINGA2_FEATURE_MYSQL_PORT}"
do_sed /etc/icingaweb2/resources.ini '%ICINGA2_FEATURE_MYSQL_DATABASE%' "${ICINGA2_FEATURE_MYSQL_DATABASE}"
do_sed /etc/icingaweb2/resources.ini '%ICINGA2_FEATURE_MYSQL_USER%' "${ICINGA2_FEATURE_MYSQL_USER}"
do_sed /etc/icingaweb2/resources.ini '%ICINGA2_FEATURE_MYSQL_PASSWORD%' "${ICINGA2_FEATURE_MYSQL_PASSWORD}"

do_sed /etc/icingaweb2/resources.ini '%ICINGAWEB2_FEATURE_DIRECTOR_MYSQL_HOST%' "${ICINGAWEB2_FEATURE_DIRECTOR_MYSQL_HOST}"
do_sed /etc/icingaweb2/resources.ini '%ICINGAWEB2_FEATURE_DIRECTOR_MYSQL_PORT%' "${ICINGAWEB2_FEATURE_DIRECTOR_MYSQL_PORT}"
do_sed /etc/icingaweb2/resources.ini '%ICINGAWEB2_FEATURE_DIRECTOR_MYSQL_DATABASE%' "${ICINGAWEB2_FEATURE_DIRECTOR_MYSQL_DATABASE}"
do_sed /etc/icingaweb2/resources.ini '%ICINGAWEB2_FEATURE_DIRECTOR_MYSQL_USER%' "${ICINGAWEB2_FEATURE_DIRECTOR_MYSQL_USER}"
do_sed /etc/icingaweb2/resources.ini '%ICINGAWEB2_FEATURE_DIRECTOR_MYSQL_PASSWORD%' "${ICINGAWEB2_FEATURE_DIRECTOR_MYSQL_PASSWORD}"

do_sed /etc/icingaweb2/modules/director/kickstart.ini '%ICINGAWEB2_FEATURE_DIRECTOR_ENDPOINT%' "${ICINGAWEB2_FEATURE_DIRECTOR_ENDPOINT}"
do_sed /etc/icingaweb2/modules/director/kickstart.ini '%ICINGAWEB2_FEATURE_DIRECTOR_HOST%' "${ICINGAWEB2_FEATURE_DIRECTOR_HOST}"
do_sed /etc/icingaweb2/modules/director/kickstart.ini '%ICINGAWEB2_FEATURE_DIRECTOR_PORT%' "${ICINGAWEB2_FEATURE_DIRECTOR_PORT}"
do_sed /etc/icingaweb2/modules/director/kickstart.ini '%ICINGAWEB2_FEATURE_DIRECTOR_USER%' "${ICINGAWEB2_FEATURE_DIRECTOR_USER}"
do_sed /etc/icingaweb2/modules/director/kickstart.ini '%ICINGAWEB2_FEATURE_DIRECTOR_PASSWORD%' "${ICINGAWEB2_FEATURE_DIRECTOR_PASSWORD}"

do_sed /etc/icingaweb2/modules/graphite/config.ini '%ICINGAWEB2_FEATURE_GRAPHITE_URL%' "${ICINGAWEB2_FEATURE_GRAPHITE_URL}"

exec /usr/sbin/php-fpm7.0
