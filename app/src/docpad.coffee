# Require
pathUtil = require('path')
_ = require('underscore')
moment = require('moment')
strUtil = require('underscore.string')

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

	# Regenerate every hour
	regenerateEvery: 1000*60*60


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
			)

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
		# before each generation, this will keep the documenation up to date on the live site
		generateBefore: (opts,next) ->
			# Check
			return next()  if opts.reset is false  # do not clone on partial generations

			# Prepare
			balUtil = require('bal-util')
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
			balUtil = require('bal-util')
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