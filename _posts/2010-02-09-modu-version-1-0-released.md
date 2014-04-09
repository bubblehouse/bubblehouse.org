---
layout: post
title: modu version 1.0 released!!!
created: 1265752932
categories:
- coding
- !ruby/string:Sequel::SQL::Blob |-
  cHJvZ3JhbW1pbmc=
- !ruby/string:Sequel::SQL::Blob |-
  dHdpc3RlZA==
- !ruby/string:Sequel::SQL::Blob |-
  bW9kdQ==
- !ruby/string:Sequel::SQL::Blob |-
  c29mdHdhcmU=
- !ruby/string:Sequel::SQL::Blob |-
  cmVsZWFzZQ==
---
<p>After two years of continual development, documentation, and production use, I've arbitrarily decided to tag modu with a version 1.0, as well as make a formal release.</p>
<p>modu is released under the <a href="http://modu.bubblehouse.org/trac/browser/trunk/LICENSE">MIT</a> license. For installation instructions, see <a href="http://modu.bubblehouse.org/trac/wiki/Installation">Installation</a> or the included <a href="http://modu.bubblehouse.org/trac/browser/tags/modu-1.0.2/INSTALL">INSTALL</a> file.</p>
<div>
<h4>Tar package</h4>
<ul>
    <li><strong>HTTP</strong>: <a href="http://modu.bubblehouse.org/releases/modu-1.0.2.tar.gz#egg=modu-1.0.2">modu-1.0.2.tar.gz</a></li>
</ul>
<p><sub><tt>md5sum: 33242ce8c2a3c6292aca46ee563e431b </tt></sub></p>
</div>
<!--break-->
<p>A great deal of changes have occurred over the last few weeks as I've removed tons of cruft and dependencies from the main codebase, and in particular completed the transition to setuptools-based installation, and the setuptools Resource API to handle assets more effectively. Additionally, the Cheetah integration now caches templates in memory, which should allow for use of template #cache directives, although I haven't really tried this yet.</p>
<h4>Dependencies:</h4>
<ul>
    <li>Python 2.5</li>
    <li>Twisted 9</li>
    <li>Cheetah 2.4.1</li>
    <li>MySQLdb 1.2.3c1</li>
</ul>
<p><small>There is currently experimental support included for CherryTemplates and ZPTPages template engines, as well as the PostgreSQL and SQLite databases.</small></p>
<p>Latest Stable Release 1.0.2</p>
<p>1.0.2 is a new stable maintenance release, released on February 07, 2010 at 11.18PM. It contains a number of bug fixes and minor enhancements. See the <a class="source" href="/trac/browser/tags/modu-1.0.0/ChangeLog">ChangeLog</a>  for details.</p>
<div>
<h4>Tar package</h4>
<ul>
    <li><strong>HTTP</strong>: 			<a href="http://modu.bubblehouse.org/releases/modu-1.0.2.tar.gz#egg=modu-1.0.2">modu-1.0.2.tar.gz</a></li>
</ul>
<p><sub><tt>md5sum: 33242ce8c2a3c6292aca46ee563e431b </tt></sub></p>
<h4>Binary Distribution</h4>
<ul>
    <li>Automatically install and compile modu and related dependencies:
    <pre>
# easy_install modu</pre>
    </li>
</ul>
</div>
<h4>SVN Tag</h4>
<p>To check out a snapshot of the source code from SVN HEAD, use the following incantation:</p>
<pre>
svn co http://svn.bubblehouse.org/modu/tags/modu-1.0.2</pre>
