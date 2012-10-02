###
title: Support
layout: page
url: '/support'
###

h2 "Support Channels"

text @partial "content/subblock.html.coffee", {
	avatar: '/images/stackoverflow.gif'
	heading: """
		<a href="http://stackoverflow.com/questions/ask">Stack Overflow</a>
		"""
	subheading: "Stackoverflow owns &amp; manages, Bevry participates"
	content: """
		<t render="markdown">
		StackOverflow is a community of passionaite programmers dedicated to solving problems for each other for any type of programming questions. As you post questions and answers you’ll earn reputation which gives you more abilities on the site. *Be aware that this is a community for anything programming, not just Bevry related projects. So you must state the project that you’re using in your question.* Some of our projects already have tags that you can use too. For premium support, you must use the appropriate tag.

		Use the tags [#docpad](http://stackoverflow.com/questions/tagged/docpad) for DocPad, [#history.js](http://stackoverflow.com/questions/tagged/history.js) for History.js, and [#bevry](http://stackoverflow.com/questions/tagged/bevry) for everything else. *If you’re new to Stack Overflow, read their [FAQ](http://stackoverflow.com/faq) before posting.*
		</t>
		"""
}

text @partial "content/subblock.html.coffee", {
	avatar: '/images/book.gif'
	heading: """
		<a href="http://support.bevry.me">Helpdesk</a>
		"""
	subheading: "Bevry owns, manages &amp; participates"
	content: """
		<t render="markdown">
		Bevry operates email at [support@bevry.me](mailto:support@bevry.me) and helpdesk support at [http://support.bevry.me](http://support.bevry.me) for all our projects. We also have special addresses for the following projects:

		**DocPad**<br/>
		Email: [support@docpad.org](mailto:support@docpad.org)<br/>
		Helpdesk: [http://support.docpad.org](http://support.docpad.org)

		**History.js**<br/>
		Email: [support@historyjs.net](mailto:support@historyjs.net)<br/>
		Helpdesk: [http://support.historyjs.net](http://support.historyjs.net)
		</t>
		"""
}


h2 "Premium Support"
text """
	<t:premiumsupport render="markdown">
	Premium support provides you with support response times within one day when going through our supported support channels. Support is capped to two hours over the month, if the two hours are exceeded you will need to purchase additional hours for that month. The hours you are allocated are customisable. Unused hours will not be carried over into the next month. Months are considered to start at the purchase date of the premium support, and finish at the same date the next month. Support is charged per month, per person, and in Australian dollars. You can purchase premium support by either emailing #{@link.salesemail} or calling us during business hours on #{@link.salesphone}.

	*Business hours are 9am to 5pm Sydney Time (+10:00) Monday to Friday with limited support on Saturday and no guaranteed support on Sunday.*
	</t:premiumsupport>
	"""



h2 "Other Channels"

text @partial "content/subblock.html.coffee", {
	avatar: '/images/octocat.gif'
	heading: """
		<a href="https://github.com/bevry">GitHub</a>
		"""
	subheading: "GitHub owns, Bevry manages &amp; participates"
	content: """
		<t render="markdown">
		GitHub is the social programming community and the place to host your open-source projects. Bevry hosts all their projects on github, and uses the built-in Issues functionality for development tasks and the discussions surrounding them. For instance, if you send in an email and that spawns a new development task we may reference you to the github issue behind it so you can track and participate in its progress. You can also use it to submit bugfixes yourself, and provide feature requests. Do not use this channel for questions or support.
		</t>
		"""
}

text @partial "content/subblock.html.coffee", {
	avatar: '/images/irc.gif'
	heading: """
		<a href="irc://chat.freenode.net:6997/bevry">Internet Relay Chat (IRC)</a>
		"""
	subheading: "Bevry owns, manages &amp; participates"
	content: """
		<t render="markdown">
		Bevry opperates several IRC chatrooms the freenode chat server that you can find our team hanging out on during business hours. Use [#bevry](irc://chat.freenode.net:6997/bevry) for projects that do not have their own channel.</p>

		Channels we operate:
		[#bevry](irc://chat.freenode.net:6997/bevry),
		[#docpad](irc://chat.freenode.net:6997/docpad),
		[#history.js](irc://chat.freenode.net:6997/history.js)
		</t>
		"""
}

text @partial "content/subblock.html.coffee", {
	avatar: '/images/twitter.gif'
	heading: """
		<a href="https://twitter.com/bevryme">Twitter</a>
		"""
	subheading: "Bevry owns, manages &amp; participates"
	content: """
		<t render="markdown">
		Bevry operates several twitter accounts you can reach  and mention us on. Use [@BevryMe](https://twitter.com/bevryme) for projects that do not have their own account.

		Accounts we operate:
		[@BevryMe](https://twitter.com/bevryme),
		[@DocPad](https://twitter.com/docpad),
		[@HistoryJS](https://twitter.com/historyjs),
		[@QueryEngine](https://twitter.com/queryengine),
		[@StartupHostel](https://twitter.com/startuphostel)
		</t>
		"""
}