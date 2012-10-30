// Requires
var express = require('express');
var io = require('socket.io');

// Configuration
var appConfig = {
	staticPath:  __dirname // __dirname+'/static'
};

// Application
var app = express();
var server = require('http').createServer(app);
io.listen(server);

// Middlewares
app.use(express.static(appConfig.staticPath));
app.use(function(req,res,next){
	res.send(404, '404 Not Found. Sorry.\n');
});

// Socket
io.sockets.on('connection', function (socket) {
	socket.emit('news', { hello: 'world' });
	socket.on('my other event', function (data) {
		console.log(data);
	});
});

// Listen
server.listen(8000);