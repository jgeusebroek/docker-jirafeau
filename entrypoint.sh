#!/bin/sh

addgroup -g ${GID} jirafeau && adduser -h /jirafeau -s /bin/sh -D -G jirafeau -u ${UID} jirafeau
touch /var/run/php-fpm.sock

if [ -d /jirafeau/lib/config.local.php ]; then
	rm -rf /jirafeau/lib/config.local.php
fi

if [ ! -f /jirafeau/lib/config.local.php ]; then
	touch /jirafeau/lib/config.local.php
fi

if [ ! -d /data ]; then
	mkdir /data
fi

chown -R jirafeau:jirafeau /jirafeau /var/run/php-fpm.sock /var/lib/nginx /tmp /data
supervisord -c /usr/local/etc/supervisord.conf