---
layout: post
title: 64-bit MySQL and DBD::mysql Woes
created: 1180893904
categories:
- coding
- unix
- mysql
- compiling
---
I was attempting to install DBD::mysql today, and I ran into a fiendishly difficult problem.

I've installed the mysql drivers for Perl countless times, but this time for some reason, I was getting the following error:

<code>ool-4577f347:~/.cpan/build/DBD-mysql-4.004 root# make
cc -c  -I/Library/Perl/5.8.6/darwin-thread-multi-2level/auto/DBI -I/usr/local/mysql/include -Os -arch ppc64 -fno-common -DDBD_MYSQL_INSERT_ID_IS_GOOD -g  -g -pipe -fno-common -DPERL_DARWIN -no-cpp-precomp -fno-strict-aliasing -I/usr/local/include -Os   -DVERSION=\"4.004\" -DXS_VERSION=\"4.004\"  "-I/System/Library/Perl/5.8.6/darwin-thread-multi-2level/CORE"   dbdimp.c
dbdimp.c: In function 'mysql_dr_connect':
dbdimp.c:1565: error: 'ulong' undeclared (first use in this function)
dbdimp.c:1565: error: (Each undeclared identifier is reported only once
dbdimp.c:1565: error: for each function it appears in.)
dbdimp.c:1565: error: parse error before numeric constant
dbdimp.c:1567: error: parse error before numeric constant
dbdimp.c:1681: error: parse error before numeric constant
make: *** dbdimp.o Error 1
</code>
<!--break-->

I found a tip over at <a href="http://fuel.stuffo.info/blog/archives/11">http://fuel.stuffo.info/blog/archives/11</a>, and added a line to /usr/local/mysql/include/mysql_com.h:

<code>typedef unsigned long	ulong;
</code>

Once I did that, I got through that error, but I had problems at the linking stage, getting an error  like:

<code>/usr/bin/ld: truncated or malformed archive: /usr/local/mysql/lib/libmysqlclient.a (ranlib structures in table of contents extends past the end of the table of contents, can't load from it)
</code>
As it turns out, this is a problem with the 64-bit version of MySQL 5.0 (thanks to <a href="http://devel.webwork.rochester.edu/twiki/bin/view/Webwork/TigerInstall">http://devel.webwork.rochester.edu/twiki/bin/view/Webwork/TigerInstall</a>).

After I reinstalled <a href="http://dev.mysql.com/downloads/mysql/5.0.html">32-bit MySQL</a>, the DBD::mysql package compiled and installed without a problem. In fact, I didn't even have to add that line to <tt>mysql_com.h</tt>. However, all was not well, because for some reason, whenever code tried to **use** this module, (either 'make test' or actual code), I got the cryptic error:

<code>install_driver(mysql) failed: Can't load '/Users/phil/.cpan/build/DBD-mysql-4.004-bd2Pvk/blib/arch/auto/DBD/mysql/mysql.bundle' for module DBD::mysql: dlopen(/Users/phil/.cpan/build/DBD-mysql-4.004-bd2Pvk/blib/arch/auto/DBD/mysql/mysql.bundle, 2): Library not loaded: /usr/local/mysql/lib/mysql/libmysqlclient.15.dylib
  Referenced from: /Users/phil/.cpan/build/DBD-mysql-4.004-bd2Pvk/blib/arch/auto/DBD/mysql/mysql.bundle
  Reason: image not found at /System/Library/Perl/5.8.6/darwin-thread-multi-2level/DynaLoader.pm line 230.
 at (eval 3) line 3
</code>
I tried a million things to solve this, thinking it was some leftover residue from my previous MySQL install. Unfortunately, even after a clean reinstall of MySQL, the same error was occurring. I looked more closely at the error, hoping to divine some deeper meaning, when it hit me. I knew the library existed, but I couldn't figure out why the perl library loader couldn't find it. Closer examination revealed that for some reason the library path had an extra component in it. The solution was a simple symlink:

<code>sudo ln -s /usr/local/mysql/lib /usr/local/mysql/lib/mysql
</code>

Yes, ridiculous, I know. But it fixed the problem, and everything is working fine now.
