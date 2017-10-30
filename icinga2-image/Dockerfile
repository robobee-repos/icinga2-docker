FROM debian:stretch
LABEL maintainer "Erwin Mueller <erwin.mueller@deventm.com>"

RUN set -x \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gnupg \
        lsb-release \
        mailutils \
        procps \
        pwgen \
        snmp \
        unzip \
        wget \
        rsync \
        mysql-client \
        supervisor \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN set -x \
    && wget --quiet -O - https://packages.icinga.org/icinga.key | apt-key add - \
    && echo "deb http://packages.icinga.org/debian icinga-$(lsb_release -cs) main" > /etc/apt/sources.list.d/icinga2.list \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        icinga2 \
        icinga2-ido-mysql \
        icingacli \
        monitoring-plugins \
        nagios-nrpe-plugin \
        nagios-snmp-plugins \
        nagios-plugins-contrib \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ADD rootfs/ /

ENV DEBUG="false" \
  #
  ICINGA2_USER_FULLNAME="Icinga2" \
  #
  ICINGA2_FEATURE_GRAPHITE=true \
  ICINGA2_FEATURE_GRAPHITE_HOST=graphite \
  ICINGA2_FEATURE_GRAPHITE_PORT=2003 \
  #
  ICINGA2_FEATURE_DIRECTOR="true" \
  ICINGA2_FEATURE_DIRECTOR_KICKSTART="true" \
  ICINGA2_FEATURE_DIRECTOR_USER="director" \
  ICINGA2_FEATURE_DIRECTOR_PASSWORD="directorapi" \
  #
  ICINGA2_FEATURE_MYSQL="true" \
  ICINGA2_FEATURE_MYSQL_HOST="mysql" \
  ICINGA2_FEATURE_MYSQL_PORT="3306" \
  ICINGA2_FEATURE_MYSQL_USER="icinga" \
  ICINGA2_FEATURE_MYSQL_PASSWORD="icinga" \
  ICINGA2_FEATURE_MYSQL_DATABASE="icinga"

# Final fixes
RUN set -x \
    && chmod +x /*.sh \
    && sed -i 's/vars\.os.*/vars.os = "Docker"/' /etc/icinga2/conf.d/hosts.conf \
    && usermod -aG nagios www-data \
    && icinga2 feature enable livestatus compatlog command \
    && if [ ! -f "/etc/icinga2/pki/$(hostname).key" ]; then \
    icinga2 node setup --master; \
    fi \
    && chfn -f "${ICINGA2_USER_FULLNAME}" nagios \
    && /enable-mysql.sh \
    && /enable-graphite.sh \
    && mv /etc/icinga2/ /etc/icinga2.dist \
    && mkdir -p /var/log/icinga2 \
    && ln -sf /dev/stdout /var/log/icinga2/icinga2.log \
    && ln -sf /dev/stdout /var/log/icinga2/startup.log \
    && ln -sf /dev/stderr /var/log/icinga2/error.log \
    && mkdir -p /run/icinga2 \
    && chmod o+rwX /run/icinga2 \
    && mkdir -p /var/run/supervisor \
    && chown nagios.nagios /var/run/supervisor \
    && chmod o+rwX /var/run/supervisor \
    && mkdir -p /var/log/supervisor \
    && chown nagios.nagios /var/log/supervisor \
    && chmod o+rwX /var/log/supervisor

EXPOSE 5665

VOLUME /etc/icinga2

USER nagios

CMD ["supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]

ENTRYPOINT ["/docker-entrypoint.sh"]
