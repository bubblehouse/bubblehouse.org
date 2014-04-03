---
layout: post
title: the only sure things in life are death and spammers
created: 1107574350
categories:
- !ruby/string:Sequel::SQL::Blob |-
  cmFudHM=
---
just when i was sure i was out, they pulled me back in!!!

lately my exposure to spam has been relatively low. since i got spamassassin working to it's fullest by utilizing the <a href="http://razor.sourceforge.net/">razor db</a>, the amount of false negatives i've gotten is damn close to zero. i can't remember the last time a spam e-mail got through to my inbox.

also, awhile ago i realized that <a href="http://bubblehouse.org/archives/000057.shtml">spammers were the only ones submitting comments on my blog</a>, which led me to start using <a href="http://james.seng.sg">James Seng's</a> SCode.pm for generating CAPTCHAs, which stopped the problem for the most part. I was still getting spammed manually, though.

however, today i became aware of two other ways those smarmy bastards were getting through. first, i realized that my referrer logs were full to the brim with URLs like http://texas-hold-em.online-deals-4u.info/.... a <a href="http://it.slashdot.org/article.pl?sid=05/02/01/1519211&tid=111&tid=95&tid=4">slashdot article</a> proved informative in fixing this issue.

and finally, i realized that the once pristine TrackBack mechanism was also getting spammed, leading me to turn off that feature throughout my site. apparently, though, Mr. Seng also has <a href="http://james.seng.sg/archives/2005/02/04/solution_to_trackback_spams.html">a solution to this</a>, which i hope to implement soon...

as a sidenote, while preparing this entry, i came upon some information about <a href="http://www.drupal.org/">Drupal</a>, an open-source content management platform. it looks kinda nice, and i've been thinking about freeing myself from Six Apart's moveabletype software...it will be interesting to see what's involved in making the switch...

EDIT: for the moment, i've started using tom sherman's <a href="http://underscorebleach.net/content/jotsheet/2005/02/prevent_movable_type_trackback_spam">solution to trackback spam</a>, and it seems to be doing the job....i'm still looking at drupal, though...
