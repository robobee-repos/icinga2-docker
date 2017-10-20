#!/bin/bash
set -e

if [[ "$DEBUG" == "true" ]]; then
  set -x
fi

function setup_director_user() {
  if [[ "${ICINGA2_FEATURE_DIRECTOR}" != "true" ]]; then
    return
  fi
  cat > /etc/icinga2/conf.d/director-user.conf << EOF
object ApiUser "${ICINGA2_FEATURE_DIRECTOR_USER}" {
  password = "${ICINGA2_FEATURE_DIRECTOR_PASSWORD}"
  permissions = [ "*" ]
}
EOF
}

setup_director_user

source /usr/lib/icinga2/icinga2

source /etc/default/icinga2

/usr/lib/icinga2/prepare-dirs /usr/lib/icinga2/icinga2

/usr/sbin/icinga2 daemon --validate

/usr/sbin/icinga2 daemon -e ${ICINGA2_ERROR_LOG}
