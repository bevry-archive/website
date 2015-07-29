gratipayNames = 'bevry'.split(' ')
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

		getGratipayTotal: ->
			total = 0
			for name in gratipayNames
				total += parseFloat(@feedr.feeds['gratipay_'+name].receiving, 10)
			return total

		getDonationTotal: ->
			return @getGratipayTotal()

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
			"All Transfers (Within Australia and outside Australia)":
				"Account Name":    "Benjamin Lupton"
				"Account Number":  "473 167 138"
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
				<a href="http://www.solarsystemexpress.com/">Private Space/Open-Hardware Entrepreneur</a>. CTO at <a href="http://rentalgeek.com/">RentalGeek.com</a><br/>
				Sees technology as a force of nature for good.
				"""
		]

		friends: [
			name: 'Myplanet'
			className: 'today'
			url: "http://myplanet.io"
			# sponsorship
		,
			name: 'Meeho!'
			url: "http://meeho.net/"
			# advisory
		,
			name: 'Hybris'
			className: 'today'
			url: "http://hybris.com"
			# sponsorship
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
			url: 'https://github.com/browserstate'
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
			url: 'https://github.com/webwrite'
			description: """
				Admin Interfaces for any backend
				"""
		]

		# Specify some site properties
		site:
			# The production url of our website
			url: "http://bevry.me"

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
				#reinvigorate: 'dy05w-88s5zok1o8'
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
					for name in gratipayNames
						result['gratipay_'+name] = {url:"https://www.gratipay.com/#{name}/public.json", parse:'json'}
					for name in githubNames
						result['github_members_'+name] = {url:"https://api.github.com/orgs/#{name}/public_members", parse:'json'}
					result
				)()

		cleanurls:

			simpleRedirects:
				'/contact': '/#contact'
				'/terms': '/tos'
				'/donate': '/#donate'
				'/interconnect': '/project/interconnect'
				'/payment': '/#payment'
				'/goopen': 'https://github.com/bevry/goopen'
				'/bitcoin': 'https://coinbase.com/checkouts/9ef59f5479eec1d97d63382c9ebcb93a?r=516032d5fc3baa863b000010'
				'/paypal': 'https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&amp;hosted_button_id=QB8GQPZAH84N6'
				'/wishlist': 'http://amzn.com/w/2F8TXKSNAFG4V'
				'/flattr': 'http://flattr.com/thing/344188/balupton-on-Flattr'
				'/gratipay': 'https://www.gratipay.com/bevry/'
				'/gittip': '/gratipay'
				'/premium-support': '/support'
				'/support': '/learn/support'
				'/docs/installnode': '/learn/node/install'
				'/node/install': '/learn/node/install'
				'/talks/handsonnode': 'http://node.eventbrite.com/'
				'/node.zip': 'https://www.dropbox.com/s/masz4vl1b4btwfw/hands-on-node-examples.zip'

			advancedRedirects: [
				# Old URLs
				[/^https?:\/\/(refresh\.bevry\.me|herokuapp\.com|bevry\.github\.io\/website)(.*)$/, 'https://bevry.me$1']

				# Documentation Projects
				[/^\/(docpad|node|queryengine|joe|taskgroup|community|bevry)(?:[\/\-](.*))?$/, 'http://learn.bevry.me/$1/$2']

				# Documentation
				[/^\/learn(?:\/(.*))$/, 'http://learn.bevry.me/$1']

				# Old Pages
				[/^\/(services|projects|about)\/?$/, '/#$1']

				# Projects
				[/^\/(?:g|gh|github|project)(?:\/(.*))?$/, 'https://github.com/bevry/$1']
			]

}

# Export our DocPad Configuration
module.exports = docpadConfig
