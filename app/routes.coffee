# Our custom routes for our DocPad Server
# Loaded via our require in the serverExtend event in our docpad.coffee configuration file
module.exports = (opts) ->
	# Prepare
	{docpad,server} = opts
	config = docpad.getConfig()

	# Do something
	return true