#!/usr/bin/env bash

pkill nginx
systemctl stop php5-fpm
ip netns exec nginx ip link set veth1 down
ip netns exec nginx ip link del veth1
#veth0 paired to veth1, deleted automatically
ip netns del nginx
/etc/init.d/tor-chroot stop
