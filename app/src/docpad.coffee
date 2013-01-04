# Require
fsUtil = require('fs')
pathUtil = require('path')
_ = require('underscore')
moment = require('moment')
strUtil = require('underscore.string')
balUtil = require('bal-util')
{requireFresh} = balUtil
feedr = new (require('feedr').Feedr)

# Prepare
rootPath = __dirname+'/../..'
appPath = __dirname
sitePath = rootPath+'/site'
textData = requireFresh(appPath+'/templateData/text')


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

# Humanize
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

	# Regenerate each day
	regenerateEvery: 1000*60*60*24


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
		projects: requireFresh(__dirname+'/templateData/projects')
		promos: requireFresh(__dirname+'/templateData/promos')
		sponsors: requireFresh(__dirname+'/templateData/sponsors')
		testimonials: requireFresh(__dirname+'/templateData/testimonials')
		users: requireFresh(__dirname+'/templateData/users')


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

			# Services
			services:
				disqus: 'bevry'
				gauges: '5077ad8cf5a1f5067b000027'
				googleAnalytics: 'UA-4446117-1'
				reinvigorate: '52uel-236r9p108l'
				zopim: '0tni8T2G7P86SxDwmxCa4HCySsGPRESg'

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
				"/scripts/bevry.js"
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
				document.setMetaDefaults({
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

		pages: (database) ->
			database.findAllLive({relativeOutDirPath:$startsWith:'pages'},[filename:1])

		posts: (database) ->
			database.findAllLive({relativeOutDirPath:$startsWith:'posts'},[date:-1]).on 'add', (document) ->
				document.setMetaDefaults({
					ignored: true
					write: false
					author: 'balupton'
				})

	# =================================
	# DocPad Plugins

	plugins:
		highlightjs:
			aliases:
				stylus: 'css'

	environments:
		development:
				coffeekup:
					format: false

	# =================================
	# DocPad Events

	events:

		# Clone/Update our DocPad Documentation Repository
		generateBefore: (opts,next) ->
			# Prepare
			docpad = @docpad
			config = docpad.getConfig()
			tasks = new balUtil.Group(next)

			# Skip if we are doing a differential generate
			return next()  if opts.reset is false or 'development' in docpad.getEnvironments()

			# Log
			docpad.log('info', "Updating Documentation...")

			# Repos
			repos =
				'docpad-documentation':
					path: pathUtil.join(config.documentsPaths[0],'learn','free','docpad')
					url:'git://github.com/bevry/docpad-documentation.git'
			for own repoKey,repoValue of repos
				tasks.push repoValue, (complete) ->
					balUtil.initOrPullGitRepo(balUtil.extend({
						remote: 'origin'
						branch: 'master'
						output: true
						next: (err) ->
							# warn about errors, but don't let them kill execution
							docpad.warn(err)  if err
							docpad.log('info', "Updated Documentation")
							complete()
					},@))

			# Fire
			tasks.async()
			return

		# Add Contributors to the Template Data
		extendTemplateData: (opts,next) ->
			# Prepare
			docpad = @docpad
			contributors = {}
			opts.templateData.contributors = {}

			# Log
			docpad.log('info', "Fetching Contributors...")

			# Tasks
			tasks = new balUtil.Group (err) ->
				# Check
				return next(err)  if err

				# Handle
				delete contributors['benjamin lupton']
				contributorsNames = _.keys(contributors).sort()
				for contributorName in contributorsNames
					opts.templateData.contributors[contributorName] = contributors[contributorName]

				# Log
				docpad.log('info', "Fetched Contributors")

				# Done
				return next()

			# Contributors
			contributorFeeds = [
				"https://api.github.com/users/docpad/repos?per_page=100&client_id=#{process.env.BEVRY_GITHUB_CLIENT_ID}&client_secret=#{process.env.BEVRY_GITHUB_CLIENT_SECRET}"
				"https://api.github.com/users/bevry/repos?per_page=100&client_id=#{process.env.BEVRY_GITHUB_CLIENT_ID}&client_secret=#{process.env.BEVRY_GITHUB_CLIENT_SECRET}"
			]
			feedr.readFeeds contributorFeeds, (err,feedRepos) ->
				for repos in feedRepos
					for repo in repos
						packageUrl = repo.html_url.replace('//github.com','//raw.github.com')+'/master/package.json'
						tasks.push {repo,packageUrl}, (complete) ->
							feedr.readFeed @packageUrl, (err,packageData) ->
								return complete()  if err or !packageData  # ignore
								for contributor in packageData.contributors or []
									contributorMatch = /^([^<(]+)\s*(?:<(.+?)>)?\s*(?:\((.+?)\))?$/.exec(contributor)
									continue  unless contributorMatch
									contributorData =
										name: (contributorMatch[1] or '').trim()
										email: (contributorMatch[2] or '').trim()
										url: (contributorMatch[3] or '').trim()
									contributorId = contributorData.name.toLowerCase()
									contributors[contributorId] = contributorData
								complete()

				# Fire
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
			request = require('request')

			# Pushover
			server.all '/pushover', (req,res) ->
				return res.send(200)  if 'development' in docpad.getEnvironments()
				request(
					{
						url: "https://api.pushover.net/1/messages.json"
						method: "POST"
						form: balUtil.extend(
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

			# DocPad Documentation
			server.get /^\/(?:learn\/docpad-)(.*)$/, (req,res) ->
				res.redirect(301, "http://docpad.org/docs/#{req.params[0] or ''}")

			# Projects
			server.get /^\/(?:g|gh|github)(?:\/(.*))?$/, (req,res) ->
				res.redirect(301, "https://github.com/bevry/#{req.params[0] or ''}")

			# Twitter
			server.get /^\/(?:t|twitter|tweet)(?:\/(.*))?$/, (req,res) -> res.redirect(301, "https://twitter.com/bevryme")

			# Facebook
			server.get /^\/(?:f|facebook)(?:\/(.*))?$/, (req,res) -> res.redirect(301, "https://www.facebook.com/bevryme")

			# Forward to our application routing
			# if 'development' in docpad.getEnvironments()
			#	require(appPath+'/routes')({docpad,server,express})

			# Done
			return


# Export our DocPad Configuration
module.exports = docpadConfig