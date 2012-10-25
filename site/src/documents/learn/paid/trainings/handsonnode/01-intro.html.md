```
title: What is Node.js?
```

## What is Node?

Node breaks JavaScript out of the box of the browser, and brings it to the desktop to create remarkable new opportunities.


## Why should I care?

Before node, apps were generally like this on one or more points:
- Naturally slow - operations happened in a blocking fashion
- No environment re-use - different people and code needed for back-end and front-end environments
- Limited - great for a particular subset of tasks (e.g. shell scripting or web pages) but require complex approaches for tasks outside that subset (e.g. RubyMotion and HipHop)

Node apps are like this:
- Naturally fast - operations occur in an asynchronous and non-blocking fashion
- Environment re-use - people and code can be shared between back-end and front-end environments
- Powerful - great for a wide range of tasks out of the box (similar to Java and .NET)


## How is this possible?

These complimentary parts:

1. It is JavaScript. While JavaScript has its oddities, people can come to appreciate its flexibility and power. In that you can do whatever you want with it, the way you want, without limitations. This is testified by the AltJS community and JavaScript's vastness of different solutions to similar problems.

2. It is naturally asynchronous. JavaScript has a unique position as it allows you to code high-level asynchronous and non-blocking code while being aloof to the low-level technical challenges and implementations behind such a thing (aka threading). Writing asynchronous code is as easy as a callback function which anyone who has written a jQuery event handler already knows how to do.

Together, this allows node to offer a non-blocking abilities easily and intuitively. As an example, this means you can read multiple files at the same time (in parallel) without blocking unnecessarily (waiting on something). In other languages, generally you would have to read the files one after the other (serially) waiting on each file to finish reading, before moving onto the next (blocking) - which is very slow. Now sure, non-blocking and parallel capabilities are in other languages, but you need a huge brain to understand how to write them correctly without shooting your foot off - javascript makes it as easy as writing a event handler or callback function with the underlying (and vastly unnecessary) complexity hidden away, making such power more accessible to the masses.


## Examples

The following examples showcase the fundamental differences between node and other languages:

- ### Node

	``` javascript
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
	```

- ### PHP

	``` php
	<?php
	# Example 1
	echo "hello\n";
	sleep(2);
	echo "world\n";

	# Example 2
	$contents = file_get_contents('some-text-file.txt');
	if ( $contents === false ) {
		echo "error occured\n";
		exit(-1);
	} else {
		echo $contents;
	}

	# Example 3
	$one = file_get_contents('one.txt');
	$two = file_get_contents('two.txt');
	if ( $one === false || $two === false ) {
		echo "error occured\n";
		exit(-1);
	} else {
		echo "one: $one\n";
		echo "two: $two\n";
	}

	# Example 4
	# ... o_O ...
	```



## Caution

Beware of these things:

1. Adding asynchronous flow to an entirely synchronous program will cause you to have to re-write your application. You are better off just jumping the learning hurdle of asynchronous code at the start. For example, so far you have written your application all with synchronous calls because it was easier, then at some point, you needed to do an asynchronous call, this causes a break in your flow that requires all future execution in your application to operate asynchronously.

2. Adding synchronous flow to an asynchronous program will require some flow control management (there are plenty of flow control libraries you can use to alleviate this complexity). For example, if you want to perform multiple tasks in parallel, but once they have all completed, then move onto the next task.

These are not issues in in naturally synchronous languages, as they do not have the benefit of asynchronous flow to begin with.
