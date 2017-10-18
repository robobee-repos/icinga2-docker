#!/bin/bash
set -e

if [[ "$DEBUG" == "true" ]]; then
  set -x
fi

source /usr/lib/icinga2/icinga2

source /etc/default/icinga2

/usr/lib/icinga2/prepare-dirs /usr/lib/icinga2/icinga2

/usr/sbin/icinga2 daemon --validate

/usr/sbin/icinga2 daemon -e ${ICINGA2_ERROR_LOG}
