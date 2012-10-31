// File Reader Class
var FileReader = function(){};

// Read Files Asynchronously
FileReader.prototype.readFiles = function(files,next){
	var i, results = [], result, file, completed = 0;
	for ( i=0; i<files.length; ++i ) {
		file = files[i];
		require('fs').readFile(file,function(err,result){
			// Check
			if ( err ) {
				i = files.length;
				completed = files.length;
				return next(err);
			}
			// Apply
			results.push(result.toString());
			// Check
			completed++;
			if ( completed === files.length ){
				return next(null,results);
			}
		});
	}
	return this;
};

// Read Files Synchronously
FileReader.prototype.readFilesSync = function(files){
	var i, results = [], result, file;
	for ( i=0; i<files.length; ++i ) {
		file = files[i];
		result = require('fs').readFileSync(file);
		// Check
		if ( result instanceof Error ) {
			return result;
		}
		// Apply
		results.push(result.toString());
	}
	return results;
};

// Read our files
var fileReader = new FileReader();
var files = ['difference-node.js','difference-php.php'];

// Async
fileReader.readFiles(files,function(err,results){
	if (err)  throw err;
	console.log('async:', results);
});

// Sync
var results = fileReader.readFilesSync(files);
console.log('sync:', results);