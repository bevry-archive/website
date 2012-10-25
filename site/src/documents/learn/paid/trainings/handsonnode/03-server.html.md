```
title: "Your first Web Server"
```

## Basic Server

``` javascript
var http = require('http');
http.createServer(function (req, res) {
	res.writeHead(200, {'Content-Type': 'text/plain'});
	res.end('hello world\n');
}).listen(8000, '127.0.0.1');
console.log('Server running at http://127.0.0.1:8000/');
```

## Server with Timeout

``` javascript
var http = require('http');
http.createServer(function (req, res) {
	res.writeHead(200, {'Content-Type': 'text/plain'});
	res.send('hello\n');
	setTimeout(function(){
		res.end('world\n');
	},4000);
}).listen(8000, '127.0.0.1');
console.log('Server running at http://127.0.0.1:8000/');
```

Benching it: `ab -n 100 -c 100 http://127.0.0.1:8000/`


## Echo Server

``` javascript
require('net').createServer(function(socket){
	socket.write('hello\n');
	socket.write('world\n');
	socket.on('data', function(data){
		socket.write(data.toString().toUpperCase())
	});
}).listen(8000);
console.log('Server running at http://127.0.0.1:8000/');
```

Communicate with it: `nc localhost 8000`


## Chat Server

``` javascript
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
```

Communicate with it: `nc localhost 8000`



## Upgrading to Express

``` javascript
var express = require('express');
var app = express();

app.get('/', function(req, res){
  res.send('hello world');
});

app.listen(3000);
```


## Adding Middlewares



## Adding Views



## Adding Templates

[Install DocPad](http://bevry.me/docpad/install)

``` javascript
// Create Server and Express Application
var express = require('express');
var http = require('http');
var app = express();
var server = http.createServer(app).listen(80);

// Add our Application Stuff
app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(app.router);

// Add DocPad to our Application
var docpadInstanceConfiguration = {
    // Give it our express application and http server
    serverExpress: app,
    serverHttp: server,
    // Tell it not to load the standard middlewares (as we handled that above)
    middlewareStandard: false
};
var docpadInstance = require('docpad').createInstance(docpadInstanceConfiguration, function(err){
    if (err)  return console.log(err.stack);
    // Tell DocPad to perform a generation, extend our server with its routes, and watch for changes
    docpad.action('generate server watch', function(err){
        if (err)  return console.log(err.stack);
    });
});

// Continue with your application
// ...
```



## Upgrading to DocPad


