---
layout: post
title: Neat Color-Coded `svn status` Wrapper Script
created: 1266858037
categories:
- coding
- bash
- python
- svn
- unix
---
A few days ago, I found a handy script online that colorized the output of SVN status. It worked pretty well, but needed a little polish and a couple of tweaks to make it use more common Python idioms. Also, I fixed ANSI word-wrapping issues, created a configurable tab expansion feature (for better code alignment), added the 'colorizedSubcommands' sequence so that only applicable commands get colorized, and fixed subprocess calls so that piping through less will work (for example, try <tt>svn-color diff | less -r</tt> to see colorized diff output).

I hope you find my modifications useful. You can modify the colors used by looking up the ANSI color codes for your preferred color scheme and editing the 'statusColors' dictionary. Here's a useful reference for ANSI color values:

<a href="http://www.ibm.com/developerworks/linux/library/l-tip-prompt/colortable.gif">http://www.ibm.com/developerworks/linux/library/l-tip-prompt/colortable.gif</a>

i've posted the code on <a href="http://snipplr.com">snipplr</a>, and it's also posted below after the break.

<!--break-->

<div id="snipplr_embed_28748" class="snipplr_embed"><a href="http://snipplr.com/view/28748/colorcoded-svn-status-v3/">code snippet - color-coded `svn status` (v3)</a> on snipplr</div><script type="text/javascript" src="http://snipplr.com/js/embed.js"></script><script type="text/javascript" src="http://snipplr.com/json/28748"></script>
