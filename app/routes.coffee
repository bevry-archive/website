# Our custom routes for our DocPad Server
# Loaded via our require in the serverExtend event in our docpad.coffee configuration file
module.exports = (opts) ->
	# Prepare
	{docpad,server} = opts
	config = docpad.getConfig()

	# Redirection Route Generator
	redirect = (url,code=301) -> (req,res) ->
		res.redirect(url,code)

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

	# Done
	return true