#!/usr/bin/env node

var AS = require('./js/as').AS;

if(process.argv[2] === "-c"){
    console.log(AS.build(__dirname + "/" + process.argv[3], process.argv[4], false, true));
}else{
    AS.build(__dirname + "/" + process.argv[2], process.argv[3]);
}

