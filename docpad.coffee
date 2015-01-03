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

		stripePublicKey: process.env.BEVRY_STRIPE_PUBLIC_KEY

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
			return (@getDonationTotal()/goal) * 100

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

		banks:
			"Transfers within Australia":
				"Account Name":    "Bevry Pty Ltd"
				"Account Number":  "10 253 342"
				"BSB":             "062 245"
				"BIC/Swift Code":  "CTBAAU2S"
				"Branch Address":  "Commonwealth Bank, Tenancy C3006, Top Ryde Shopping Centre, Cnr Blaxland Rd & Devlin St, Ryde, NSW, Australia, 2112"

			"International Transfers":
				"Account Name":    "Benjamin Lupton"
				"Account Number":  "431 033 190"
				"BSB":             "242 200"
				"BIC/Swift Code":  "CITIAU2X"
				"Branch Address":  "Citibank, Citigroup Centre, 2 Park Street, Sydney, NSW, Australia, 2000"


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
			className: 'today future'
			title: 'Mike Mooring, Community Custodian'
			githubUsername: 'mikeumus'
			url: "http://mikeum.us"
			avatar: '/images/mikeumus-tinted.jpg'
			description: """
				<a href="http://www.solarsystemexpress.com/">Private Space/Open-Hardware Entrepreneur</a>. CoFounder of <a href="http://betabulls.com/">BetaBulls.</a><br/>
				Sees technology as a force of nature for good.
				"""
		,
			name: 'Eduán'
			className: 'today future'
			title: 'Eduán, King of the Documentation'
			githubUsername: 'Greduan'
			url: 'http://greduan.com'
			avatar: '/images/eduan.png'
			description: """
				Hobby programmer and freelancer, a <a href="http://eduanlavaque.com">blogger</a>, <br/> an aspiring full stack developer and software engineer, and a <a href="http://www.gnu.org/philosophy/free-sw.html">Free Software</a> advocate.
				"""
		]

		friends: [
			name: 'Myplanet'
			className: 'today future'
			url: "http://myplanet.io"
			# sponsorship
		,
			name: 'Meeho!'
			url: "http://meeho.net/"
			# advisory
		,
			name: 'Meltmedia'
			className: 'today future'
			url: 'http://meltmedia.com/'
			# provided docpad branding
		].sort (a,b) -> a.name - b.name

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
			url: 'http://startuphostel.org'
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
			url: "http://bevry.me"

			# Here are some old site urls that you would like to redirect from
			oldUrls: [
				'refresh.bevry.me',
				'bevry-refresh.herokuapp.com'
			]

			# The default title of our website
			title: "Bevry"

			# The website description (for SEO)
			description: """
				An open company and community dedicated to empowering developers everywhere.
				"""

			# The website keywords (for SEO) separated by commas
			keywords: """
				bevry, bevryme, balupton, benjamin lupton, docpad, history.js, node.js, javascript, coffee-script, query-engine, open-source, open-collaboration, open-company, free-culture
				"""

			# Services
			services:
				#disqus: 'bevry'
				#gauges: '5077ad8cf5a1f5067b000027'
				googleAnalytics: 'UA-35505181-1'
				reinvigorate: 'dy05w-88s5zok1o8'
				#zopim: '0tni8T2G7P86SxDwmxCa4HCySsGPRESg'

			# The website's styles
			styles: [
				'/vendor/normalize.css'
				'/vendor/h5bp.css'
				'/styles/style.css'
			]

			# The website's scripts
			scripts: [
				"""
				<script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.0/jquery.min.js"></script>
				"""

				#'/vendor/log.js'
				'/vendor/modernizr.js'
				#'/vendor/retina.js'
				'//checkout.stripe.com/checkout.js'
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
			request = require('request')
			extendr = require('extendr')
			codeSuccess = 200
			codeBadRequest = 400
			codeRedirectPermanent = 301
			codeRedirectTemporary = 302

			# As we are now running in an event,
			# ensure we are using the latest copy of the docpad configuraiton
			# and fetch our urls from it
			latestConfig = docpad.getConfig()
			oldUrls = latestConfig.templateData.site.oldUrls or []
			newUrl = latestConfig.templateData.site.url

			# Redirect any requests accessing one of our sites oldUrls to the new site url
			server.use (req,res,next) ->
				if req.headers.host in oldUrls
					res.redirect(codeRedirectPermanent, newUrl+req.url)
				else
					next()

			# Pushover
			server.all '/pushover', (req,res) ->
				return res.send(codeSuccess)  if 'development' in docpad.getEnvironments()
				request(
					{
						url: "https://api.pushover.net/1/messages.json"
						method: "POST"
						form: extendr.extend(
							{
								token: process.env.BEVRY_PUSHOVER_TOKEN
								user: process.env.BEVRY_PUSHOVER_USER_KEY
								message: req.query
							}
							req.query
						)
					}
					(_req,_res,body) ->
						res.send(body)
				)

			# Documentation Projects
			server.get /^\/(docpad|node|queryengine|joe|taskgroup|community|bevry)(?:[\/\-](.*))?$/, (req,res) ->
				res.redirect(codeRedirectPermanent, "http://learn.bevry.me/#{req.params[0] or ''}/#{req.params[1] or ''}")

			# Documentation
			server.get /^\/learn(?:\/(.*))$/, (req,res) ->
				res.redirect(codeRedirectPermanent, "http://learn.bevry.me/#{req.params[0] or ''}")

			# Old Pages
			server.get /^\/(services|projects|about)\/?$/, (req,res) ->
				res.redirect(codeRedirectPermanent, "/##{req.params[0] or ''}")

			# Projects
			server.get /^\/(?:g|gh|github|project)(?:\/(.*))?$/, (req,res) ->
				res.redirect(codeRedirectPermanent, "https://github.com/bevry/#{req.params[0] or ''}")

			# Common Redirects
			redirects =
					'/terms': '/tos'
					'/donate': '/#donate'
					'/interconnect': '/project/interconnect'
					'/payment': '/#payment'
					'/goopen': 'https://github.com/bevry/goopen'
					'/gittip': 'https://www.gittip.com/bevry/'
					'/flattr': 'http://flattr.com/thing/344188/balupton-on-Flattr'
					'/premium-support': '/support'
					'/support': '/learn/support'
					'/docs/installnode': '/learn/node/install'
					'/node/install': '/learn/node/install'
					'/talks/handsonnode': 'http://node.eventbrite.com/'
					'/node.zip': 'https://www.dropbox.com/s/masz4vl1b4btwfw/hands-on-node-examples.zip'
			server.use (req,res,next) ->
				target = redirects[req.url]
				if target
					res.redirect(codeRedirectPermanent, target)
				else
					next()

}

# Export our DocPad Configuration
module.exports = docpadConfig
