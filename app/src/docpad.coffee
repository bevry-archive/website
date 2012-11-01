# Require
fsUtil = require('fs')
pathUtil = require('path')
_ = require('underscore')
moment = require('moment')
strUtil = require('underscore.string')
balUtil = require('bal-util')

# Prepare
rootPath = __dirname+'/../..'
appPath = __dirname
sitePath = rootPath+'/site'
textData = require(appPath+'/text')


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
docpadConfig =

	# =================================
	# DocPad Configuration

	# Paths
	rootPath: rootPath
	outPath: rootPath+'/site/out'
	srcPath: rootPath+'/site/src'
	reloadPaths: [
		appPath
	]


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
		projects: require(appPath+'/projects')
		trainings: require(appPath+'/trainings')
		testimonials: [
				text: """
					I had the pleasure of working along side Ben during a recent web development project. This was no small time web-development project mind you, we worked together with a team of 20 developers on a multi-million dollar software build for a medical device manufacturer. Ben joined us mid-project and I was amazed at how quickly he got up to speed on both the technical and process side of the project. Within days of joining the project Ben was already getting his hands dirty, helping refactor our framework, coding new features, and making suggestions on how to improve completed components. Ben's knowledge of User interface implementation & Javascipt is second to none and he is always willing to take the time to share his knowledge with his teammates.

					On a personal note, I always found Ben to be outgoing, friendly & approachable. He tackles new challenges with a positive & professional attitude. I would recommend Ben for any web development role, especially on projects involving emerging technologies.
					"""
				time: "November 19, 2011"
				qualities: ["Great Results", "Personable", "Creative"]
				author: "Tim Baguley"
				authorLink: "http://au.linkedin.com/pub/tim-baguley/9/46b/430"
				job: "Project Manager"
				company: "AcidGreen"
				companyLink: "http://www.acidgreen.com.au/"
			,

				text: """
					Ben has worked with us for 4 months, and I wish we could keep him longer! It's hard to adequately convey the value he's added to our business, product and our team. A rare combination of quality, speed and consistency. Ben has not only performed above expectation, he's consistently gone above and beyond the call to ensure he delivers the best possible product. Couldn't possibly recommend him highly enough!
					"""
				time: "June 13, 2012"
				qualities: ["Great Results", "Personable", "High Integrity"]
				author: "Alan Downie"
				authorLink: "http://au.linkedin.com/in/alandownie"
				job: "Founder"
				company: "BugHerd"
				companyLink: "http://bugherd.com/"
			,
				text: """
					Ben could be described as a JavaScript evangelist. His in-depth knowledge of best practices provides him with a solid foundation on how best to refactor existing solutions, and ways to implement new ones. He's highly motivated and capable of adopting project standards within days, something I was very impressed by. Ben has been a fantastic asset to our project and team, and I look forward to working with him again.
					"""
				time: "February 17, 2012"
				author: "Emmanuel Negri"
				authorLink: "http://au.linkedin.com/in/emmanuelnegri"
				job: "Development Manager"
				company: "AcidGreen"
				companyLink: "http://www.acidgreen.com.au/"
			,
				text: """
					Ben is a very talented Javascript developer. He's extremely efficient and produces top-notch work. He's also easy going and a very helpful developer to work alongside. I hope we get to work together again in the future, and would highly recommend him to potential clients.
					"""
				time: "June 30, 2012"
				author: "Nicholas Firth-McCoy"
				authorLink: "http://au.linkedin.com/in/nfirthmccoy"
				job: "Founder"
				company: "Paydirt"
				companyLink: "https://paydirtapp.com/"
			,
				text: """
					Ben has that magic and rare combination of a phenomenal depth of knowledge, coupled with an ability to just get stuff done. Hands down the best Javascript developer I've ever worked with, and whenever I have a tricky project that others would pass as impossible, I reach for his phone number first.
					"""
				time: "October 7, 2011"
				author: "Andrew Jessup"
				authorLink: "http://au.linkedin.com/in/andrewjessup"
				job: "Founder"
				company: "Noosbox"
			,
				text: """
					I worked with Ben for 5 months. He is a fantastic person to work with. He is always willing to help out and go that extra mile. He is one of the Best front end developers I have ever worked with. I don't think there is something that Ben cannot produce with JavaScript. Ben would be a great asset to any organisation. And I could not recommend him more highly.
					"""
				time: "February 12, 2012"
				author: "Ciaran Hale"
				authorLink: "http://au.linkedin.com/pub/ciaran-hale/3a/9a2/867"
				job: "Development Programmer"
				company: "AcidGreen"
				companyTitle: "http://www.acidgreen.com.au/"
			,
				text: """
					Ben has been such an asset to our team. He works well with others, produces fantastic work, thinks outside the box and is just a generally all-round good guy to work with.
					"""
				qualities: ["Great Results", "Personable", "High Integrity"]
				time: "August 15, 2011"
				author: "Nikki Durkin"
				authorLink: "http://au.linkedin.com/in/nikkidurkin"
				job: "Founder"
				company: "99dresses"
				companyLink: "http://99dresses.com/"
			,
				text: """
					I worked with Ben for two months, and he has shown himself to be a very skilled and hardworking developer. His teamwork was exceptional and he displayed strong problem-solving skills. As the backend developer, he had a habit of anticipating my needs before I'd written the relevant section of code. A pleasure to work with and highly recommended.
					"""
				time: "December 12, 2011"
				author: "Sharif Olorin"
				authorUrl: "http://au.linkedin.com/pub/sharif-olorin/24/475/700"
				job: "Lead Backend Developer"
				company: "99dresses"
				companyLink: "http://99dresses.com/"
			,
				text: """
					Passionate people are priceless. Benjamin is that kind of person, interested to new technologies, open-minded and curious. He loves his jobs and loves what he is doing on the Internet. I highly recommend him and I'm looking forward to work again with him !
					"""
				time: "May 27, 2011"
				author: "Thomas Lété"
				authorLink: "http://be.linkedin.com/in/thomaslete"
				job: "Core Team"
				company: "Aloha Editor"
				companyUrl: "http://aloha-editor.org/"
			,
				text: """
					Benjamin is a highly skilled and knowledgeable developer with utilizing Web 2.0 solutions and such technologies as jQuery and AJAX. I had the opportunity to work along side him on the Webb & Brown Neaves redesign, it was a large project which required his expertise with these technologies. Ben played a lead role from the start with the creation and development of the AJAX framework and jQuery effects used. I was new to this sort of technology and I have learned a lot from him. He was always precise to details and his jQuery skills were very impressive.
					"""
				time: "May 4, 2009"
				author: "Bruno Lenette"
				authorLink: "http://au.linkedin.com/pub/bruno-lenette/13/3a2/428"
				job: "Web Developer"
				company: "Platform Interactive"
			,
				text: """
					Ben is a keen website developer that pays a lot of attention to writing clean effective code and has a good handle on the latest emerging web technologies.
					"""
				qualities: ["Great Results", "Expert", "High Integrity"]
				time: "November 16, 2008"
				author: "Dean Usher"
				authorLink: "http://www.linkedin.com/in/deanusher"
				job: "Founder"
				company: "Dean Usher Web Design"
				companyTitle: "http://www.deanusher.com/"
		]


		# -----------------------------
		# Site Properties

		site:
			# The production url of our website
			url: "http://bevry.me"

			# The default title of our website
			title: "Bevry - Node.js, Backbone.js & JavaScript Consultancy in Sydney, Australia"

			# The website description (for SEO)
			description: """
				We're a Node.js, Backbone.js and JavaScript consultancy in Sydney Australia with a focus on empowering developers. We've created History.js one of the most popular javascript projects in the world, and DocPad an amazing Node.js Content Management System. We’re also working on setting up several Startup Hostels all over the world, enabling entreprenuers to travel, collaborate, and live their dream lifestyles cheaper than back home.
				"""

			# The website keywords (for SEO) separated by commas
			keywords: """
				bevry, bevryme, balupton, benjamin lupton, docpad, history.js, node, node.js, javascript, coffeescript, startup hostel, query engine, queryengine, backbone.js, cson
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
			# if we have a title, we should use it suffixed by the site's title
			if @document.pageTitle isnt false and @document.title
				"#{@document.pageTitle or @document.title} | #{@site.title}"
			# if we don't have a title, then we should just use the site's title
			else if @document.pageTitle is false or @document.title? is false
				@site.title

		# Get the prepared site/document description
		getPreparedDescription: ->
			# if we have a document description, then we should use that, otherwise use the site's description
			@document.description or @site.description

		# Get the prepared site/document keywords
		getPreparedKeywords: ->
			# Merge the document keywords with the site keywords
			@site.keywords.concat(@document.keywords or []).join(', ')

		# Read File
		readFile: (relativePath) ->
			path = @document.fullDirPath+'/'+relativePath
			result = fsUtil.readFileSync(path)
			if result instanceof Error
				throw result
			else
				return result.toString()

		# Code File
		codeFile: (relativePath,language) ->
			language ?= pathUtil.extname(relativePath).substr(1)
			contents = @readFile(relativePath)
			return """<pre><code class="#{language}">#{contents}</code></pre>"""


	# =================================
	# Collections

	collections:

		# Fetch all documents that exist within the learn directory
		# And give them the following meta data based on their file structure
		# #{project}/#{category}/[\-0-9]+#{name}/document.extension
		learn: (database) ->
			query =
				relativeOutDirPath: $startsWith: 'learn'
				body: $ne: ""
			sorting = [projectDirectory:1, categoryDirectory:1, filename:1]
			database.findAllLive(query,sorting).on 'add', (document) ->
				# Prepare
				a = document.attributes

				# Properties
				layout = 'doc'
				standalone = true
				projectDirectory = pathUtil.basename pathUtil.resolve (pathUtil.dirname(a.fullPath) + '/..')
				project = projectDirectory.replace(/[\-0-9]+/,'')
				projectName = getProjectName(project)
				categoryDirectory = pathUtil.basename pathUtil.dirname(a.fullPath)
				category = categoryDirectory.replace(/^[\-0-9]+/,'')
				categoryName = getCategoryName(category)
				name = a.basename.replace(/^[\-0-9]+/,'')
				url = "/learn/#{project}-#{name}"
				slug = "/#{project}/#{name}"
				urls = [slug]
				title = "#{a.title or humanize name}"
				pageTitle = "#{title} | #{projectName}"

				# Apply
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
					slug
					url
					urls
					standalone
				})
				document.getMeta().set({
					slug
					url
					urls
				})

		# Fetch all documents that have pageOrder set within their meta data
		pages: (database) ->
			database.findAllLive({relativeOutDirPath:'pages'},[filename:1])

		# Fetch all documents that have the tag "post" specified in their meta data
		posts: (database) ->
			database.findAllLive({relativeOutDirPath:'posts'},[date:-1]).on('add', (document) ->
				document.set({
					ignored: true
					write: false
					author: 'balupton'
				})
			)


	# =================================
	# DocPad Events

	events:

		# Clone/Update our DocPad Documentation Repository
		docpadReady: (opts,next) ->
			# Prepare
			docpad = @docpad
			config = docpad.getConfig()

			# Specify the repos
			repos =
				'docpad-documentation':
					path: pathUtil.join(config.documentsPaths[0],'learn','docs','docpad')
					url:'git://github.com/bevry/docpad-documentation.git'

			# Clone them out
			tasks = new balUtil.Group(next)
			for own repoKey,repoValue of repos
				tasks.push repoValue, (complete) ->
					balUtil.initOrPullGitRepo(balUtil.extend({
						remote: 'origin'
						branch: 'master'
						output: true
						next: (err) ->
							# warn about errors, but don't let them kill execution
							docpad.warn(err)  if err
							complete()
					},@))
			tasks.async()

			# Done
			return

		# Write
		writeAfter: (opts,next) ->
			# Prepare
			docpad = @docpad
			config = docpad.getConfig()
			sitemap = []
			sitemapPath = config.outPath+'/sitemap.txt'
			siteUrl = config.templateData.site.url

			# Get all the html files
			docpad.getCollection('html').forEach (document) ->
				if document.get('sitemap') isnt false and document.get('write') isnt false and document.get('ignored') isnt true and document.get('body')
					sitemap.push siteUrl+document.get('url')

			# Write the sitemap file
			balUtil.writeFile(sitemapPath, sitemap.sort().join('\n'), next)

			# Done
			return

		# Server Extend
		# Used to add our own custom routes to the server before the docpad routes are added
		serverExtend: (opts) ->
			# Extract the server from the options
			{server,express} = opts
			docpad = @docpad

			# Pushover
			server.all '/pushover', (req,res) ->
				return res.send(200)  if 'development' in docpad.getEnvironments()
				request(
					{
						url: "https://api.pushover.net/1/messages.json"
						method: "POST"
						form: balUtil.extend(
							{
								token: envConfig.BEVRY_PUSHOVER_TOKEN
								user: envConfig.BEVRY_PUSHOVER_USER_KEY
								message: req.query
							}
							req.query
						)
					}
					(_req,_res,body) ->
						res.send(body)
				)

			# Projects
			server.get /^\/(?:g|gh|github)(?:\/(.*))?$/, (req,res) ->
				project = req.params[0] or ''
				res.redirect(301, "https://github.com/bevry/#{project}")

			# Twitter
			server.get /^\/(?:t|twitter|tweet)\/?.*$/, (req,res) -> res.redirect(301, "https://twitter.com/bevryme")

			# Facebook
			server.get /^\/(?:f|facebook)\/?.*$/, (req,res) -> res.redirect(301, "https://www.facebook.com/bevryme")

			# Forward to our application routing
			if 'development' in docpad.getEnvironments()
				require(appPath+'/routes')({docpad,server,express})

			# Done
			return


# Export our DocPad Configuration
module.exports = docpadConfig