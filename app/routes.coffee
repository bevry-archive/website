# Requires
passport = require('passport')
GitHubStrategy = require('passport-github').Strategy
mongo = require('mongodb')
balUtil = require('bal-util')
request = require('request')
{queryEngine,Backbone} = require('docpad')

# Environment Configuration
envConfigLocalPath = __dirname+'/../env.coffee'
envConfigLocalData =
	try
		require(envConfigLocalPath)
	catch err
		null
envConfig =
	NODE_ENV: null
	BEVRY_DB_USERNAME: null
	BEVRY_DB_PASSWORD: null
	BEVRY_GITHUB_ID: null
	BEVRY_GITHUB_SECRET: null
	BEVRY_SITE_URL: null
	BEVRY_PUSHOVER_TOKEN: null
	BEVRY_PUSHOVER_USER_KEY: null
for own key,value of envConfig
	envConfig[key] = value ? envConfigLocalData?[key] ? process.env[key] ? null

# Application Configuration
appConfig =
	site:
		url: envConfig.BEVRY_SITE_URL
	auth:
		github:
			clientID: envConfig.BEVRY_GITHUB_ID
			clientSecret: envConfig.BEVRY_GITHUB_SECRET
	db:
		host: 'alex.mongohq.com'
		port: 10027
		name: 'bevry'
		serverOptions:
			auto_reconnect: true
		username: envConfig.BEVRY_DB_USERNAME
		password: envConfig.BEVRY_DB_PASSWORD

# Database
databaseUserCollection = null
mongoServer = new mongo.Server(appConfig.db.host, appConfig.db.port, appConfig.db.serverOptions)
mongoConnector = new mongo.Db(appConfig.db.name, mongoServer, {safe:true})
mongoConnector.open (err,database) ->
	throw err  if err
	console.log('connected database')
	database.authenticate appConfig.db.username, appConfig.db.password, (err,result) ->
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

	# Setup
	server.use express.cookieParser()
	server.use express.session({secret: 'secret'})
	server.use passport.initialize()
	server.use passport.session()

	# Strategies
	passport.use(new GitHubStrategy({
			clientID: appConfig.auth.github.clientID
			clientSecret: appConfig.auth.github.clientSecret
			callbackURL: appConfig.site.url+'/auth/github/callback'
			scope: ['public_repo', 'repo']
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