---
layout: post
title: Fun with Xargs on Mac OS X
created: 1179330972
categories:
- coding
- !ruby/string:Sequel::SQL::Blob |-
  dW5peA==
- !ruby/string:Sequel::SQL::Blob |-
  YmFzaA==
---
<p><em>This is something I wrote over at <a href="http://docforge.com">DocForge</a>, but I&#8217;m keeping it here for posterity. You never know what those crazy wiki-ers might do with it over there <tt>;-)</tt></em></p>

<p>I&#8217;ve got a directory full of eBooks in the godawful Microsoft .lit format. I had marked with the Finder labels the ones I&#8217;ve already read, and wanted to convert all the ones I hadn&#8217;t read yet into a readable format.</p>

<p>After using the Spotlight UNIX tools and applying liberal amounts of command-line trickery, the end result was a rather beautiful pipeline, if I do say so myself.
<!--break-->
First, I used the <tt>mdfind</tt> command to filter all the Items that had the red label. We&#8217;re going to query the <tt>kMDItemFSLabel</tt> properties; the red label has a value of <tt>6</tt> (I found this out by using <tt>mdls</tt> on a file with the desired label).</p>

<p>Since I only want to search a particular directory, I use the <tt>-onlyin</tt> switch to limit the query:</p>

<pre class="bash">mdfind -onlyin /Users/phil/Desktop/books/ <span style="color: #ff0000;">&quot;kMDItemFSLabel&nbsp;!= 6&quot;</span></pre>

<pre>/Users/phil/Desktop/books/one.lit
/Users/phil/Desktop/books/two.lit
/Users/phil/Desktop/books/other.rtf
/Users/phil/Desktop/books/three.lit
/Users/phil/Desktop/books/something.html
...
...</pre>

<p>Some of those aren&#8217;t .lit files, so I&#8217;ll just use <tt>grep</tt>:</p>

<pre class="bash">mdfind -onlyin /Users/phil/Desktop/books/ <span style="color: #ff0000;">&quot;kMDItemFSLabel&nbsp;!= 6&quot;</span> | grep <span style="color: #ff0000;">&quot;.lit&quot;</span></pre>

<pre>/Users/phil/Desktop/books/one.lit
/Users/phil/Desktop/books/two.lit
/Users/phil/Desktop/books/three.lit
...
...</pre>

<p>I could have limited the Spotlight query further, but what fun would that be?</p>

<p>Now, ultimately I&#8217;m going to use this output with <tt>xargs</tt>, but because of limitations imposed by the .lit conversion app, I need to get the basename of these files. For this <tt>sed</tt> will do the trick:</p>

<pre class="bash">mdfind -onlyin /Users/phil/Desktop/books/ <span style="color: #ff0000;">&quot;kMDItemFSLabel&nbsp;!= 6&quot;</span> | grep <span style="color: #ff0000;">&quot;.lit&quot;</span> | \
    sed <span style="color: #ff0000;">'s/<span style="color: #000099; font-weight: bold;">\/</span>Users<span style="color: #000099; font-weight: bold;">\/</span>phil<span style="color: #000099; font-weight: bold;">\/</span>Desktop<span style="color: #000099; font-weight: bold;">\/</span>books<span style="color: #000099; font-weight: bold;">\/</span>//'</span></pre>

<pre>one.lit
two.lit
three.lit
...
...</pre>

<p>Finally, I pass this onto <tt>xargs</tt>, then the unfortunately named <a href="http://www.convertlit.com" class="external text" title="http://www.convertlit.com">ConvertLIT</a> tool:</p>

<pre class="bash">mdfind -onlyin /Users/phil/Desktop/books/ <span style="color: #ff0000;">&quot;kMDItemFSLabel&nbsp;!= 6&quot;</span> | grep <span style="color: #ff0000;">&quot;.lit&quot;</span> | \
    sed <span style="color: #ff0000;">'s/<span style="color: #000099; font-weight: bold;">\/</span>Users<span style="color: #000099; font-weight: bold;">\/</span>phil<span style="color: #000099; font-weight: bold;">\/</span>Desktop<span style="color: #000099; font-weight: bold;">\/</span>books<span style="color: #000099; font-weight: bold;">\/</span>//'</span>  | xargs -I \<span style="color: #66cc66;">&#123;</span>\<span style="color: #66cc66;">&#125;</span> clit \<span style="color: #66cc66;">&#123;</span>\<span style="color: #66cc66;">&#125;</span> oebps/\<span style="color: #66cc66;">&#123;</span>\<span style="color: #66cc66;">&#125;</span>/</pre>

<pre>$ clit one.lit oebps/one.lit/
$ clit two.lit oebps/two.lit/
$ clit three.lit oebps/three.lit/
$ ...
$ ...</pre>

<p>I&#8217;m replicating the syntax of <tt>find</tt>&#8217;s <tt>-exec</tt> switch with <tt>xargs</tt>&#8217; <tt>-I</tt> switch. This will replace all occurrences of the <tt>{}</tt> with the filename from standard input.</p>
