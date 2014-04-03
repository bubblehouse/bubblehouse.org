---
layout: post
title: Nice New Things
created: 1064435344
categories:
- !ruby/string:Sequel::SQL::Blob |-
  aW5uZXJzcGFjZQ==
- !ruby/string:Sequel::SQL::Blob |-
  Y29kaW5n
---
<p>So right away I have something to show anyone who wants to look. I&#8217;ve been thinking about the whole RExec/Bastion problem, and I may have come up with a solution. I&#8217;d also certainly appreciate it if anyone could fill me in with any obvious security flaws</p>

<p>Check out <A HREF="http://bubblehouse.org/cgi-bin/viewcvs.cgi/*checkout*/SaferPython/safer.py?content-type=text/plain">SaferPython</A>. It is my attempt to rewrite a restricted environment for Python. Admittedly, I don&#8217;t think I know enough about the new language features to be sure if this works. I&#8217;ve tried a number of &#8220;exploits&#8221;, and this seems to provide the kind of protection <strong>I</strong> want, but I&#8217;m pretty sure it doesn&#8217;t have the abilities that some RExec users need.</p>

<p>I wrote this based upon the following premises:</p>

<ul>
    <li>That my primary goal is to offer some sort of scripting enviroment, even if it is only a subset of the Python language. Call it PythonScript or something (ah, jk, I think that already exists)&#8230;</li>
    <li>That any class/object that I could want in the restricted environment would be accessible to me ahead of time.</li>
    <li>That none of the objects in this environment can return anything but safe objects</li>
</ul>

<p>For the moment, I can be sure the the classes are secure, since importing is disabled from inside the environment. Only classes/objects that are imported explicitly are available.</p>

<p>The way you&#8217;d use it would be something like this:</p>

<pre>
from safer import *
import string

# defaults to using the NameChecker class for permissions
env = Armory()
# we insert objects that we want to access, including any modules
# or built-in functions
env.insert('string', string) #the string module
env.insert('str', str)       #the str() built-in/type

# we can also specify other IPermission implementations
class myClass(object):
    pass
env.insert('MyClass', MyClass, ClassProtection)

env.r_exec(someUntrustedCode)
</pre>

<p>The manual insertion of <em>ALL</em> language objects is a bit of a pain, but this can be automated once I figure out what classes/objects are 100% safe for this environment. Although there is support for creating new instances of protected (Shielded) class objects, they are currently returned unrestricted. I&#8217;m planning on fixing this once I figure out a nice way to do it.</p>
