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

* Set hostname to "hidden":
  * `hostname hidden`.
  * `echo hidden > /etc/hostname`.
  * `echo $'127.0.0.1 localhost\n127.0.0.1 hidden' > /etc/hosts`.
* Upgrade OS:
  * `apt-get update`.
  * `apt-get upgrade`.
* Add ntpdate to crontab
  * `apt-get install ntpdate`.
  * `echo "@daily root ntpdate -u pool.ntp.org" >> /etc/crontab`.
* Disable and stop ssh and ntp:
  * `systemctl stop ssh`.
  * `systemctl disable ssh`.
  * `systemctl stop ntp`.
  * `systemctl disable ntp`.
* Install git:
  * `apt-get install git`.
* Run grsecurity-Debian-Installer (as root):
  * `cd ~`.
  * `git clone https://github.com/rickard2/grsecurity-Debian-Installer`.
  * `cd grsecurity-Debian-Installer`.
  * `./usr/bin/grsecurity-installer`.
  * Select the only available kernel option (must be a grsecurity supporter for stable).
  * In the linux kernel configuration menu:
    * Select "Security options", then
    * Select "Grsecurity", then
    * Enable "Grsecurity", then
    * Select "Configuration Method", then
    * Select "Automatic", then
    * Select "Usage Type", then
    * Enable "Server".
    * If running as a Virtual Machine:
      * Select "Virtualization Type", then
      * Enable "Guest", then
      * Select "Virtualisation Software", then
      * Enable the appropriate option.
    * Exit the submenus and you will be presented with a "Save" dialog, save.
    * The kernel will compile and be installed as a debian package.
* Reboot:
  * `reboot`
* Run hidden-nginx (as root):
  * `cd ~`.
  * `git clone https://github.com/sinner-/hidden-nginx`.
  * `cd hidden-nginx`
  * `bash build-nginx.sh`
  * `bash setup-ns.sh`
  * `bash setup-php.sh`
  * `bash chroot-nginx.sh`
  * `bash setup-tor.sh`
  * `bash init.sh`

# Destroy

A crude teardown script is included:
* Run `destroy.sh`
