---
title: Using Joe
---

## Using within node
See [`src/example/everything.test.coffee`](https://github.com/bevry/joe/blob/master/src/example/everything.test.coffee) for the tests

Note, if you want your node tests to only run within node and not within web browsers, you can change the requires to:
``` coffeescript
assert = require('assert')
joe = require('joe')
```

## Using within web browsers
See [`test-web/index.html`](https://github.com/bevry/joe/blob/master/test-web/index.html) for the markup, and [`src/example/everything.test.coffee`](https://github.com/bevry/joe/blob/master/src/example/everything.test.coffee) for the tests.

Note, if you want your web browser tests to only run within web browsers and not within node, you can change the requires to:
``` coffeescript
assert = @assert
joe = @joe
```

## Writing your tests

### Suites
A suite is a collection of tests. You define a suite by using `suite 'name', (suite,test) ->`. If you require, you can use a completion callback by doing `suite 'name', (suite,test,complete) ->`. When you don't use a completion callback, the suite will complete once all tests have completed.

### Tests
Tests are define by doing `test 'name', ->`. If you require, you can use a completion callback by doing `test 'name', (complete) ->`. When you don't use a completion callback, the test will complete once it has been executed.

### Execution Order
When you define a test, it is added to the queue of its parent Suite, and executed in order synchronously once the Suite has reached has finished executing.

For instance, take the following example:
``` coffeescript
joe.suite 'our suite', (suite,test) ->
	test 'first test', (complete) ->
		setTimeout(
			->
				console.log('this will be outputted second')
				complete()
			1000
		)
	test 'second test', ->
		console.log('this will be outputted third')
	console.log('this will be outputted first')
```

This will output:
```
our suite
this will be outputted first
our suite ➞  first test
this will be outputted second
our suite ➞  first test ✔
our suite ➞  second test
this will be outputted third
our suite ➞  second test ✔
our suite ✔

2/2 tests ran successfully, everything passed
```

Without the completion callback in the first test, it would complete as soon as it has finished executing, which means it would complete before the timeout has completed, meaning that the second test would execute before the first test has actually finished, which is why we have support for completion callbacks.

The reason we created Joe, is that [Mocha](https://github.com/visionmedia/mocha) [does not support](https://gist.github.com/2306572) such execution flow, and would often just exit early or not run at all under such conditions. This is why Joe is awesome.

### Joe loves Chai
While completely independent of Joe, Joe works absolutely lovely with the [Chai](http://chaijs.com/) project. Chai provides us with assertions in the form of assert, should, and expect. It runs within the browser, and within node. It makes life a lot more lovely.


## Reporters

### Console
The console reporter logs the starting and completions of both suites and tests. It runs in the browser, and inside node. Here is the result when run again [`src/test/joe.test.coffee`](https://github.com/bevry/joe/blob/master/src/test/joe.test.coffee):

```
$ node out/test/joe.test.js
parent
parent ➞  async-suite
parent ➞  async-suite ➞  1/2
parent ➞  async-suite ➞  1/2 ✔
parent ➞  async-suite ➞  2/2
parent ➞  async-suite ➞  2/2 ✔
parent ➞  async-suite
parent ➞  async-tests
parent ➞  async-tests ➞  1/2
parent ➞  async-tests ➞  1/2 ✔
parent ➞  async-tests ➞  2/2
parent ➞  async-tests ➞  2/2 ✔
parent ➞  async-tests
parent ➞  sync
parent ➞  sync ➞  1/2
parent ➞  sync ➞  1/2 ✔
parent ➞  sync ➞  2/2
parent ➞  sync ➞  2/2 ✔
parent ➞  sync
parent ➞  async-sync
parent ➞  async-sync ➞  1/2
parent ➞  async-sync ➞  1/2 ✔
parent ➞  async-sync ➞  2/2
parent ➞  async-sync ➞  2/2 ✔
parent ➞  async-sync
parent ➞  deliberate-failure
parent ➞  deliberate-failure ➞  1/2
parent ➞  deliberate-failure ➞  1/2 ✔
parent ➞  deliberate-failure ➞  2/2
parent ➞  deliberate-failure ➞  2/2 ✘
parent ➞  deliberate-failure ✘
parent ✘

9/10 tests ran successfully, 1 failed

Failure #1:
parent ➞  deliberate-failure ➞  2/2
AssertionError: false == true
    at /Volumes/Storage/Users/balupton/Projects/joe/out/test/joe.test.js:75:25
    at /Volumes/Storage/Users/balupton/Projects/joe/out/lib/joe.js:79:13
    at Suite.runTask (/Volumes/Storage/Users/balupton/Projects/bal-util/lib/flow.js:260:11)
    at Suite.nextTask (/Volumes/Storage/Users/balupton/Projects/bal-util/lib/flow.js:252:16)
    at Suite.complete (/Volumes/Storage/Users/balupton/Projects/bal-util/lib/flow.js:182:20)
    at /Volumes/Storage/Users/balupton/Projects/bal-util/lib/flow.js:196:33
    at /Volumes/Storage/Users/balupton/Projects/joe/out/lib/joe.js:74:18
    at Object._onTimeout (/Volumes/Storage/Users/balupton/Projects/joe/out/test/joe.test.js:71:20)
    at Timer.ontimeout (timers.js:94:19)
```

### List
The console reporter logs the completed and failed tests, not caring about their starting points or about suites. It runs in the browser, and inside node. Here is the result when run again [`src/test/joe.test.coffee`](https://github.com/bevry/joe/blob/master/src/test/joe.test.coffee):
```
$ node out/test/joe.test.js
✔  parent ➞  async-suite ➞  1/2
✔  parent ➞  async-suite ➞  2/2
✔  parent ➞  async-tests ➞  1/2
✔  parent ➞  async-tests ➞  2/2
✔  parent ➞  sync ➞  1/2
✔  parent ➞  sync ➞  2/2
✔  parent ➞  async-sync ➞  1/2
✔  parent ➞  async-sync ➞  2/2
✔  parent ➞  deliberate-failure ➞  1/2
✘  parent ➞  deliberate-failure ➞  2/2

9/10 tests ran successfully, 1 failed

Failure #1:
parent ➞  deliberate-failure ➞  2/2
AssertionError: false == true
    at /Volumes/Storage/Users/balupton/Projects/joe/out/test/joe.test.js:75:25
    at /Volumes/Storage/Users/balupton/Projects/joe/out/lib/joe.js:79:13
    at Suite.runTask (/Volumes/Storage/Users/balupton/Projects/bal-util/lib/flow.js:260:11)
    at Suite.nextTask (/Volumes/Storage/Users/balupton/Projects/bal-util/lib/flow.js:252:16)
    at Suite.complete (/Volumes/Storage/Users/balupton/Projects/bal-util/lib/flow.js:182:20)
    at /Volumes/Storage/Users/balupton/Projects/bal-util/lib/flow.js:196:33
    at /Volumes/Storage/Users/balupton/Projects/joe/out/lib/joe.js:74:18
    at Object._onTimeout (/Volumes/Storage/Users/balupton/Projects/joe/out/test/joe.test.js:71:20)
    at Timer.ontimeout (timers.js:94:19)
```

### Writing your own reporter
It is really easy to write your own reporter. Just follow [`src/lib/reporters/console.coffee`](https://github.com/bevry/joe/blob/master/src/lib/reporters/console.coffee) as an example :)