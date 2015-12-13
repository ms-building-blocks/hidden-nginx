# hidden-nginx

## Overview

This repository is a Proof of Concept for running tor hidden web services.

The server is configured as follows:

Configuration:

* debian jessie
* grsecurity patched kernel (no RBAC) incl chroot hardening
* statically compiled nginx (from src) with fastcgi and acl modules running in chroot
* php5-fpm (from debian repo) configured to run in above chroot
* static busybox (from repo) installed in chroot
* both nginx and fpm are running in a linux network namespace
* a veth pair which spans the default and nginx namespace
* both veth interfaces are configured to live on the same subnet
* tor hidden server running in chroot configured to point to nginx port 80

## Setup

*NOTE:* Setup for hidden services should be conducted using the console rather than 
over ssh. This document assumes that console access is available.

Setup steps for a freshly installed Debian Jessie server:

* set hostname to "hidden":
  * `hostname hidden`
  * `echo hidden > /etc/hostname`
* upgrade OS:
  * `apt-get update`
  * `apt-get -y upgrade`
* add ntpdate to crontab
  * `apt-get install ntpdate`
  * `echo "@daily root ntpdate -u pool.ntp.org" >> /etc/crontab`
* shutdown and disable ssh and ntp:
  * `systemctl stop ssh`
  * `systemctl disable ssh`
  * `systemctl stop ntp`
  * `systemctl disable ntp`
* install git:
  * `apt-get install git`
* Run grsecurity-Debian-Installer:
  * `git clone https://github.com/rickard2/grsecurity-Debian-Installer`
  * `cd grsecurity-Debian-Installer`
  * `make`
* reboot:
  * `reboot`
* Run `bash build-nginx.sh`
* Run `bash setup-ns.sh`
* Run `bash setup-php.sh`
* Run `bash chroot-nginx.sh`
* Run `bash setup-tor.sh`
* Run `bash init.sh`

# Destroy

A crude teardown script is included:
* Run `destroy.sh`
