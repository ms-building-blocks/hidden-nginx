#!/usr/bin/env bash

set -e

NGINX_VERSION="1.9.9"
NGINX_TARBALL="nginx-${NGINX_VERSION}.tar.gz"

apt-get -y install libxslt1-dev libxml2-dev zlib1g-dev libpcre3-dev libbz2-dev build-essential

rm -rf nginx-${NGINX_VERSION}
wget "http://nginx.org/download/${NGINX_TARBALL}"
tar xvzf "${NGINX_TARBALL}" && rm -f "${NGINX_TARBALL}"

cd "nginx-${NGINX_VERSION}"
./configure \
  --with-cpu-opt=amd64 \
  --with-ld-opt="-static" \
  --with-http_stub_status_module \
  --with-http_gzip_static_module \
  --with-file-aio \
  --with-pcre \
  --with-cc-opt="-O2 -static -static-libgcc -fstack-protector-all --param ssp-buffer-size=4 -ftrapv -Wl,-z,relro,-z,now -D_FORTIFY_SOURCE=2" \
  --without-http_charset_module \
  --without-http_ssi_module \
  --without-http_userid_module \
  --without-http_auth_basic_module \
  --without-http_autoindex_module \
  --without-http_geo_module \
  --without-http_map_module \
  --without-http_split_clients_module \
  --without-http_referer_module \
  --without-http_proxy_module \
  --without-http_uwsgi_module \
  --without-http_scgi_module \
  --without-http_memcached_module \
  --without-http_empty_gif_module \
  --without-http_browser_module \
  --without-http_upstream_ip_hash_module \
  --without-http_upstream_least_conn_module \
  --without-http_upstream_keepalive_module \
  --without-mail_pop3_module \
  --without-mail_imap_module \
  --without-mail_smtp_module

sed -i "/CFLAGS/s/ \-O //g" objs/Makefile

make && make install
