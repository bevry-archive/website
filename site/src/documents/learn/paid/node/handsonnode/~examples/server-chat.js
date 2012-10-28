var net = require('net');
var sockets = [];
net.createServer(function(socket){
	sockets.push(socket);
	socket.write('hello\n');
	socket.write('world\n');
	socket.on('data', function(data){
		var i;
		for (i=0; i < sockets.length; i++){
			if (sockets[i] === socket)  continue;
			sockets[i].write(data.toString());
		}
	});
	socket.on('end', function(){
		var i = sockets.indexOf(socket);
		delete sockets[i];
	});
}).listen(8000);
console.log('Server running at http://127.0.0.1:8000/');