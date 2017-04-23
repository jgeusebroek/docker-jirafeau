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

chown -R jirafeau:jirafeau /jirafeau /var/run/php-fpm.sock /var/lib/nginx /tmp /data /cfg
supervisord -c /usr/local/etc/supervisord.conf