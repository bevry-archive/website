# Require
fsUtil = require('fs')
pathUtil = require('path')
moment = require('moment')
{requireFresh} = require('requirefresh')

# Prepare
rootPath = pathUtil.resolve(__dirname+'/../..')
appPath = __dirname
sitePath = rootPath+'/site'
templateData = requireFresh(appPath+'/templateData')
textData = templateData.text
websiteVersion = requireFresh(rootPath+'/package.json').version
contributorsGetter = null
contributors = null
pin = null
isProduction = process.env.NODE_ENV is 'production'


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
	text = text.replace(/[-_]/g, ' ').replace(/\s+/g, ' ')
	text =
		(for piece in text.split(' ')
			piece.substr(0,1).toUpperCase()+piece.substr(1)
		).join(' ')
	return text


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

	templateData: require('extendr').extend templateData,

		# -----------------------------
		# Misc

		uniq: require('uniq')
		moment: moment
		nodeVersion: process.version
		nodeMajorMinorVersion: process.version.replace(/^v/,'').split('.')[0...2].join('.')


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
				pin: process.env.BEVRY_PIN_API_KEY_PUBLIC

				gittipButton: 'bevry'
				flattrButton: '344188/balupton-on-Flattr'
				paypalButton: 'QB8GQPZAH84N6'

				#disqus: 'bevry'
				gauges: '5077ad8cf5a1f5067b000027'
				googleAnalytics: 'UA-35505181-1'
				reinvigorate: '52uel-236r9p108l'
				#zopim: '0tni8T2G7P86SxDwmxCa4HCySsGPRESg'

			# Styles
			styles: [
				'/styles/style.css'
			].map (url) -> "#{url}?websiteVersion=#{websiteVersion}"

			# Scripts
			scripts: [
				# External
				(if isProduction then "https://api.pin.net.au/pin.js" else "https://test-api.pin.net.au/pin.js")

				# Vendor
				"/vendor/jquery.js"
				"/vendor/log.js"
				"/vendor/jquery.scrollto.js"
				"/vendor/modernizr.js"
				"/vendor/history.js"
				"/vendor/historyjsit.js"

				# Scripts
				"/scripts/payment.js"
				"/scripts/bevry.js"
				"/scripts/script.js"
			].map (url) -> "#{url}?websiteVersion=#{websiteVersion}"


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

		# Get Contributors
		getContributors: -> contributors or []


	# =================================
	# Collections

	collections:

		# Fetch all documents that exist within the learn directory
		# And give them the following meta data based on their file structure
		learn: (database) ->
			query =
				relativePath: $startsWith: 'learn'
				body: $ne: ""
				ignored: false
			sorting = [projectDirectory:1, categoryDirectory:1, filename:1]
			database.findAllLive(query, sorting).on 'add', (document) ->
				# Prepare
				a = document.attributes

				###
				learn/#{organisation}/#{project}/#{category}/#{filename}
				###
				pathDetailsExtractor = ///
					^
					.*?learn/
					(.+?)/        # organisation
					(.+?)/        # project
					(.+?)/        # category
					(.+?)\.       # basename
					(.+?)         # extension
					$
				///

				pathDetails = pathDetailsExtractor.exec(a.relativePath)

				# Properties
				layout = 'doc'
				standalone = true
				organisationDirectory = organisation = organisationName =
					projectDirectory = project = projectName =
					categoryDirectory = category = categoryName =
					title = pageTitle = null

				# Check if we are correctly structured
				if pathDetails?
					organisationDirectory = pathDetails[1]
					projectDirectory = pathDetails[2]
					categoryDirectory = pathDetails[3]
					basename = pathDetails[4]

					organisation = organisationDirectory.replace(/[\-0-9]+/, '')
					organisationName = humanize(project)

					project = projectDirectory.replace(/[\-0-9]+/, '')
					projectName = getProjectName(project)

					category = categoryDirectory.replace(/^[\-0-9]+/, '')
					categoryName = getCategoryName(category)

					name = basename.replace(/^[\-0-9]+/,'')

					title = "#{a.title or humanize name}"
					pageTitle = "#{title} | #{projectName}"

					absoluteLink = longLink = "/learn/#{project}-#{name}"
					shortLink = "/#{project}/#{name}"
					urls = [longLink, shortLink]

					githubEditUrl = "https://github.com/#{organisationDirectory}/documentation/edit/master/"
					proseEditUrl = "http://prose.io/##{organisationDirectory}/documentation/edit/master/"
					editUrl = githubEditUrl + a.relativePath.replace('learn/bevry/', '')

					if organisation is 'docpad'
						absoluteLink = "http://docpad.org/docs/#{name}"
						document.set(
							render: false
							write: false
						)
						if category is 'partners'
							document.set(
								ignored: true
							)

					# Apply
					document
						.setMetaDefaults({
							layout
							standalone

							name
							title
							pageTitle

							absoluteLink
							longLink
							shortLink
							url: urls[0]

							editUrl

							organisationDirectory
							organisation
							organisationName

							projectDirectory
							project
							projectName

							categoryDirectory
							category
							categoryName
						})
						.addUrl(urls)

				# Otherwise ignore this document
				else
					console.log "The document #{a.relativePath} was at an invalid path, so has been ignored"
					document.setMetaDefaults({
						ignore: true
						render: false
						write: false
					})

		pages: (database) ->
			database.findAllLive({relativeOutDirPath:$startsWith:'pages'},[filename:1])



	# =================================
	# Plugins

	plugins:
		highlightjs:
			aliases:
				stylus: 'css'

		repocloner:
			repos: [
				{
					name: 'Bevry Documentation'
					path: 'src/documents/learn/bevry'
					url: 'https://github.com/bevry/documentation.git'
				}
				{
					name: 'DocPad Documentation'
					path: 'src/documents/learn/docpad/docpad'
					url: 'https://github.com/docpad/documentation.git'
				}
			]


	# =================================
	# Environments

	# Disable analytic services on the development environment
	environments:
		development:
			templateData:
				site:
					services:
						gauges: false
						googleAnalytics: false
						mixpanel: false
						reinvigorate: false


	# =================================
	# Events

	events:

		# Generate Before
		generateBefore: (opts) ->
			# Reset contributors if we are a complete generation (not a partial one)
			contributors = null

			# Return
			return true

		# Fetch Contributors
		renderBefore: (opts,next) ->
			# Prepare
			docpad = @docpad

			# Check
			return next()  if contributors

			# Log
			docpad.log('info', 'Fetching your latest contributors for display within the website')

			# Prepare contributors getter
			contributorsGetter ?= require('getcontributors').create(
				#log: docpad.log
				github_client_id: process.env.BEVRY_GITHUB_CLIENT_ID
				github_client_secret: process.env.BEVRY_GITHUB_CLIENT_SECRET
			)

			# Fetch contributors
			users = ['bevry', 'docpad', 'webwrite', 'browserstate']
			contributorsGetter.fetchContributorsFromUsers users, (err,_contributors=[]) ->
				# Check
				return next(err)  if err

				# Apply
				contributors = _contributors
				docpad.log('info', "Fetched your latest contributors for display within the website, all #{_contributors.length} of them")

				# Complete
				return next()

			# Return
			return true

		# Server Extend
		# Used to add our own custom routes to the server before the docpad routes are added
		serverExtend: (opts) ->
			# Extract the server from the options
			{server,express} = opts
			docpad = @docpad
			request = require('request')
			codeSuccess = 200
			codeBadRequest = 400
			codeRedirectPermanent = 301
			codeRedirectTemporary = 302

			# Pushover
			server.all '/pushover', (req,res) ->
				return res.send(200)  if 'development' in docpad.getEnvironments()
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

			# Documentation Regenerate Hook
			# Automatically regenerate when new changes are pushed to our documentation
			server.all '/regenerate', (req,res) ->
				if req.query?.key is process.env.WEBHOOK_KEY
					docpad.log('info', 'Regenerating for documentation change')
					docpad.action('generate', {populate:true, reload:true})
					res.send(codeSuccess, 'regenerated')
				else
					res.send(codeBadRequest, 'key is incorrect')

			# DocPad Documentation
			server.get /^\/(?:learn\/docpad-)(.*)$/, (req,res) ->
				res.redirect(codeRedirectPermanent, "http://docpad.org/docs/#{req.params[0] or ''}")

			# Projects
			server.get /^\/(?:g|gh|github)(?:\/(.*))?$/, (req,res) ->
				res.redirect(codeRedirectPermanent, "https://github.com/bevry/#{req.params[0] or ''}")

			# Twitter
			server.get /^\/(?:t|twitter|tweet)(?:\/(.*))?$/, (req,res) -> res.redirect(301, "https://twitter.com/bevryme")

			# Facebook
			server.get /^\/(?:f|facebook)(?:\/(.*))?$/, (req,res) -> res.redirect(301, "https://www.facebook.com/bevryme")

			# Payment
			server.all '/payment', (req,res) ->
				pin ?= require('pinjs').setup({
					key: process.env.BEVRY_PIN_API_KEY_PRIVATE,
					production: isProduction
				})
				req.body.amount *= 100   # convert cents to dollars
				req.body.amount += 30    # add 30c transaction fee
				req.body.amount *= 1.04  # add 3% transaction fee with 1% leeway
				pin.createCharge req.body, (pinResponse) ->
					console.log(pinResponse.body)
					res.send(pinResponse.statusCode, pinResponse.body)
					#res.redirect(req.headers.referer)

			# Done
			return


# Export our DocPad Configuration
module.exports = docpadConfig