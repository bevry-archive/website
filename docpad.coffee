# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
docpadConfig = {

	# =================================
	# Template Data
	# These are variables that will be accessible via our templates
	# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData:

		people: [
			name: 'Benjamin Lupton'
			title: 'Benjamin Lupton, Founder'
			url: "http://balupton.com"
			avatar: '/images/ben-black.jpg'
			description: """
				Open-Collaboration Entrepreneur. International Speaker & Trainer.
				"""
		]

		projects: [
			name: 'DocPad'
			url: "http://docpad.org"
			description: """
				Decoupled Content management System<br/>
				500 daily users
				"""
		,
			name: 'History.js'
			url: 'http://historyjs.net'
			description: """
				Create Stateful Web-Applications<br/>
				Used in <a href="http://basecamp.com" title="Visit Basecamp's Website">Basecamp</a>
				"""
		,
			name: 'Startup Hostel Network'
			url: 'http://startuphostel.net'
			description: """
				Co-work and co-live while you travel the world<br/>
				200 travellers
				"""
		,
			name: 'Static Site Generators'
			url: 'http://staticsitegenerators.net'
			description: """
				Discover the right Static Site Generator for you<br/>
				208 static site generators
				"""
		,
			name: 'InterConnect'
			url: 'http://bevry.github.io/interconnect/'
			description: """
				Connect with anyone in the world
				"""
		,
			name: 'Web Write'
			url: 'http://github.com/webwrite'
			description: """
				Admin Interfaces for any backend
				"""
		]

		# Specify some site properties
		site:
			# The production url of our website
			url: "http://website.com"

			# Here are some old site urls that you would like to redirect from
			oldUrls: [
				'www.website.com',
				'website.herokuapp.com'
			]

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

			# The website's styles
			styles: [
				'/vendor/normalize.css'
				'/vendor/h5bp.css'
				'/styles/style.css'
			]

			# The website's scripts
			scripts: [
				"""
				<!-- jQuery -->
				<script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.0/jquery.min.js"></script>
				"""

				'/vendor/log.js'
				'/vendor/modernizr.js'
				'/vendor/retina.js'
				'/scripts/script.js'
			]


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
	# DocPad Events

	# Here we can define handlers for events that DocPad fires
	# You can find a full listing of events on the DocPad Wiki
	events:

		# Server Extend
		# Used to add our own custom routes to the server before the docpad routes are added
		serverExtend: (opts) ->
			# Extract the server from the options
			{server} = opts
			docpad = @docpad

			# As we are now running in an event,
			# ensure we are using the latest copy of the docpad configuraiton
			# and fetch our urls from it
			latestConfig = docpad.getConfig()
			oldUrls = latestConfig.templateData.site.oldUrls or []
			newUrl = latestConfig.templateData.site.url

			# Redirect any requests accessing one of our sites oldUrls to the new site url
			server.use (req,res,next) ->
				if req.headers.host in oldUrls
					res.redirect(newUrl+req.url, 301)
				else
					next()
}

# Export our DocPad Configuration
module.exports = docpadConfig