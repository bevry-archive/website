var http = require('http');
http.createServer(function (req, res) {
	res.writeHead(200, {'Content-Type': 'text/plain'});
	res.write('hello\n');
	setTimeout(function(){
		res.end('world\n');
	},2000);
}).listen(8000, '127.0.0.1');