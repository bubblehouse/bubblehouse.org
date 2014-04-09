---
layout: post
title: beginning of day timestamps
created: 1154477877
categories:
- coding
- !ruby/string:Sequel::SQL::Blob |-
  cGhw
- !ruby/string:Sequel::SQL::Blob |-
  cmVmbGV4aW9ucw==
---
<p><a href="http://www.driveling.net/">mark</a> got me thinking about this, and then i was messing around with one of my own projects that needed the same feature, and i realized the easy way to do it.</p>

<p>i would always get the year/month/day out of a timestamp using the date() function, and then create a new timestamp with mktime().</p>

<p>i just realized the best way is:</p>

<code>
    $now = time();
    $beginning<em>of</em>day = $now - ($now % 86400);
</code>

<p>this works for me because i definitely remember that number for seconds in a day, and avoids any locale-dependent variations. plus, end of day becomes just as easy.</p>
