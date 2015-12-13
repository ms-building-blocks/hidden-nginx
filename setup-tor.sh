#!/usr/bin/env bash

apt-get install tor
systemctl stop tor
systemctl disable tor
git clone https://github.com/sinner-/tor-chroot
cd tor-chroot
make install
tor-chroot-update.sh
cd -
cp -fv torrc /home/tor-chroot/etc/tor/torrc
