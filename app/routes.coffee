# Requires
passport = require('passport')
GitHubStrategy = require('passport-github').Strategy
mongo = require('mongodb')
urlUtil = require('url')
RedisSessionStore = null
balUtil = require('bal-util')
request = require('request')
{queryEngine,Backbone} = require('docpad')

# Application Configuration
envConfig = process.env
appConfig =
	site:
		url: envConfig.BEVRY_SITE_URL
	auth:
		github:
			clientID: envConfig.BEVRY_GITHUB_ID
			clientSecret: envConfig.BEVRY_GITHUB_SECRET
	databaseMongo: (->
		url = urlUtil.parse(envConfig.BEVRY_MONGODB_URL)
		auth = url.auth?.split(':')
		data =
			name: url.path.substr(1)
			host: url.hostname
			port: parseInt(url.port,10)
			username: auth[0]
			password: auth[1]
			serverOptions:
				auto_reconnect: true
		return data
	)()
	databaseRedis: (->
		url = urlUtil.parse(envConfig.BEVRY_REDIS_URL)
		auth = url.auth.split(':')
		data =
			host: url.hostname
			port: parseInt(url.port,10)
			username: auth[0]
			password: auth[1]
		return data
	)()

# Database
databaseUserCollection = null
mongoServer = new mongo.Server(appConfig.databaseMongo.host, appConfig.databaseMongo.port, appConfig.databaseMongo.serverOptions)
mongoConnector = new mongo.Db(appConfig.databaseMongo.name, mongoServer, {safe:true})
mongoConnector.open (err,database) ->
	throw err  if err
	console.log('connected database')
	database.authenticate appConfig.databaseMongo.username, appConfig.databaseMongo.password, (err,result) ->
		throw err  if err
		console.log('authenticated database')
		database.collection 'users', (err,collection) ->
			console.log('connected collection')
			databaseUserCollection = collection

# Configure Passport
passport.serializeUser (user,next) ->
	next(null,user.username)
passport.deserializeUser (username,next) ->
	databaseUserCollection.findOne {username}, (err,item) ->
		next(err,item)

# Ensure Authenticated
ensureAuthenticated = (req,res,next) ->
	return next()  if req.isAuthenticated()
	res.redirect('/')


# -------------------------
# Configuration

# Our custom routes for our DocPad Server
# Loaded via our require in the serverExtend event in our docpad.coffee configuration file
module.exports = (opts) ->
	# Prepare
	{docpad,server,express} = opts
	config = docpad.getConfig()

	# Redirection Route Generator
	redirect = (url,code=301) -> (req,res) ->
		res.redirect(url,code)

	# -------------------------
	# Authentiction

	# Require
	RedisSessionStore ?= require('connect-redis')(express)
	redisSessionStoreOptions =
		host: appConfig.databaseRedis.host
		port: appConfig.databaseRedis.port
		db: appConfig.databaseRedis.username
		pass: appConfig.databaseRedis.password
		no_ready_check: true
		ttl: 60*60  # hour

	# Setup
	server.use express.cookieParser()
	server.use express.session({
		secret: 'secret'
		cookie:
			maxAge: 100*60*60
		store: new RedisSessionStore(redisSessionStoreOptions)
	})
	server.use passport.initialize()
	server.use passport.session()

	# Strategies
	passport.use(new GitHubStrategy({
			clientID: appConfig.auth.github.clientID
			clientSecret: appConfig.auth.github.clientSecret
			callbackURL: appConfig.site.url+'/auth/github/callback'
			scope: ['public_repo', 'repo', 'delete_repo']
		},
		(accessToken,refreshToken,profile,next) ->
			# Prepare the user
			user =
				displayName: profile.displayName
				username: profile.username
				email: profile._json.email
				location: profile._json.location
				profileUrl: profile.profileUrl
				githubUrl: profile.profileUrl
				githubToken: accessToken
				githubApiUrl: profile._json.url
				avatarId: profile._json.gravatar_id
				avatarUrl: profile._json.avatar_url
				bio: profile._json.bio
				companyName: profile._json.company

			# Fetch the user
			passport.deserializeUser user.username, (err,item) ->
				return next(err)  if err
				# We have the user already
				if item
					console.log('found user', item)
					databaseUserCollection.update {username:user.username}, {$set:{githubToken:user.githubToken}}, (err,item) ->
						return next(err)  if err
						console.log('updated user', item)
						next(null,user)
				# We need to create the user
				else
					console.log('inserting user', user)
					databaseUserCollection.insert user, (err,item) ->
						return next(err)  if err
						console.log('inserted user', item)
						next(null,user)
	))

	# Github route
	server.all(
		'/auth/github'
		(req,res,next) ->
			req.session.originalUrl = req.headers.referer or '/'
			next()
		passport.authenticate('github')
	)

	# Logged in route
	server.all(
		'/auth/github/callback',
		passport.authenticate('github',{failureRedirect:'/500'}),
		(req,res) ->
			res.redirect(req.session.originalUrl or '/')
	)

	# Logout route
	server.all '/logout', (req,res) ->
		req.logout()
		res.redirect(req.headers.referer or '/')


	# -------------------------
	# Routes

	# Projects
	server.get /^\/(?:g|gh|github)(?:\/(.*))?$/, (req, res) ->
		project = req.params[0] or ''
		res.redirect(301, "https://github.com/bevry/#{project}")

	# Twitter
	server.get /^\/(?:t|twitter|tweet)\/?.*$/, redirect("https://twitter.com/bevryme")

	# Facebook
	server.get /^\/(?:f|facebook)\/?.*$/, redirect("https://www.facebook.com/bevryme")

	# Growl
	server.get "/docpad/growl", redirect("http://growl.info/downloads")

	# Pushover
	server.all '/pushover', (req,res) ->
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

	# Done
	return true