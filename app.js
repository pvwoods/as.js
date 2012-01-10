#!/usr/bin/env node

var AS = require('./js/as').AS;

if(process.argv[2] === "-c"){
    console.log(AS.build(process.cwd() + "/" + process.argv[3], process.argv[4], false, true));
}else{
    AS.build(process.cwd() + "/" + process.argv[2], process.argv[3]);
}

