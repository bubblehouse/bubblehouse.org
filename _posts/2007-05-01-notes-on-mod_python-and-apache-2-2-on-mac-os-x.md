---
layout: post
title: Notes on Mod_Python and Apache 2.2 on Mac OS X
created: 1178049105
categories:
- !ruby/string:Sequel::SQL::Blob |-
  Y29kaW5n
- !ruby/string:Sequel::SQL::Blob |-
  YXBhY2hl
- !ruby/string:Sequel::SQL::Blob |-
  dW5peA==
- !ruby/string:Sequel::SQL::Blob |-
  Y29tcGlsaW5n
---
I'm hoping to get away from PHP in favor of mod_python, but the first thing I needed to do was get mod_python successfully working on Mac OS X. I tried once before, using the built-in Apache and Python binaries that ship with Mac OS X. At the time (I think this was still 10.4, but it could have been 10.3), the built-in Python wasn't multithreaded (or something like that) and the mod_python developers were starting to move away from Apache 1.3 altogether.

I had success recently compiling mod_python on Mac OS X Server, against the distributed (but inactive) Apache 2 installation in /opt. However, I found OS X Server to be basically garbage, so I did a fresh install of the client version of Mac OS X, and set about getting Apache 2 to compile, and then mod_python.

It was not easy.

### XCode 2.4 Tools

Apache 2 compiles fine with older versions, but mod_python has problems. Make sure to install the latest version of the XCode tools, available at <a href="http://developer.apple.com">Apple's Developer Site</a>.

### Python 2.4.4 (pythonmac.org distribution)
You should be able to use any thread-enabled version of Python, but I choose to use Bob Ippolito's python distribution from (pythonmac.org)[http://pythonmac.org/packages/py24-fat/index.html]. Also, I did choose 2.4.4 instead of 2.5, but I would imagine 2.5 would work just as well.

###Expat 2.0

It looks like Mac OS X 10.4.9 at least doesn't come with a up-to-date version of libexpat, so we install one.

	./configure --mandir=/usr/local/share/man CFLAGS=-O2


###Apache 2.2.4

First cd into srclib/apr and do the usual configure-make (but not install) routine

Then cd into srclib/apr-util and configure it to use our precompiled apr and the new installed version of libexpat:

	./configure --with-apr=../apr --with-expat=/usr/local

followed by a make (but again, no install).

Finally, in the main Apache2 build directory, run this configure line to somewhat mimic the Debian style:

	CFLAGS="-arch ppc -isysroot /Developer/SDKs/MacOSX10.4u.sdk" \
	./configure --prefix=/etc/apache2 --exec-prefix=/usr/local --datadir=/usr/local/share \
	--sysconfdir=/etc/apache2 --sharedstatedir=/usr/local/common --localstatedir=/usr/local/var \
	--includedir=/usr/local/include --infodir=/usr/local/info --mandir=/usr/local/man --enable-so \
	--enable-mods-shared=all --with-mpm=prefork --with-apr=srclib/apr --with-apr-util=srclib/apr-util

### Tweaks and Configuration Changes

First of all, I had to turn off a number of extra modules I don't ever use. I like having them around, which is why I built them all, but I also discovered I don't know quite as much about which-modules-do-what as I thought I did. A little investigation later and things were good, except for the following:

* Had to make sure the TypesConfig directive was pointing to the right place, with: `TypesConfig /private/etc/httpd/mime.types`
* For now, Apache doesn't seem to know where to look for the config file. It tries to find it at `/httpd.conf`, so for now I have to launch the apache process manually, and can't use <tt>apachectl</tt>. This is probably a problem with my configure line, but I can't figure out what, since I definitely included `--sysconfdir`
* For some reason, after all this I had a problem with my Subversion installation. Normally, I use the subversion package found at (Metissian)[http://metissian.com/projects/macosx/subversion/], but this seemed damaged or otherwise broken because I was getting an error similar to the one I was getting from the mod_python configure process (before I recompiled expat).

### Retarded Hacks to Fix above

after config, in <tt>include/ap_config_auto.h</tt>
Change AP_TYPES_CONFIG_FILE to /private/etc/httpd/mime.types
Change SERVER_CONFIG_FILE to /etc/apache2/httpd.conf

### mod_python 3.3.1

	./configure --with-apxs2=/usr/local/bin/apxs --with-python=/usr/local/bin/python2.4
