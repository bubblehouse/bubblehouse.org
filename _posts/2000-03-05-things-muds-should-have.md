---
layout: post
title: Things MUDs Should Have
created: 952283434
categories:
- !ruby/string:Sequel::SQL::Blob |-
  aW5uZXJzcGFjZQ==
- !ruby/string:Sequel::SQL::Blob |-
  Y29kaW5n
---
<ul>
	<li>
		<b>Authoring Support/Permissions Model</b> - I wanted to be able to safely give any user programmer's rights, without having to worry about the havoc they could bring on the system.
	</li>
	<li>
		<b>An Elegant Internal Programming Language</b> - Initially, I was going to just embed a Python interpreter into my Java code, but I realized that Python's cool factor was just too great. So now the whole server is written in Python.
	</li>
	<li>
		<b>Better Object Referencing</b> - Most MUDs suffer from issues with naming objects. There's basically two established methods; you either assign each object an arbitrary unique ID (LambdaMOO's method), or ensure that no two objects share the same name. These methods had various shortcomings. If each object had a unique ID number, you could allow the name property on various objects to be the same. However, the drawback was that if your player character was not physically in the same room as the object you wanted to refer to, you were forced to refer to it by it's ID, like #175847. Conversely, if each object has a unique internal name, you'd be able to refer to something like candle(4). However, for things to look less intrusive, you had to set a special property that would change the name users saw when they looked at an object. You then assigned an aliases property that would provide a number of other ways to refer to the object.<br>
		My solution is nicer, I think. The inner.space.registry keeps track of all objects by name and ID. So for the most part, you just refer to objects by their name. But if there's more than one item with that name, an AmbiguousError is raised by the parser, which asks "When you say, 'candle', do you mean candle (#456), candle (#726), or candle (#5)?"
	</li>
	<li>
		<b>A Graphical Object Editor</b> - So I may have come to appreciate UNIX, but I still love my Macintosh. By the same token, I want to be able to see at a glance all the major attributes of an object and be able to edit them easily.
	</li>
</ul>
