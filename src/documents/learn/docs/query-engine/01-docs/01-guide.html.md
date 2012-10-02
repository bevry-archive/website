---
title: "Using Query Engine"
---

This wiki page will go into detail about the usage of the QueryEngine API.

## Introduction
QueryEngine is incredibly powerful, and pretty easy to use once you understand the key concepts behind it which we'll detail here. Firstly, there is the `QueryCollection` class which extends the Backbone Collection functionality with our special sauce. QueryCollections can be in one of two states, standard or live. QueryEngine also provides a few different ways of _querying_ our collections to discover the models that pass our selection _criteria_. QueryEngine supports the following types of selection criteria: Queries, Filters, Pills and SearchStrings all serving their own purpose.

### Collection Types
**Standard collections** behave very traditionally, in the sense that you have a collection that contains all your models, and you want to check every single one of them against a particular criteria, and return the models which passed the criteria. While being the most straightforward, it is also vastly inefficient, as every single time we query, we have to scan all the models all over again. It also has the problem that if one of our passed models changes, and no longer matches our criteria, we wouldn't care. These down-sides make it very hard to code real-time auto-updating dynamic applications.

**Live collections** step in where standard collections fall short. Live collections listen to the [Collections Events](http://documentcloud.github.com/backbone/#Collection "Collection Events are provided by Backbone") to automatically check that the added, changed or removed model matches our criteria, if it does, then it will add or keep it, if it doesn't it will remove it. This is magical and highly efficient, as it means that our Live collections are always up to date with the correct models, and adding and removing models happens automatically in the most efficient way possible. Instead of querying our entire collection's models every time we want results, it only performs the queries for each model once, and then again when an event fires.

### Collection Hierarchy
**Standard collections** do not having any collection hierarchy, and all models inside the standard collection are their own. If they are a live collection, then they only subscribe to their own events.

**Child and Parent collections** are useful when it comes to notion of sub-collections. For instance, if in our navigation we have the following filters "My Tasks", and then "My Backlogged Tasks". The most efficient and amazing way to code this would be to have the following:

- a global task collection that contains all the tasks, with no selection criteria
- a my tasks live collection, which uses the global task collection as a parent, and applies the selection criteria `userId: myUserId` to it
- a my backlogged tasks live collection, which uses the my tasks collection as a parent, and applies the selection criteria `status: 'backlogged'` to it

So, now say if we create a new backlogged task, we would simply add it to the global task collection, and then our my tasks live collection would automatically detect the addition to the global task collection, and check if the model passes our criteria, if it does, then it will add it to its collection. If added, our my backlogged tasks live collection would then automatically pick up the add event on its parent, and check if the model passes it's criteria, and if so add it to its own collection. If the event is a change, the same process occurs and will also remove if it no longer supports the criteria. If the event is a remove, it is removed from all collections.

This is quite amazing, as with minimal effort we have coded a waterfall of incredibly efficient data hierarchy which always stays in sync automatically. Amazing.

### Selection Criteria
There are the four concepts that make up our selection criteria.

#### Query
The Query criteria provides us with NoSQL like querying. For instance allows us to do `url: $startsWith: '/blog'` to find all the models which URL starts with '/blog'. It more or less follows the MongoDB query spec, but with a improvements.

#### Filter
A Filter is a custom function that we apply to our collection. When a query is performed, our filter will be passed the `model`, and `cleanedSearchString` as its arguments. It will then return whether or not the model passed or failed by returning `true` or `false` respectively.

#### Pills
Pills allow us to specify search criteria when using strings. They come in the format of `"#{prefix}#{value}"`, and can have many supported prefixes. For instance you could do `['user:','@']` to match against both `"user:ben"` and `"@ben"`, where "ben" would be extracted as the value, and passed to our pill's callback function. In this instance, the callback function would probably look like this: `callback: (model,value) -> return model.getUser().get('name') is value`

#### Search String
A Search String is type of selection criteria defined by a search box on your webpage. It takes in a string, which is then used by our Filters and Pills. For example, we could have the search string `chocolate type:black`. Indicates that we are searching for the text "chocolate" and applying the criteria of type is black. The text "chocolate" is then sent to our filters as the `cleanedSearchString` argument. Note: "type:black" would only be extracted from the search string, if there is a pill looking for that. If no pill is looking for that, then it will not be extracted.


## QueryEngine API
These are the methods which are exposed to you via `window.QueryEngine` for client-side, and `require('query-engine')` for server-side.

### QueryEngine.QueryCollection
QueryCollection is a [Backbone Collection](http://documentcloud.github.com/backbone/#Collection) with extra functionality to provide the goodness of QueryEngine. You can create a new QueryCollection instance via `queryEngineInstance = new QueryEngine.QueryCollection(models,options)`. And extend the QueryCollection by doing `class MyQueryCollection extends QueryEngine.QueryCollection` with CoffeeScript, or `var MyQueryCollection = QueryEngine.QueryCollection.extend({})` with JavaScript.

### QueryEngine.createCollection([models], [options])
Alternatively, we also provide a method to create our QueryCollections for us. You can use it via `queryEngineInstance = new QueryEngine.createCollection(models,options)`. The arguments for this function are the same as those specified on the [Backbone Collection Constructor](http://documentcloud.github.com/backbone/#Collection-constructor) documentation.
Returns: QueryCollection instance

### QueryEngine.createLiveCollection([models], [options])
createLiveCollection is the same as createCollection, however will turn on the live collection abilities.
Returns: QueryCollection instance

### QueryEngine.createRegex(str)
Returns a regular expression from the passed string.

### QueryEngine.createSafeRegex(str)
Returns a santised regular expression from the passed string.

### QueryEngine.toArray(value)
Converts value to an array if it isn't one already.

### QueryEngine.generateComparator(comparator)
Supports [MongoDB Sort Comparators](http://www.mongodb.org/display/DOCS/Advanced+Queries#AdvancedQueries-%7B%7Bsort%28%29%7D%7D) as well as standard functions that take in `a` and `b` as their arguments, returning either `-1`, `0`, or `1`. Returns the generated comparator function. Will throw an error if passed invalid input.


## QueryCollection API
These are the methods which are exposed to you via our Query Collections.

### constructor([models],[options])
The QueryCollection accepts two arguments; `models` and `options` which are both optional. Models can be an array, or an object in the format of `{modelId:{key1:value1,key2:value2}}`. Options are an object, with support for the following options:

- filters: a javascript object of the filters to apply, in the format of `{filterName: filterFunction}`, passed to `setfilters`
- queries: a javascript object of the queries to apply, in the format of `{queryName: queryObject}` or `{queryName: queryClassInstance}`, passed to `setQueries`
- pills: a javascript object of the pills to apply, in the format of `{pillName: pillObject}` or `{pillName: pillClassInstance}`, passed to `setPills`
- searchString: a string to use as the search string for our collection, passed to `setSearchString`
- parentCollection: a parent collection to subscribe to, must at least be a Backbone Collection
- live: a boolean value of whether or not to enable live support for our collection

### Querying
#### queryCollection.query()
Re-run the query criteria on all our models. Useful for querying already added models on live collections, or for performing queries on non live collections. Returns chain.

#### queryCollection.findAll(queryObject or queryClassInstance, [comparator])
Creates a non live child collection, performs the query on it, sets the optional comparator if we have it, and returns it.

#### queryCollection.findAllLive(queryObject or queryClassInstance, [comparator])
Creates a live child collection, performs the query on it, sets the optional comparator if we have it, and returns it.

#### queryCollection.findOne(queryObject or queryClassInstance, [comparator])
Creates a non live child collection, performs the query on it, using the optional comparator if we have it, and returns the first result or null.

#### queryCollection.live(enable)
Turns the current collection into a live collection (if enable is true) or into a non live collection (if enable is false).


### Sorting
#### queryCollection.setComparator(comparator)
Applies the [comparator](http://documentcloud.github.com/backbone/#Collection-comparator) to the collection. Comparator will be parsed through `queryEngine.generateComparator`. Will re-sort on additions. If live, will also resort on changes. Returns chain.

#### queryCollection.sortArray([comparator])
Sorts an array of the collection by the [comparator](http://documentcloud.github.com/backbone/#Collection-comparator). Comparator will be parsed through `queryEngine.generateComparator`. If no comparator was given, we will use the collection's [comparator](http://documentcloud.github.com/backbone/#Collection-comparator) if it exists, otherwise we'll throw an error. Returns the array.

#### queryCollection.sortCollection([comparator])
Sorts the collection by the [comparator](http://documentcloud.github.com/backbone/#Collection-comparator). Comparator will be parsed through `queryEngine.generateComparator`.  If no comparator was given, we will use the collection's [comparator](http://documentcloud.github.com/backbone/#Collection-comparator) if it exists, otherwise we'll throw an error. Returns chain.


### Collection Hierarchy
#### queryCollection.setParentCollection(parentCollection)
Sets our collection to be a subset of a parent collection. Once set, querying will be performed on the parent collection's models, with the passed models kept in our collection and failed removed - without modifying the parent collection. If our collection is a live collection (e.g. `.live(true)`) then any events triggered on the parent collection will also be triggered on the child collection - because of this, it is important to note that if a model no longer passes a parent collection's criteria, then it will be removed from the child collection - as expected.

#### queryCollection.getParentCollection()
Returns our collection's parent collection if we have one.

#### queryCollection.hasParentCollection()
Returns a boolean indicating if our collection has a parent collection.

#### queryCollection.createChildCollection()
Create a child collection from this collection, and set us as the parent collection.

#### queryCollection.createLiveChildCollection()
Creates a live child collection from this collection, and sets us as the parent collection.


### Models
#### queryCollection.add(model)
Extends the inherited [backbone collection add method](http://documentcloud.github.com/backbone/#Collection-add)  by checking that the model passes our selection criteria first. If it does, then the add is proceeded with, if not, then the add is cancelled. Returns chain.

#### queryCollection.create(model)
Extends the inherited [backbone collection create method](http://documentcloud.github.com/backbone/#Collection-create)  by checking that the model passes our criteria first. If it does, then the create is proceeded with, if not, then the create is cancelled. Returns chain.

#### queryCollection.hasModel(model)
Checks to see if the model exists within our collection. Returns boolean.

#### queryCollection.test(model)
Will test the model against our collections criteria. Returns boolean.

#### queryCollection.testFilters(model)
Will test the model against our collections filter criteria. Returns boolean.

#### queryCollection.testQueries(model)
Will test the model against our collections query criteria. Returns boolean.

#### queryCollection.testPills(model)
Will test the model against our collections pill criteria. Returns boolean.



### Criteria: Queries
#### queryCollection.setQuery(queryName, queryObject or queryClassInstance)
Applies a query indentified by the queryName to the current collection.
#### queryCollection.setQueries(queries)
#### queryCollection.getQuery(queryName)
#### queryCollection.getQueries()


### Criteria: Filters
#### queryCollection.setFilter(filterName, filterFunction)
Applies a filter indentified by the filterName for the current collection. A filter is just a standard function which takes in two arguments `model` and `cleanedSearchString`. Returns chain.

#### queryCollection.setFilters(filters)
Sets the filters for the current collection. Filters are an object indexed by the filter names, and valued by the filter functions. Returns chain.

#### queryCollection.getFilter(filterName)
Returns the filter function for the specified filterName, otherwise returns undefined.

#### queryCollection.getFilters()
Returns an object containing all the filters, indexed by the filter names, and valued by the filter functions.


### Criteria: Pills
#### queryCollection.setPill(pillName, pillObject or pillClassInstance)
#### queryCollection.setPills(pills)
#### queryCollection.getPill(pillName)
#### queryCollection.getPills()


### Criteria: Search String
#### queryCollection.setSearchString(searchString)
#### queryCollection.getCleanedSearchString()
#### queryCollection.getSearchString()


## Query API

### Comparisons
To find all the models, that have the attribute `name` set to `awesome`, we would have the following query: `firstname: 'Benjamin'`. Using the QueryCollection's `findAll` method, it would like like this `queryCollection.findAll(firstname: 'Benjamin')` if you are using CoffeeScript, or `queryCollection.findAll({firstname: 'Benjamin'})` if you are using JavaScript.

You can use this method of comparison, to ensure any attribute is equal to a certain value. You can also check if multiple attributes equal certain values, by having a query like so: `firstname: 'Benjamin', lastname: 'Lupton'` in CoffeeScript, or `{firstname: 'Benjamin', lastname: 'Lupton'}` in JavaScript.

### Grouping Queries
You can group multiple queries together by using the special `$and` and `$or` keys. For instance, to find anyone with the firstname equal to Benjamin, OR the username equal to balupton. Then we would do up a query like: `$or: {firstname: 'Benjamin', username: 'balupton'}`. Generally we never have to use the `$and`, as our queries are by default and type queries, however it is available to you if you need it.

### Regular Expressions
If we use a regular expression as a value in a query, then Query Engine will test the attribute's value against our selector's  value (the regular expression). For instance, to find everyone who's firstname starts with the letter B, we could use the query: `firstname: /^[Bb]/`

### Advanced Operations on Queries
We can also support advanced operations on queries by passing an object as the selector's value. Here is what is available to us in that department.

#### $beginsWith (aka $startsWith)
You can use $beginsWith to find out if the atribute's value, starts with our selector's value. For instance, to get all the people who's firstname starts with the letter B, we would use the query: `firstname: $startsWith: ['B','b']`, or to just get names that start with a capital B, we can just use `firstname: $startsWith: 'B'`

#### $endsWith (aka $finishesWith)
You can use $endsWith to find out if the atribute's value, ends with our selector's value. For instance, to get all the people who's firstname ends with the letter N, we would use the query: `firstname: $endsWith: ['N','n']`, or to just get names that end with a lowercase N, we can just use `firstname: $endsWith: 'n'`

#### $all
The `$all` operator is similar to `$in`, but instead of matching any value in the specified array all values in the array must be matched

#### $in
The `$in` operator is analogous to the SQL IN modifier, allowing you to specify an array of possible matches. The target field's value can also be an array; if so then the document matches if any of the elements of the array's value matches any of the $in field's values

#### $has
The `$has` operator checks if any of the selector values exist within our model's value

#### $hasAll
The `$hasAll` operator checks if all of the selector values exist within our model's value

#### $nin
The `$nin` operator is similar to $in except that it selects objects for which the specified field does not have any value in the specified array.

#### $size (aka $length)
The `$size` operator matches any array with the specified number of elements. The following example would match the object `{a:["foo"]}`, since that array has just one element.

#### $type
The `$type` operator matches values based on their BSON type, e.g. `typeof value`

#### $exists
Check for existence (or lack thereof) of a field. Use `someField: $exists: true` to check if `someField` exists, and `someField: $exists: false` to check if it doesn't.

#### $ne
Use `$ne` for "not equals"

#### $lt
Less than

#### $lte
Less than or equal

#### $gt
Grater than

#### $gte
Grater than or equal


## Pill API

A pill takes in an object with the following structure: `prefixes: ['@','username:'], callback: (value) -> this.get('username') is value`


## Tying it all together

Here are a few examples that tie all of this together. [Be sure to check out the live interactive demo to see these examples in action.](http://bevry.github.com/query-engine/demo/)

### Find all the models that have the tag "backbone"

``` coffeescript
result = queryEngine.createCollection(models)
	.findAll(tags: $has: ['backbone'])
```

### Ensure the collection only ever includes models that have the tag "backbone"

``` coffeescript
result = queryEngine.createLiveCollection()
	.setQuery(tags: $has: ['backbone'])
	.add(models)
```

### Create a live child collection for a particular search string

``` coffeescript
parentCollection = queryEngine.createCollection(models)
searchResultsCollection = parentCollection.createLiveChildCollection()
	.setFilter('search', (model,searchString) ->
		searchRegex = queryEngine.createSafeRegex(searchString)
		pass = searchRegex.test(model.get('title')) or searchRegex.test(model.get('content'))
		return pass
	)
	.setSearchString('my text search query')
```

### Create a live child collection for a particular search string including pills

``` coffeescript
parentCollection = queryEngine.createCollection(models)
searchResultsCollection = parentCollection.createLiveChildCollection()
	.setPill('user', {
		prefixes: ['user:','username:','@']
		callback: (model,value) ->
			pillRegex = queryEngine.createSafeRegex(value)
			pass = pillRegex.test(model.get('username'))
			return pass
	})
	.setSearchString('user:balupton')  # also works with '@balupton'
```