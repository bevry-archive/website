gittipNames = 'balupton bevry docpad interconnect startuphostel history.js'.split(' ')
githubNames = 'bevry docpad browserstate webwrite interconnectapp'.split(' ')

# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
docpadConfig = {

	# Regenerate each day
	regenerateEvery: 1000*60*60*24

	# =================================
	# Template Data
	# These are variables that will be accessible via our templates
	# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData:

		getGittipTotal: ->
			total = 0
			for name in gittipNames
				total += parseFloat(@feedr.feeds['gittip_'+name].receiving, 10)
			return total

		getDonationTotal: ->
			return @getGittipTotal()

		getDonationGoal: ->
			return 2000

		getDonationGoalPercent: (goal) ->
			goal ?= @getDonationGoal()
			return ((@getDonationTotal()/goal)*100).toFixed(2)

		isDonationEnough: ->
			return @getDonationGoalPercent() >= 100

		getGithubMembers: ->
			logins = {}

			for name in githubNames
				for member in @feedr.feeds['github_members_'+name]
					logins[member.login] =
						name: member.login
						avatar: member.avatar_url
						url: member.html_url

			# remove leaders from members as it's a bit dodgy if we list them twice
			for leader in @leaders
				delete logins[leader.githubUsername]  if leader.githubUsername

			members = (value  for own key,value of logins)

			return members

		leaders: [
			name: 'Benjamin Lupton'
			title: 'Benjamin Lupton, Founder'
			githubUsername: 'balupton'
			url: "http://balupton.com"
			avatar: '/images/ben-black.jpg'
			description: """
				<span class="today future">
					Open-Collaboration Entrepreneur. International Speaker & Trainer.<br/>
					Signer of the <a href="https://gist.github.com/balupton/6937426">Open Information Pledge</a>.
				</span>
				<span class="past">
					Bevry is the result of Benjamin's best self, a tool for him and others to create and collaborate on a shared vision of a better world. His works are at the foundations of Bevry and are some of the most popular node and javascript projects, even used by the likes of Microsoft and 37Signals. Besides work, he pursues the timeless quest of understanding the world and spends time with his family.
				</span>
				"""
		,
			name: 'Michael Duane Mooring'
			title: 'Mike Mooring, Community Custodian'
			githubUsername: 'mikeumus'
			url: "http://mikeum.us"
			avatar: '/images/mikeumus-tinted.jpg'
			description: """
				<span class="today future">
					<a href="http://www.solarsystemexpress.com/">Private Space/Open-Hardware Entrepreneur</a>. CoFounder of <a href="http://betabulls.com/">BetaBulls.</a><br/>
					Sees technology as a force of nature for good.
				</span>
				<span class="past">
					MDM, Sol-X, Inkwhy and many other startups have been a part of Mike's path in open-technology that has led him here to the present with Bevry.
				</span>
				"""
		]

		friends: [
			name: 'Myplanet'
			className: 'today future'
			url: "http://myplanet.io"
		,
			name: 'Meeho!'
			url: "http://meeho.net/"
		,
			name: 'DocPort'
			className: 'today future'
			url: "http://docport.io/"
		,
			name: 'BetaBulls'
			className: 'today future'
			url: "http://betabulls.com/"
		]

		projects: [
			name: 'DocPad'
			url: "http://docpad.org"
			description: """
				Decoupled Content Management System<br/>
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
			className: 'today future'
			url: 'http://startuphostel.net'
			description: """
				Co-work and co-live while you travel the world<br/>
				176 travellers
				"""
		,
			name: 'Static Site Generators'
			className: 'today future'
			url: 'http://staticsitegenerators.net'
			description: """
				Discover the right Static Site Generator for you<br/>
				224 static site generators
				"""
		,
			name: 'InterConnect'
			className: 'today future'
			url: 'http://bevry.github.io/interconnect/'
			description: """
				Connect with anyone in the world
				"""
		,
			name: 'Web Write'
			className: 'today future'
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
			title: "Bevry"

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


	plugins:
		feedr:
			feeds:
				(->
					result = {}
					for name in gittipNames
						result['gittip_'+name] = {url:"https://www.gittip.com/#{name}/public.json", parse:'json'}
					for name in githubNames
						result['github_members_'+name] = {url:"https://api.github.com/orgs/#{name}/public_members", parse:'json'}
					result
				)()


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
