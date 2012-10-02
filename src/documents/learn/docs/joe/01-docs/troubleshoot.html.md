## Errors

### An invalid amount of arguments were specified for a Joe Suite

Suites in Joe only accept 0, 2 and 3 arguments, e.g:

- 0 arguments, example: `suite 'name', ->`
- 2 arguments, example: `suite 'name', (suite,test) ->`
- 3 arguments, example: `suite 'name', (suite,test,complete) ->`

This is to ensure a suite is never confused with a test, which could cause a whole bunch of problems if this measure was not in place.

Resolving this error involves checking your logic to ensure that you actually want to use a suite:
- if you do want to use a suite, then update the specified arguments to a combination mentioned above
- if you don't want to use a suite, then you may want to use a test instead


### An invalid amount of arguments were specified for a Joe Test

Tests in Joe only accept 0 or 1 arguments, e.g:

- 0 arguments, example: `test 'name', ->`
- 1 argument, example: `test 'name', (complete) ->`

This is to ensure a test is never confused with a suite, which could cause a whole bunch of problems if this measure was not in place.

Resolving this error involves checking your logic to ensure that you actually want to use a test:
- if you do want to use a test, then update the specified arguments to a combination mentioned above
- if you don't want to use a test, then you may want to use a suite instead