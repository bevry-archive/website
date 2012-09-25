# Our custom routes for our DocPad Server
# Loaded via our require in the serverExtend event in our docpad.coffee configuration file
module.exports = (opts) ->
	# Prepare
	{docpad,server} = opts
	config = docpad.getConfig()

	# Projects
	server.get /^\/(?:g|gh|github)(?:\/(.*))?$/, (req, res) ->
		project = req.params[0] or ''
		res.redirect("https://github.com/bevry/#{project}", 301)

	# Twitter
	server.get /^\/(?:t|twitter|tweet)\/?.*$/, (req, res) ->
		res.redirect("https://twitter.com/bevryme", 301)

	# Twitter
	server.get /^\/(?:f|facebook)\/?.*$/, (req, res) ->
		res.redirect("https://www.facebook.com/bevryme", 301)

	# Do something
	return true