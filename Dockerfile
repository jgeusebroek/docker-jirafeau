FROM alpine:latest
MAINTAINER Jeroen Geusebroek <me@jeroengeusebroek.nl>

ENV GID=4000 UID=4000

RUN apk -U add \
    bash \
    curl \
    nginx \
    php7-fpm \
    php7-gd \
    php7-mcrypt \
    php7-json \
    php7-zlib \
    supervisor \
    tini \
    ca-certificates \
    tar \

 && mkdir jirafeau && cd jirafeau \
 && curl -L -o jirafeau.tar.gz https://gitlab.com/mojo42/Jirafeau/repository/archive.tar.gz \
 && tar xvzf jirafeau.tar.gz --strip 1 \
 && rm jirafeau.tar.gz \

 && apk del tar ca-certificates curl libcurl \
 && rm -f /var/cache/apk/*

COPY files/nginx.conf /etc/nginx/nginx.conf
COPY files/php-fpm.conf /etc/php7/php-fpm.conf
COPY files/supervisord.conf /usr/local/etc/supervisord.conf
COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

VOLUME [ "/data", "/jirafeau/lib/config.local.php" ]

EXPOSE 80
LABEL description "Jirafeau is a web site permitting to upload a file in a simple way and give an unique link to it."
CMD ["/sbin/tini","--","/entrypoint.sh"]