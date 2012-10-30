// Requires
var express = require('express');

// Application
var app = express();

// Routes
app.get('/', function(req, res){
  res.send('hello world');
});

// Server
var server = app.listen(8000);