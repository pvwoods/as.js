var AS = require('./js/as').AS;

//var js = AS.transmogrify(__dirname + "/" + process.argv[2]);
console.log("\n********************\n**     RUNNING    **\n********************\n");
AS.build(__dirname + "/" + process.argv[2], process.argv[3]);
console.log('\n');
