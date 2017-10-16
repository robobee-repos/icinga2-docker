# Piwik-Noroot

## Description

The image modifies the base image to run as non-privileged user `www-data`.
Furthermore, it adds the option to have a input directory for configuration
files that can be used with Kubernetes Config Map. In addition, it adds
rsync to sync the Piwik source from `/usr/src/piwik` to `/var/www/html`
the web root directory. That is necessary if the web root directory is mounted
as a Kubernetes Persistent Volume and a newer image is deployed the source 
will not update the deployment.

## Input Configration

| Source | Destination |
| ------------- | ------------- |
| /php-in/php.ini | /usr/local/etc/php/php.ini |
| /php-confd-in/* | /usr/local/etc/php/conf.d/ |

## Test

The docker-compose file `test.yaml` can be used to startup MySQL and the
Piwik container. The installation can be then accessed
from `localhost:8080`.

```
docker-compose -f test.yaml up &
```
