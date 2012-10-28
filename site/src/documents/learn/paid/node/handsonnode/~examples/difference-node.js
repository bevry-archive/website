// Example 1
setTimeout(function(){
	console.log('world');
},2000);
console.log('hello');

// Example 2
require('fs').readFile('some-text-file.txt', function(err,data){
	if (err)  throw err;
	console.log(data.toString());
});

// Example 3
var fsUtil = require('fs');
fsUtil.readFile('one.txt', function(err,data){
	if (err)  throw err;
	console.log('one:',data.toString());
});
fsUtil.readFile('two.txt', function(err,data){
	if (err)  throw err;
	console.log('two:',data.toString());
});

// Example 4
var http = require('http');
http.createServer(function (req, res) {
	res.writeHead(200, {'Content-Type': 'text/plain'});
	res.end('Hello World\n');
}).listen(1337, '127.0.0.1');
console.log('Server running at http://127.0.0.1:1337/');