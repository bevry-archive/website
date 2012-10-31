// Example 1
setTimeout(function(){
	console.log('world');
},2000);
console.log('hello');

// Example 2
require('fs').readFile('difference-node.js', function(err,data){
	if (err)  throw err;
	console.log(data.toString());
});

// Example 3
require('fs').readFile('difference-node.js', function(err,data){
	if (err)  throw err;
	console.log('one:',data.toString());
});
require('fs').readFile('difference-php.php', function(err,data){
	if (err)  throw err;
	console.log('two:',data.toString());
});

// Example 4
require('http').createServer(function(req,res){
	res.writeHead(200, {'Content-Type': 'text/plain'});
	res.end('Hello World\n');
}).listen(8000, '127.0.0.1');