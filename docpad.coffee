# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
docpadConfig = {

	# =================================
	# Template Data
	# These are variables that will be accessible via our templates
	# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData:

		# -----------------------------
		# Libraries

		moment: require('moment')


		# -----------------------------
		# Site Properties

		site:
			# The production url of our website
			url: "http://website.com"

			# The default title of our website
			title: "Your Website"

			# The website description (for SEO)
			description: """
				When your website appears in search results in say Google, the text here will be shown underneath your website's title.
				"""

			# The website keywords (for SEO) separated by commas
			keywords: """
				place, your, website, keywoards, here, keep, them, related, to, the, content, of, your, website
				"""


		# -----------------------------
		# Text

		text:
			heading: 'Bevry'
			subheading: 'doing whatever we can to empower developers everywhere'
			myaccount: 'My Account'

		link:
			salesemail: """
				<a href="mailto:sales@bevry.me">sales@bevry.me</a>
				"""
			salesphone:  """
				<a href="callto:+61280062364">+61 (2) 8006 2364</a>
				"""


		# -----------------------------
		# Helper Functions

		# Get the prepared site/document title
		# Often we would like to specify particular formatting to our page's title
		# we can apply that formatting here
		getPreparedTitle: ->
			# if we have a document title, then we should use that and suffix the site's title onto it
			if @document.title
				"#{@document.title} | #{@site.title}"
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

		# For instance, this one will fetch in all documents that have pageOrder set within their meta data
		pages: (database) ->
			database.findAllLive({relativeOutDirPath:'pages'},[filename:1])

		# This one, will fetch in all documents that have the tag "post" specified in their meta data
		posts: (database) ->
			database.findAllLive({relativeOutDirPath:'posts'},[date:-1])


	# =================================
	# DocPad Events

	events:

		# Server Extend
		# Used to add our own custom routes to the server before the docpad routes are added
		serverExtend: (opts) ->
			# Extract the server from the options
			{server} = opts
			docpad = @docpad

			# Forward to our application routing
			require(__dirname+'/app/routes.coffee')({docpad,server})


	# =================================
	# Plugin Configuration

	plugins:

		marked:
			markedOptions:
				sanitize: false
}

# Export our DocPad Configuration
module.exports = docpadConfig