var AS = require('./js/as').AS;
var fs = require('fs');

var fileContents = (fs.readFileSync(process.argv[2])).toString();

var js = AS.transmogrify(fileContents);
console.log(js);
console.log("********************\n**     RUNNING    **\n********************");
var beginIndex = process.argv[2].lastIndexOf('/') + 1;
AS.build(fileContents, '', process.argv[2].substr(beginIndex, (process.argv[2].lastIndexOf('.') - beginIndex)));
