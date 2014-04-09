---
layout: post
title: MySQLs mangled syntax handling and INNER JOINs
created: 1265138308
categories:
- rants
- coding
- mysql
- programming
- sqlite
---
As my DBA skills have progressed over the years, I'm always impressed and upset to see the extent to which MySQL has allowed me to use terrible syntax generally not accepted by standards-compliant SQL servers.

A recent one really blew me away, because it exposed a lack of understanding on my part about how to understand the syntax of JOIN commands.

This is how I always built nested JOIN queries. The premise is that semantically you are always selecting from a single table; the use of the INNER JOIN statement is treated like a function that returns a compound table.

<div style="text-align:left;color:#ffffff; background-color:#000000; border:solid black 1px; padding:0.5em 1em 0.5em 1em; overflow:auto;font-size:small; font-family:monospace; "><span style="color:#dfb098;">SELECT</span> r.name <span style="color:#dfb098;">AS</span> <span style="color:#dfb098;">role</span>, p.name <span style="color:#dfb098;">AS</span> permission<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#dfb098;">FROM</span> <span style="color:#dfb098;">role</span> r<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#dfb098;">INNER</span> <span style="color:#dfb098;">JOIN</span> (role_permission rp<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#dfb098;">INNER</span> <span style="color:#dfb098;">JOIN</span> permission p <span style="color:#dfb098;">ON</span> (rp.permission_id = p.<span style="color:#dfb098;">id</span>))<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#dfb098;">ON</span> (rp.role_id = r.<span style="color:#dfb098;">id</span>)<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#dfb098;">ORDER</span> <span style="color:#dfb098;">BY</span> r.name, p.name<br />
<br />
</div>

However, when trying to run this same snippet against an SQLite3 database, I would continue to get a <span class="error">no such column: p.name</span> error. After some research, I found the preferable way to do nested joins is much simpler, if less semantically pleasing:

<div style="text-align:left;color:#ffffff; background-color:#000000; border:solid black 1px; padding:0.5em 1em 0.5em 1em; overflow:auto;font-size:small; font-family:monospace; "><span style="color:#dfb098;">SELECT</span> r.name <span style="color:#dfb098;">AS</span> <span style="color:#dfb098;">role</span>, p.name <span style="color:#dfb098;">AS</span> permission<br />
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#dfb098;">FROM</span> <span style="color:#dfb098;">role</span> r<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#dfb098;">INNER</span> <span style="color:#dfb098;">JOIN</span> role_permission rp <span style="color:#dfb098;">ON</span> rp.role_id = r.<span style="color:#dfb098;">id</span><br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#dfb098;">INNER</span> <span style="color:#dfb098;">JOIN</span> permission p <span style="color:#dfb098;">ON</span> rp.permission_id = p.<span style="color:#dfb098;">id</span><br />
&nbsp;&nbsp;&nbsp;&nbsp;<span style="color:#dfb098;">ORDER</span> <span style="color:#dfb098;">BY</span> r.name, p.name<br />
</div>

This works for me properly in both SQLite and MySQL. I'm curious what it was that made me ever start writing nested JOINs in the former method; it was fairly error-prone due to missing parenthesis, etc.
