---
layout: post
title: some updates...
created: 1072108887
categories:
- innerspace
- coding
---
<p>So, as it&#8217;s been awhile since I&#8217;ve updated, I have lots of new developments. I&#8217;ve been fortunate to find some time to tinker with IS, and there&#8217;s lots of cool stuff coming along. </p>

<p>I&#8217;ve also removed the CVS directory from sourceforge, as I wasn&#8217;t using it, since I prefer to use my own repository for now. Once I get to a releasable 1.0 candidate, I may mirror my repository to sf, but for now you can access the bubblehouse web-repository using the links to the left. I will eventually open up pserver access through my firewall, but until i get some more interest in this I&#8217;m not going to bother.</p>

<p>Oh, and I&#8217;ve also started adding some unit-testing, using python&#8217;s unittest modules. I&#8217;m quickly becoming a believer in unit-testing, since I found a slew of bugs in the parser and registry (the only two tests i&#8217;ve made yet). I will need to make a unit-test for the entity.py behemoth, but i&#8217;m probably going to hold off until I implement ACLs for permissions instead of the &#8220;rwx&#8221; business, which will probably happen in the near future.</p>

<p>You can read the rest of this entry for more details, but the improvements/changes include:</p>

<UL>
<LI>Licensing - now under the GPL</LI>
<LI>Parser - all new parser engine</LI>
<LI>Verbs - enhanced developer functionality</LI>
<LI>Plugins - support for new &#8220;core&#8221; packages</LI>
<LI>Observations - dynamic observations engine for different clients</LI>
<LI>Security - ideas on a secure environment for verb authors</LI>
<LI>Build System - building and installation of client and server packages</LI>
</UL>

<h3>Licenses</h3>
<p>After much hemming and hawing, I&#8217;ve decided to license InnerSpace under the <A HREF="http://www.gnu.org/licenses/gpl.html">GNU Public License</A>. There&#8217;s been a lot of talk around the GPL lately, what with <A href="http://www.sco.com">SCO Group</A>&#8217;s <A HREF="http://slashdot.org/search.pl?topic=88">relentless lawsuits and subpoenas</A>, and a number of groklaw pundits have convinced me, at least, that the GPL is a viable extension of copyright law. I&#8217;m not one of those people that&#8217;s super concerned about this kind of stuff usually, but I&#8217;ve been working on this project for a long time.</p>

<h3>Parser</h3>
<p>I&#8217;ve revamped the parser, and it&#8217;s a hundred times better. Previously, all sentences/commands had to be of the (BNF) form:</p>

<p><tt>verb[[ object-specifier] direct-object[ preposition[ object-specifier] object-of-the-preposition]]</tt></p>

<p>This sucked for a couple of reasons. In addition to the actual style of the sentences being rather limited, you were also limited to one preposition-object pair. The new parser form is:</p>

<p><tt>verb[[[ object-specifier] direct-object]+[ preposition[ object-specifier] object-of-the-preposition]*]</tt></p>

<p>I might be mixing up my BNF with RegEx, but basically what this comes down to is that you can now write verbs that support multiple preposition-object pairs (&#8220;take the coal from the fire with the tongs&#8221;), as well as skipping the direct object entirely (&#8220;look at phil&#8221;).</p>

<h3>Verbs</h3>
<p>The changes in the parser required some changes at the verb level, but they are few, and add some nice time-saving elements to verb authors.</p>

<p>First of all, the &#8220;vargs&#8221; verb attribute will be going away soon, though it was never really used anyways. The code editor on the client will also no longer present those fields as options (additionally, I&#8217;ve borrowed the jEdit text pane, which was placed into the public domain, to use inside the verb editor. It&#8217;s a big improvement).</p>

<p>The replacement for the functionality that &#8220;vargs&#8221; was supposed to provide will be provided by new functions in the verb environment, called get<em>dobj, get</em>pobj, has<em>dobj, has</em>pobj, and their string equivalents, get<em>dobj</em>str, etc&#8230;</p>

<p>For the &#8220;get<em>&#8221; functions, if that object was not found, or that string was not used in the sentence, a NoSuchObjectError will be thrown. Also, as get</em>pobj requires a preposition argument, possibly a NoSuchPrepositionError will be thrown, if the preposition given was not used in the sentence.</p>

<p>However, this still leaves open the problem of what to do if someone tries to use a player to do something, i.e., there&#8217;s a verb &#8220;kill&#8221; on a player called &#8220;wizard&#8221;, at this point, another player could say &#8220;kill phil with wizard&#8221;. This might be alleviated with the rwx bits on a verb, or rather, by adding another bit. More likely is that the &#8220;rwx&#8221; Unix-type permissions system will be repalced by ACLs.</p>

<p>I also want to implement a system for delaying events, using the twisted deferred system. Since deferreds already run as part of the reactor event loop, i think it could be added in relatively easily&#8230;</p>

<h3>Plugins</h3>
<p>It is now possible to subclass inner.space.entity.Verb, which I&#8217;m using to write the most basic verbs, such as Look, Emote, Say, etc&#8230;as well as some programmer-oriented ones. The cool thing about this is that all of these verbs are installed by dropping a twisted-plugin-based package into your PYTHONPATH. This would make it easier for third parties to distribute new core packages (kinda like LambdaMOO has LambdaCore and JHCore, and others). When subclassing a verb, authors override execute() and use the object passed in to access variables from the parser.</p>

<h3>Observations</h3>
<p>The current system for controlling what the &#8220;client&#8221; sees is hard-coded to send a number of attributes from the object. I&#8217;m going to change this so that if the object defines a verb called &#8220;get_observations&#8221;, that is called, and the result (presumably a hashtable) is sent to the client. If there is no verb defined, then the system object (#0) is checked for a verb with the same name that is passed an entity and the client object requesting it as arguments. I&#8217;m not sure if there will be a default after this, or if it will be required that the system object supports that verb.</p>

<h3>Security</h3>
<p>In my last post, I discussed ideas for a restricted execution enviroment. Since then I had a couple of talks with glyph about the idea, and he brought up some good points, that made me realize it&#8217;s truly difficult to allow totally untrusted code to run safely.</p>

<p>I realized long ago that one of the biggest issues to deal with is infinite recursion/looping, either with memory constraints, or infinite process spawning. A solution to this is to use the memory/process constraints placed on individual processes by the POSIX environment, i.e., forking processes for each verb. A prior version of InnerSpace attempted this, but had no simple way to provide interaction with the parent process.</p>

<p>One of my ideas is that, in combination with my <A href="http://bubblehouse.org/cgi-bin/viewcvs.cgi/*checkout*/SaferPython/safer.py?content-type=text/plain">
SaferPython</A> module, I could create a transaction-based verb environment. Hopefully to the coder, it would be relatively unintrusive, but basically we trust that if the parent process receives a transaction list from the child, then we know that there was no ouroboros action going on.</p>

<p>One thing that is really fruitless is keeping people who are really determined to hack the server from doing so. I mean the kind of people who are willing to overflow buffers in Python&#8217;s unicode handling, etc. I think it&#8217;s just as likely that an exploit could be found in any other aspect of the codebase.</p>

<p>I think that the combination of forking, transactions, and restricted environments could provide a safe environment for generally untrusted, but registered users of the system.</p>

<h3>Build System</h3>
<p>Finally, I&#8217;ve begun using distutils to provide a means for installing the server packages, and creating a JAR for the java client. Also, I have rudimentary support built-in for building a MacOS X double-clickable application. Right now, during build it asks you for a classpath to your TwistedJava.jar file, since hardcoding class paths into the Info.plist file seems to be the only way to access code outside the package.</p>

<p>Also, at the moment I am distributing a copy of the JavaApplicationStub binary which needs to be copied into the bundle for it to work. This is almost certainly illegal. I&#8217;m hoping that until I figure out a solution, Apple doesn&#8217;t sue me over 51 bytes of binary.</p>

<h3>In conclusion&#8230;</h3>
<p>Anyways, that&#8217;s pretty much everything for now. I&#8217;m trying really hard to keep everything updated, but this is the part of the process I hate the most, i.e., the documentation. I have to work on that.</p>
