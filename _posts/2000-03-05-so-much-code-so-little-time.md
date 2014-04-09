---
layout: post
title: So Much Code, So Little Time
created: 952283434
categories:
- innerspace
- coding
---
Really, there's many things that I think make InnerSpace pretty cool. If you're still with me at this point, you rock. Here's some miscellaneous neat stuff:

* All game objects (users, rooms, doors, etc.) are represented by one class. Any object can potentially be a container for other objects, though by default they are not. Objectshave a parent, which gets consulted if a selected property or verb isn't found on the child. 
* Every command entered by the user forks a new process to run the code in. That way a malicious (or stupid) user can't lock up the rest of the system, only it's verb call. 
* The Pyro (PYthon Remote Objects) package is used to allow child processes access to the world's objects. It's been rather elegantly hacked (I think) to allow a sort of verification by remote code, so the (yet unwritten) object editor can be a little easier to write, while still being fairly secure. 
* The InnerSpace client is still written in Java, which allows for easy distribution by applet or other platform-independent method. 
