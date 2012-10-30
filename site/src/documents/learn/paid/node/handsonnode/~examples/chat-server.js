// Requires
var express = require('express');
var socketio = require('socket.io');

// Configuration
var appConfig = {
	staticPath:  __dirname // __dirname+'/static'
};

// Application
var app = express();
var server = require('http').createServer(app);
var io = socketio.listen(server);

// Middlewares
app.use(express.static(appConfig.staticPath));
app.use(function(req,res,next){
	res.send(404, '404 Not Found. Sorry.\n');
});

// Socket
io.sockets.on('connection', function(socket){
	socket.on('message', function(message){
		console.log('received message:', message);
		io.sockets.emit('message', message);
	});
});

// Listen
server.listen(8000);