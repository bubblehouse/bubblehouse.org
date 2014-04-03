---
layout: post
title: Fun with Xargs on Mac OS X
created: 1179330972
categories:
- !ruby/string:Sequel::SQL::Blob |-
  Y29kaW5n
- !ruby/string:Sequel::SQL::Blob |-
  dW5peA==
- !ruby/string:Sequel::SQL::Blob |-
  YmFzaA==
---
<em>This is something I wrote over at <a href="http://docforge.com">DocForge</a>, but I'm keeping it here for posterity. You never know what those crazy wiki-ers might do with it over there <tt>;-)</tt></em>

I've got a directory full of eBooks in the godawful Microsoft .lit format. I had marked with the Finder labels the ones I've already read, and wanted to convert all the ones I hadn't read yet into a readable format.

After using the Spotlight UNIX tools and applying liberal amounts of command-line trickery, the end result was a rather beautiful pipeline, if I do say so myself.
<!--break-->
First, I used the <tt>mdfind</tt> command to filter all the Items that had the red label. We're going to query the <tt>kMDItemFSLabel</tt> properties; the red label has a value of <tt>6</tt> (I found this out by using <tt>mdls</tt> on a file with the desired label).

Since I only want to search a particular directory, I use the <tt>-onlyin</tt> switch to limit the query:
<pre class="bash">mdfind -onlyin /Users/phil/Desktop/books/ <span style="color: #ff0000;">&quot;kMDItemFSLabel&nbsp;!= 6&quot;</span></pre>
<pre>/Users/phil/Desktop/books/one.lit
/Users/phil/Desktop/books/two.lit
/Users/phil/Desktop/books/other.rtf
/Users/phil/Desktop/books/three.lit
/Users/phil/Desktop/books/something.html
...
...</pre>

Some of those aren't .lit files, so I'll just use <tt>grep</tt>:
<pre class="bash">mdfind -onlyin /Users/phil/Desktop/books/ <span style="color: #ff0000;">&quot;kMDItemFSLabel&nbsp;!= 6&quot;</span> | grep <span style="color: #ff0000;">&quot;.lit&quot;</span></pre>
<pre>/Users/phil/Desktop/books/one.lit
/Users/phil/Desktop/books/two.lit
/Users/phil/Desktop/books/three.lit
...
...</pre>

I could have limited the Spotlight query further, but what fun would that be?

Now, ultimately I'm going to use this output with <tt>xargs</tt>, but because of limitations imposed by the .lit conversion app, I need to get the basename of these files. For this <tt>sed</tt> will do the trick:
<pre class="bash">mdfind -onlyin /Users/phil/Desktop/books/ <span style="color: #ff0000;">&quot;kMDItemFSLabel&nbsp;!= 6&quot;</span> | grep <span style="color: #ff0000;">&quot;.lit&quot;</span> | \
    sed <span style="color: #ff0000;">'s/<span style="color: #000099; font-weight: bold;">\/</span>Users<span style="color: #000099; font-weight: bold;">\/</span>phil<span style="color: #000099; font-weight: bold;">\/</span>Desktop<span style="color: #000099; font-weight: bold;">\/</span>books<span style="color: #000099; font-weight: bold;">\/</span>//'</span></pre>
<pre>one.lit
two.lit
three.lit
...
...</pre>

Finally, I pass this onto <tt>xargs</tt>, then the unfortunately named <a href="http://www.convertlit.com" class="external text" title="http://www.convertlit.com">ConvertLIT</a> tool:
<pre class="bash">mdfind -onlyin /Users/phil/Desktop/books/ <span style="color: #ff0000;">&quot;kMDItemFSLabel&nbsp;!= 6&quot;</span> | grep <span style="color: #ff0000;">&quot;.lit&quot;</span> | \
    sed <span style="color: #ff0000;">'s/<span style="color: #000099; font-weight: bold;">\/</span>Users<span style="color: #000099; font-weight: bold;">\/</span>phil<span style="color: #000099; font-weight: bold;">\/</span>Desktop<span style="color: #000099; font-weight: bold;">\/</span>books<span style="color: #000099; font-weight: bold;">\/</span>//'</span>  | xargs -I \<span style="color: #66cc66;">&#123;</span>\<span style="color: #66cc66;">&#125;</span> clit \<span style="color: #66cc66;">&#123;</span>\<span style="color: #66cc66;">&#125;</span> oebps/\<span style="color: #66cc66;">&#123;</span>\<span style="color: #66cc66;">&#125;</span>/</pre>
<pre>$ clit one.lit oebps/one.lit/
$ clit two.lit oebps/two.lit/
$ clit three.lit oebps/three.lit/
$ ...
$ ...</pre>

I'm replicating the syntax of <tt>find</tt>'s <tt>-exec</tt> switch with <tt>xargs</tt>' <tt>-I</tt> switch. This will replace all occurrences of the <tt>{}</tt> with the filename from standard input.
