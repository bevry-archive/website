# Prepare
pathUtil = require('path')
_ = require('underscore')
moment = require('moment')
strUtil = require('underscore.string')
textData = require(__dirname+'/app/text.coffee')


# =================================
# Helpers

# Titles
getName = (a,b) ->
	if b is null
		return textData[b] ? humanize(b)
	else
		return textData[a][b] ? humanize(b)
getProjectName = (project) ->
	getName('projectNames',project)
getCategoryName = (category) ->
	getName('categoryNames',category)
getLinkName = (link) ->
	getName('linkNames',link)
getLabelName = (label) ->
	getName('labelNames',label)

humanize = (text) ->
	text ?= ''
	return strUtil.humanize text.replace(/^[\-0-9]+/,'').replace(/\..+/,'')


# =================================
# Configuration


# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
docpadConfig = {

	# =================================
	# Template Data
	# These are variables that will be accessible via our templates
	# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData:

		# -----------------------------
		# Misc

		underscore: _
		strUtil: strUtil
		moment: moment
		text: textData

		# -----------------------------
		# Site Properties

		site:
			# The production url of our website
			url: "http://bevry.me"

			# The default title of our website
			title: "Bevry"

			# The website description (for SEO)
			description: """
				When your website appears in search results in say Google, the text here will be shown underneath your website's title.
				"""

			# The website keywords (for SEO) separated by commas
			keywords: """
				place, your, website, keywoards, here, keep, them, related, to, the, content, of, your, website
				"""

			# Styles
			styles: [
				'/styles/style.css'
			]

			# Scripts
			scripts: [
				# Vendor
				"/vendor/jquery.js"
				"/vendor/log.js"
				"/vendor/jquery.scrollto.js"
				"/vendor/modernizr.js"
				"/vendor/history.js"
				"/vendor/historyjsit.js"

				# Scripts
				"/scripts/script.js"

				# Analytics
				"""
				<script>
				var _gaq = _gaq || [];
				_gaq.push(['_setAccount', 'UA-35505181-1']);
				_gaq.push(['_setDomainName', 'bevry.me']);
				_gaq.push(['_trackPageview']);
				(function() {
					var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
					ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
					var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
				})();
				</script>

				<script src="//include.reinvigorate.net/re_.js"></script>
				<script>
				try {
				reinvigorate.track("dy05w-88s5zok1o8");
				} catch(err) {}
				</script>

				<script>
				var _gauges = _gauges || [];
				(function() {
					var t   = document.createElement('script');
					t.type  = 'text/javascript';
					t.async = true;
					t.id    = 'gauges-tracker';
					t.setAttribute('data-site-id', '5077ad8cf5a1f5067b000027');
					t.src = '//secure.gaug.es/track.js';
					var s = document.getElementsByTagName('script')[0];
					s.parentNode.insertBefore(t, s);
				})();
				</script>
				"""
			]


		# -----------------------------
		# Helper Functions

		# Names
		getName: getName
		getProjectName: getProjectName
		getCategoryName: getCategoryName
		getLinkName: getLinkName
		getLabelName: getLabelName

		# Get the prepared site/document title
		# Often we would like to specify particular formatting to our page's title
		# we can apply that formatting here
		getPreparedTitle: ->
			# if we have a document title, then we should use that and suffix the site's title onto it
			if @document.title
				"#{@document.pageTitle or @document.title} | #{@site.title}"
			# if our document does not have it's own title, then we should just use the site's title
			else
				@site.title

		# Get the prepared site/document description
		getPreparedDescription: ->
			# if we have a document description, then we should use that, otherwise use the site's description
			@document.description or @site.description

		# Get the prepared site/document keywords
		getPreparedKeywords: ->
			# Merge the document keywords with the site keywords
			@site.keywords.concat(@document.keywords or []).join(', ')



	# =================================
	# Collections

	collections:

		# Fetch all documents that exist within the learn directory
		learn: (database) ->
			database.findAllLive(
				{
					relativeOutDirPath: $startsWith: 'learn'
					body: $ne: ""
				},
				[projectDirectory:1,categoryDirectory:1,filename:1]
			).on('add', (document) ->
				a = document.attributes

				layout = 'doc'
				projectDirectory = pathUtil.basename pathUtil.resolve (pathUtil.dirname(a.fullPath) + '/..')
				project = projectDirectory.replace(/[\-0-9]+/,'')
				projectName = getProjectName(project)
				categoryDirectory = pathUtil.basename pathUtil.dirname(a.fullPath)
				category = categoryDirectory.replace(/^[\-0-9]+/,'')
				categoryName = getCategoryName(category)
				name = a.basename.replace(/^[\-0-9]+/,'')
				url = "/learn/#{project}-#{name}"
				title = "#{a.title or humanize name}"
				pageTitle = "#{title} | #{projectName}"

				document.set({
					title
					pageTitle
					layout
					projectDirectory
					project
					projectName
					categoryDirectory
					category
					categoryName
				})
				document.getMeta().set({
					url
				})
			)

		# Fetch all documents that have pageOrder set within their meta data
		pages: (database) ->
			database.findAllLive({relativeOutDirPath:'pages'},[filename:1])

		# Fetch all documents that have the tag "post" specified in their meta data
		posts: (database) ->
			database.findAllLive({relativeOutDirPath:'posts'},[date:-1]).on('add', (document) ->
				document.set({
					author: 'balupton'
				})
			)


	# =================================
	# DocPad Events

	events:

		# Server Extend
		# Used to add our own custom routes to the server before the docpad routes are added
		serverExtend: (opts) ->
			# Extract the server from the options
			{server,express} = opts
			docpad = @docpad

			# Forward to our application routing
			require(__dirname+'/app/routes.coffee')({docpad,server,express})


	# =================================
	# Plugin Configuration

	plugins:

		marked:
			markedOptions:
				sanitize: false
}

# Export our DocPad Configuration
module.exports = docpadConfig