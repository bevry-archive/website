###
title: Support
layout: page
###

h2 "Support Channels"

text @partial "content/subblock.html.coffee", {
	avatar: '/images/stackoverflow.gif'
	heading: "Stack Overflow"
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
	heading: "Helpdesk"
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