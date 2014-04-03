---
layout: post
title: Ch-ch-ch-ch-changes...
created: 1064349746
categories:
- !ruby/string:Sequel::SQL::Blob |-
  aW5uZXJzcGFjZQ==
- !ruby/string:Sequel::SQL::Blob |-
  Y29kaW5n
---
<p>First of all, welcome to the latest-greatest version of the InnerSpace website. Since I slacked off so much on updating recently, I decided to start using Moveable Type to make a weblog for this site. Considering it greatly simplifies the process for me, I hope to be able to post more frequently.</p>

<p>I have a bit more time to talk about some of the changes going on in the InnerSpace codebase. One of the biggest things has to do with some problems with Python 2.0.</p>

<p>During the creation of Python 2.0, it was discovered that new class features break the RExec and Bastion modules. They no longer provide true security from untrusted code. This is obviously a big deal, since this is something projects like InnerSpace (including the Grail web browser, and, to some extent, the Zope project) rely on heavily. Some additional explanation of the situation can be found <A HREF="http://mail.python.org/pipermail/python-dev/2002-December/031160.html">here</A> and <A HREF="http://mail.python.org/pipermail/python-dev/2003-January/031848.html">here</A>.</p>

<p>However, PythonLabs has pretty much said they have neither the resources to fix what&#8217;s wrong with RExec/Bastion, nor the ability to provide a new solution. So, this kinda sucks.</p>

<p>For the moment, I have removed the restricted execution code (Python 2.3 won&#8217;t even let you load the module), and verb code now gets executed &#8220;straight up.&#8221; This means you probably won&#8217;t want to count on allowing free programmer rights until this gets fixed.</p>

<p>Additionally, I&#8217;ve decided to drop the verb forking support until either I think of a better way to do it, or completely restructure InnerSpace again (man, I really don&#8217;t want THAT to happen)</p>

<p>A little lesson on forking processes for anyone interested. Python has a builtin system function called fork(). fork() returns a integer that indicates the process ID of the child. Where things get weird is that the code after your fork call gets executed both in the child and in the parent. The integer you get from fork in the child is actually 0, so you want to do something like this:</p>

<pre>
import os

pid = os.fork()
if(pid):
    # the parent executes the stuff here
else:
    # and the child executes the stuff here
</pre>

<p>The catch-22 with all this neat forking stuff is that although you have no problems reading variables in the child, modifying them doesn&#8217;t really do any good. My solution to this was to have each child open a socket to the parent and use a custom protocol to modify the data in the parent when it changed in the child.</p>

<p>Basically, I was using a remote object mechanism (first PyRO, and then my own home-brewed solution) to give code running in a sub-process access to game runtime objects (remember, the goal was to allow nearly transparent access to these objects). This ended up being rather inelegant, since although all of the objects in the child would work as remote references to objects in the parent, what do you do when someone calls <tt>obj.list.append(somedata)</tt>?</p>

<p>Anyhow, those are the two major (bad) changes to InnerSpace since I last updated this page. In my next post I&#8217;ll talk about some of the really cool changes that I&#8217;ve touched on before.</p>
