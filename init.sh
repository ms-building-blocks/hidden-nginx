#!/usr/bin/env bash
NS_EXISTS=`ip netns | grep nginx`
if [ -z $NS_EXISTS ]; then
  echo "Please run setup-ns.sh before running this script."
  exit -1
fi

ip netns exec nginx chroot /home/nginx /usr/local/nginx/sbin/nginx
systemctl daemon-reload
systemctl start php5-fpm
/etc/init.d/tor-chroot start &> /dev/null
