// Requires
var connect = require('connect');

// Configuration
var appConfig = {
	staticPath:  __dirname // __dirname+'/static'
};

// Server
var app = connect()
	.use(connect.static(appConfig.staticPath))
	.use(function(req,res,next){
		res.statusCode = 404;
		res.end('404 Not Found. Sorry.\n');
	})
	.listen(8000);