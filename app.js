var AS = require('./js/as').AS;
var fs = require('fs');

var fileContents = (fs.readFileSync(process.argv[2])).toString();

//var js = AS.transmogrify(fileContents);
//console.log(js);
AS.build(fileContents, '', 'Primitives');
