#!/bin/sh

addgroup -g ${GID} jirafeau && adduser -h /jirafeau -s /bin/sh -D -G jirafeau -u ${UID} jirafeau
touch /var/run/php-fpm.sock

if [ ! -d /cfg ]; then
	mkdir /cfg
fi

if [ ! -d /data ]; then
	mkdir /data
fi

if [ ! -f /cfg/config.local.php ]; then
	touch /cfg/config.local.php
fi

if [ ! -L /jirafeau/lib/config.local.php ]; then
	rm -f /jirafeau/lib/config.local.php
	ln -s /cfg/config.local.php /jirafeau/lib/config.local.php
fi

if [ ! -f /cfg/nginx.conf ]; then
	cp /etc/nginx/nginx.original.conf /cfg/nginx.conf
fi

if [ ! -L /etc/nginx/nginx.conf ]; then
	rm -f /etc/nginx/nginx.conf
	ln -s /cfg/nginx.conf /etc/nginx/nginx.conf
fi

if [ ! -f /cfg/php-fpm.conf ]; then
	cp /etc/php7/php-fpm.original.conf /cfg/php-fpm.conf
fi

if [ ! -L /etc/php7/php-fpm.conf ]; then
	rm -f /etc/php7/php-fpm.conf
	ln -s /cfg/php-fpm.conf /etc/php7/php-fpm.conf
fi

chown -R jirafeau:jirafeau /jirafeau /var/run/php-fpm.sock /var/lib/nginx /tmp /data /cfg /var/tmp/nginx
supervisord -c /usr/local/etc/supervisord.conf
