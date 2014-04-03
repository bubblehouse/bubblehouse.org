---
layout: post
title: Compiling PHP 5.2.10 on Mac OS X 10.5.7
created: 1246402229
categories: []
---
<code>
MACOSX_DEPLOYMENT_TARGET=10.5 CFLAGS="-arch ppc -g -Os -pipe -no-cpp-precomp" CCFLAGS="-arch ppc -g -Os -pipe" CXXFLAGS="-arch ppc -g -Os -pipe" LDFLAGS="-arch ppc -bind_at_load" ./configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-apxs2=/usr/sbin/apxs --with-ldap=/usr --with-kerberos=/usr --enable-cli --with-zlib-dir=/usr --enable-exif --enable-mbstring --enable-mbregex --enable-sockets --with-iodbc=/usr --with-config-file-path=/etc --sysconfdir=/private/etc --with-iconv=shared,/opt/local --with-openssl=shared,/opt/local --with-xmlrpc --with-xsl=/usr --with-gd --with-mysqli=/usr/local/mysql/bin/mysql_config --with-png-dir=/opt/local
</code>
