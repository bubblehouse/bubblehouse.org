---
layout: post
title: the only sure things in life are death and spammers
created: 1107574350
categories:
- !ruby/string:Sequel::SQL::Blob |-
  cmFudHM=
---
<p>just when i was sure i was out, they pulled me back in!!!</p>

<p>lately my exposure to spam has been relatively low. since i got spamassassin working to it&#8217;s fullest by utilizing the <a href="http://razor.sourceforge.net/">razor db</a>, the amount of false negatives i&#8217;ve gotten is damn close to zero. i can&#8217;t remember the last time a spam e-mail got through to my inbox.</p>

<p>also, awhile ago i realized that <a href="http://bubblehouse.org/archives/000057.shtml">spammers were the only ones submitting comments on my blog</a>, which led me to start using <a href="http://james.seng.sg">James Seng&#8217;s</a> SCode.pm for generating CAPTCHAs, which stopped the problem for the most part. I was still getting spammed manually, though.</p>

<p>however, today i became aware of two other ways those smarmy bastards were getting through. first, i realized that my referrer logs were full to the brim with URLs like http://texas-hold-em.online-deals-4u.info/&#8230;. a <a href="http://it.slashdot.org/article.pl?sid=05/02/01/1519211&amp;tid=111&amp;tid=95&amp;tid=4">slashdot article</a> proved informative in fixing this issue.</p>

<p>and finally, i realized that the once pristine TrackBack mechanism was also getting spammed, leading me to turn off that feature throughout my site. apparently, though, Mr. Seng also has <a href="http://james.seng.sg/archives/2005/02/04/solution_to_trackback_spams.html">a solution to this</a>, which i hope to implement soon&#8230;</p>

<p>as a sidenote, while preparing this entry, i came upon some information about <a href="http://www.drupal.org/">Drupal</a>, an open-source content management platform. it looks kinda nice, and i&#8217;ve been thinking about freeing myself from Six Apart&#8217;s moveabletype software&#8230;it will be interesting to see what&#8217;s involved in making the switch&#8230;</p>

<p>EDIT: for the moment, i&#8217;ve started using tom sherman&#8217;s <a href="http://underscorebleach.net/content/jotsheet/2005/02/prevent_movable_type_trackback_spam">solution to trackback spam</a>, and it seems to be doing the job&#8230;.i&#8217;m still looking at drupal, though&#8230;</p>
