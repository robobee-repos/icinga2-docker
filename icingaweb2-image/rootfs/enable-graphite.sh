#!/bin/bash
set -e

if [[ "$DEBUG" == "true" ]]; then
  set -x
fi

function graphite_conf() {
  cat << EOF > /etc/icinga2/features-available/graphite.conf
/*
 * The GraphiteWriter type writes check result metrics and
 * performance data to a graphite tcp socket.
 */
library "perfdata"
object GraphiteWriter "graphite" {
  host = "$ICINGA2_FEATURE_GRAPHITE_HOST"
  port = "$ICINGA2_FEATURE_GRAPHITE_PORT"
  enable_send_thresholds = true
}
EOF
}

if [[ "${ICINGA2_FEATURE_GRAPHITE}" != "true" ]]; then
  exit
fi
graphite_conf
icinga2 feature enable graphite
