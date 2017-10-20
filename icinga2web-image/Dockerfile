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
        php-curl \
        php-ldap \
        php-mysql \
        php-gettext \
        php-intl \
        php-mbstring \
        php-fpm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN set -x \
    && wget --quiet -O - https://packages.icinga.org/icinga.key | apt-key add - \
    && echo "deb http://packages.icinga.org/debian icinga-$(lsb_release -cs) main" > /etc/apt/sources.list.d/icinga2.list \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        icingacli \
        icingaweb2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ADD rootfs/ /

ARG GITREF_ICINGAWEB2=master
ARG GITREF_DIRECTOR=master
ARG GITREF_MODGRAPHITE=master
ARG GITREF_MODAWS=master

# Temporary hack to get icingaweb2 modules via git
RUN set -x \
    && mkdir -p /usr/local/share/icingaweb2/modules/ \
    && wget -q --no-cookies -O - "https://github.com/Icinga/icingaweb2/archive/${GITREF_ICINGAWEB2}.tar.gz" \
    | tar xz --strip-components=2 --directory=/usr/local/share/icingaweb2/modules -f - icingaweb2-${GITREF_ICINGAWEB2}/modules/monitoring icingaweb2-${GITREF_ICINGAWEB2}/modules/doc

RUN set -x \
# Icinga Director
    && mkdir -p /usr/local/share/icingaweb2/modules/director/ \
    && mkdir -p /etc/icingaweb2/userModules \
    && wget -q --no-cookies -O - "https://github.com/Icinga/icingaweb2-module-director/archive/${GITREF_DIRECTOR}.tar.gz" \
    | tar xz --strip-components=1 --directory=/usr/local/share/icingaweb2/modules/director --exclude=.gitignore -f - \
    && icingacli module enable director

RUN set -x \
# Icingaweb2 Graphite
    && mkdir -p /usr/local/share/icingaweb2/modules/graphite \
    && wget -q --no-cookies -O - "https://github.com/Icinga/icingaweb2-module-graphite/archive/${GITREF_MODGRAPHITE}.tar.gz" \
    | tar xz --strip-components=1 --directory=/usr/local/share/icingaweb2/modules/graphite -f - icingaweb2-module-graphite-${GITREF_MODGRAPHITE}/ \
    && cp -r /usr/local/share/icingaweb2/modules/graphite/templates/ /etc/icingaweb2/modules/graphite

RUN set -x \
# Icingaweb2 AWS
    && mkdir -p /usr/local/share/icingaweb2/modules/aws \
    && wget -q --no-cookies -O - "https://github.com/Icinga/icingaweb2-module-aws/archive/${GITREF_MODAWS}.tar.gz" \
    | tar xz --strip-components=1 --directory=/usr/local/share/icingaweb2/modules/aws -f - icingaweb2-module-aws-${GITREF_MODAWS}/ \
    && wget -q --no-cookies "https://github.com/aws/aws-sdk-php/releases/download/2.8.30/aws.zip" \
    && unzip -d /usr/local/share/icingaweb2/modules/aws/library/vendor/aws aws.zip \
    && rm aws.zip

ENV DEBUG="false" \
  #
  ICINGAWEB2_FEATURE_GRAPHITE=true \
  ICINGAWEB2_FEATURE_GRAPHITE_HOST=graphite \
  ICINGAWEB2_FEATURE_GRAPHITE_PORT=2003 \
  ICINGAWEB2_FEATURE_GRAPHITE_URL=http://graphite \
  ICINGAWEB2_FEATURE_DIRECTOR="true" \
  ICINGAWEB2_FEATURE_DIRECTOR_KICKSTART="true" \
  ICINGAWEB2_FEATURE_DIRECTOR_ENDPOINT="$(hostname)" \
  ICINGAWEB2_FEATURE_DIRECTOR_HOST="icinga" \
  ICINGAWEB2_FEATURE_DIRECTOR_PORT="5665" \
  ICINGAWEB2_FEATURE_DIRECTOR_USER="director" \
  ICINGAWEB2_FEATURE_DIRECTOR_PASSWORD="directorapi" \
  #
  ICINGAWEB2_ADMIN_USER="icingaadmin" \
  ICINGAWEB2_ADMIN_PASSWORD="icinga" \
  #
  ICINGAWEB2_FEATURE_MYSQL="true" \
  ICINGAWEB2_FEATURE_MYSQL_HOST="icingawebdb" \
  ICINGAWEB2_FEATURE_MYSQL_PORT="3306" \
  ICINGAWEB2_FEATURE_MYSQL_USER="icingaweb" \
  ICINGAWEB2_FEATURE_MYSQL_PASSWORD="icingaweb" \
  ICINGAWEB2_FEATURE_MYSQL_DATABASE="icingaweb" \
  #
  ICINGAWEB2_FEATURE_DIRECTOR_MYSQL="true" \
  ICINGAWEB2_FEATURE_DIRECTOR_MYSQL_HOST="icingawebdb" \
  ICINGAWEB2_FEATURE_DIRECTOR_MYSQL_PORT="3306" \
  ICINGAWEB2_FEATURE_DIRECTOR_MYSQL_USER="icingaweb" \
  ICINGAWEB2_FEATURE_DIRECTOR_MYSQL_PASSWORD="icingaweb" \
  ICINGAWEB2_FEATURE_DIRECTOR_MYSQL_DATABASE="icingaweb" \
  #
  ICINGA2_FEATURE_MYSQL="true" \
  ICINGA2_FEATURE_MYSQL_HOST="icingadb" \
  ICINGA2_FEATURE_MYSQL_PORT="3306" \
  ICINGA2_FEATURE_MYSQL_USER="icinga" \
  ICINGA2_FEATURE_MYSQL_PASSWORD="icinga" \
  ICINGA2_FEATURE_MYSQL_DATABASE="icinga" \
  #
  PHP_MAX_EXECUTION_TIME=300 \
  PHP_MEMORY_LIMIT_MB=128 \
  PHP_FPM_MAX_CHILDREN=10 \
  PHP_FPM_START_SERVERS=2 \
  PHP_FPM_MIN_SPARE_SERVERS=2 \
  PHP_FPM_MAX_SPARE_SERVERS=5 \
  PHP_FPM_MAX_REQUESTS=500 \
  PHP_FPM_REQUEST_SLOWLOG_TIMEOUT=30 \
  PHP_FPM_CATCH_WORKERS_OUTPUT=1 \
  PHP_OPCACHE_ENABLE_CLI=1 \
  PHP_OPCACHE_ENABLE=1 \
  PHP_OPCACHE_MEMORY_CONSUMPTION_MB=128 \
  PHP_OPCACHE_MAX_ACCELERATED_FILES=4000

RUN set -x \
    && icingacli module enable monitoring \
    && icingacli module enable doc \
    && icingacli module enable graphite

# Final fixes
RUN set -x \
    && chmod +x /*.sh \
    && usermod -aG icingaweb2 www-data \
    && mv /etc/icingaweb2/ /etc/icingaweb2.dist \
    && mv /usr/share/icingaweb2/ /usr/share/icingaweb2.dist \
    && mkdir -p /var/log/icingaweb2 \
    && ln -sf /dev/stdout /var/log/icingaweb2/icingaweb2.log

# Php configuration.

RUN set -x \
  && mkdir -p /run/php \
  && chown www-data.www-data /run/php \
  && ln -sf /dev/stdout /var/log/php-fpm-slow.log \
  && mkdir -p /php-in \
  && mkdir -p /php-fpm-in

EXPOSE 9000

VOLUME /etc/icingaweb2 \
    /usr/share/icingaweb2

USER www-data

CMD ["/run-icinga2web.sh"]

ENTRYPOINT ["/docker-entrypoint.sh"]
