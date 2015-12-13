#!/usr/bin/env bash
apt-get install php5-fpm
systemctl stop php5-fpm
sed -i 's/^ExecStart=.*/ExecStart=\/sbin\/ip netns exec nginx php5-fpm --nodaemonize --fpm-config \/etc\/php5\/fpm\/php-fpm.conf/' /lib/systemd/system/php5-fpm.service
sed -i 's/^;chroot.*/chroot = \/home\/nginx/' /etc/php5/fpm/pool.d/www.conf
sed -i 's/^listen = .*/listen = 9000/' /etc/php5/fpm/pool.d/www.conf
sed -i 's/^;cgi.fix_pathinfo.*/cgi.fix_pathinfo = 0/' /etc/php5/fpm/pool.d/www.conf
