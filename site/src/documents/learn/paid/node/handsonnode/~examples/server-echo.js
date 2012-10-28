var net = require('net');
net.createServer(function(socket){
	socket.write('hello\n');
	socket.write('world\n');
	socket.on('data', function(data){
		socket.write(data.toString().toUpperCase())
	});
}).listen(8000);
console.log('Server running at http://127.0.0.1:8000/');