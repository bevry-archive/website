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
				<span class="today future">
					Open-Collaboration Entrepreneur. International Speaker & Trainer.<br/>
					Signer of the <a href="https://gist.github.com/balupton/6937426">Open Information Pledge</a>.
				</span>
				<span class="past">
					Bevry is the result of Benjamin's best self, a tool for him and others to create and collaborate on a shared vision of a better world. His works are at the foundations of Bevry and are some of the most popular node and javascript projects, even used by the likes of Microsoft and 37Signals. Besides work, he pursues the timeless quest of understanding the world and spends time with his family.
				</span>
				"""
		]

		partners: [
			name: 'Myplanet Digital'
			className: 'today future'
			url: "http://myplanet.io"
		,
			name: 'Meeho!'
			url: "http://meeho.net/"
		]

		members: [
			"https://0.gravatar.com/avatar/1254365f8c7b7af893a73fb937799afe?d=https%3A%2F%2Fidenticons.github.com%2F12e326f34aed0974724d3652b11620aa.png&r=x&s=140",
			"https://1.gravatar.com/avatar/195e7bb9c2826a301f259dc82ca57af2?d=https%3A%2F%2Fidenticons.github.com%2Facb3e29171829ebd25544aa20017060c.png&r=x&s=140",
			"https://1.gravatar.com/avatar/61000b294b0049e12fccc6b843ee8362?d=https%3A%2F%2Fidenticons.github.com%2Fe5288d00c9e82c82e6efb0e3a2463d13.png&r=x&s=140",
			"https://1.gravatar.com/avatar/cb9730ee11d50fa2db955d687c653971?d=https%3A%2F%2Fidenticons.github.com%2Ff4ab3d7c9207c8c6a32aabb28771410f.png&r=x&s=140",
			"https://1.gravatar.com/avatar/f1fde02832bb928ff4aa21003f18b2d0?d=https%3A%2F%2Fidenticons.github.com%2F1be5fc884dcb49bf5b314178e84bd407.png&r=x&s=140",
			"https://1.gravatar.com/avatar/79fd240b791cb7302f1b3b4db7da29da?d=https%3A%2F%2Fidenticons.github.com%2F634cc4d8c7fc37d109c5c41630665f17.png&r=x&s=140",
			"https://2.gravatar.com/avatar/de54fa84f07f7200da5a1eb090ec717a?d=https%3A%2F%2Fidenticons.github.com%2Fc6c23de9a86ace2fd9002c29a6e101ae.png&r=x&s=140",
			"https://0.gravatar.com/avatar/43e5b51eafc17ce863a0e8857129ed3d?d=https%3A%2F%2Fidenticons.github.com%2F34f8abbbdc6ba7c58517087f8fc1273d.png&r=x&s=140",
			"https://2.gravatar.com/avatar/62f254352f0e2a467a27863a7650214b?d=https%3A%2F%2Fidenticons.github.com%2F6d28cf7ac65740b304b56e3e920cbb74.png&r=x&s=140",
			"https://1.gravatar.com/avatar/3af2f6446adbf53feecfe8c107c492f5?d=https%3A%2F%2Fidenticons.github.com%2F9bfe669065a2edf1147379d780c803b0.png&r=x&s=140",
			"https://2.gravatar.com/avatar/998383246165b167b132ae97e312d45c?d=https%3A%2F%2Fidenticons.github.com%2Fa58797a42b13a7382f21cc647464a66e.png&r=x&s=140",
			"https://0.gravatar.com/avatar/7e945991d1d70075cff59331d72ef4d8?d=https%3A%2F%2Fidenticons.github.com%2F5d6d17375e48728255af334496b52416.png&r=x&s=140",
			"https://1.gravatar.com/avatar/35eeb838cbb7c747884f5f557408d873?d=https%3A%2F%2Fidenticons.github.com%2Fa0eb6c9b409044e3bd36785d06f1a65e.png&r=x&s=140",
			"https://2.gravatar.com/avatar/133b8110316db82742129865def45b7a?d=https%3A%2F%2Fidenticons.github.com%2F52c339c2f6c693b435c5d7ba25e868bf.png&r=x&s=140",
			"https://2.gravatar.com/avatar/70d2c699f89a1f7f76b436bc79b4d5be?d=https%3A%2F%2Fidenticons.github.com%2F02dd9d6fa55c9d5aac64e001ab72dcd2.png&r=x&s=140",
			"https://1.gravatar.com/avatar/e4926c0cb9fccda01e7abedc774cef36?d=https%3A%2F%2Fidenticons.github.com%2F2069c03086075e10fa9650961a003845.png&r=x&s=140",
			"https://1.gravatar.com/avatar/1de6337421c1eac0227c88502b275952?d=https%3A%2F%2Fidenticons.github.com%2F245403f0ec118644e403ddd11c5797e9.png&r=x&s=140",
			"https://1.gravatar.com/avatar/5b5664d512030cbf9f973b6887a1baed?d=https%3A%2F%2Fidenticons.github.com%2F4a268fe717dc162413bb6e173073f28a.png&r=x&s=140",
			"https://2.gravatar.com/avatar/663c67028e5dc73d70ce113b9e6f60e0?d=https%3A%2F%2Fidenticons.github.com%2Fec217a295ad037d83410386fe4cb8932.png&r=x&s=140",
			"https://2.gravatar.com/avatar/30eb6199dd8f0703feb4a63440608dff?d=https%3A%2F%2Fidenticons.github.com%2F1e62426dc281bbdcdb05d63ddc0975ab.png&r=x&s=140",
			"https://1.gravatar.com/avatar/af4c77eab8989748f3e508a19d0375e6?d=https%3A%2F%2Fidenticons.github.com%2F2c361c16489a6af9c09c1d8fa13d2d03.png&r=x&s=140",
			"https://1.gravatar.com/avatar/2694a5501ec37eab0c6d4bf98c30303a?d=https%3A%2F%2Fidenticons.github.com%2F3af66742fd76c1ad392733d99ece4fcd.png&r=x&s=140",
			"https://2.gravatar.com/avatar/9400cb5aeb155ccec614652542fd274d?d=https%3A%2F%2Fidenticons.github.com%2F28fbafb0c2a98d9a643600bd876de1b4.png&r=x&s=140"
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