var AS = require('./js/as').AS;
var fs = require('fs');

var fileContents = (fs.readFileSync(process.argv[2])).toString();

console.log(AS.transmogrify(fileContents));
