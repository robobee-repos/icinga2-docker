FROM  redis:3.2
LABEL maintainer "Erwin Mueller <erwin.mueller@deventm.com>"

# Finishing up.

USER redis

WORKDIR /data

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["redis-server"]
