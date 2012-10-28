// Requires
var httpUtil = require('http');
var fsUtil = require('fs');
var urlUtil = require('url');

// Configuration
var appConfig = {
	staticPath:  __dirname // __dirname+'/static'
};

// Handlers
var handleFiles = function(req,res){
	var url = urlUtil.parse(req.url);
	var path = appConfig.staticPath+url.pathname;  // definitely not secure

	// Check if path exists
	fsUtil.exists(path,function(exists){
		// If it does, read that file
		if ( exists ) {
			fsUtil.readFile(path,function(err,data){
				if (err)  throw err;
				res.end(data)
			});
		}
		// Otherwise return 404
		else {
			res.statusCode = 404;
			res.end('404 Not Found. Sorry.\n');
		}
	});
};

// Server
httpUtil.createServer(function(req,res){
	handleFiles(req,res);
}).listen(8000, '127.0.0.1');
console.log('Server running at http://127.0.0.1:8000/');