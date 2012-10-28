var http = require('http');
http.createServer(function (req, res) {
	res.writeHead(200, {'Content-Type': 'text/plain'});
	res.send('hello\n');
	setTimeout(function(){
		res.end('world\n');
	},4000);
}).listen(8000, '127.0.0.1');
console.log('Server running at http://127.0.0.1:8000/');