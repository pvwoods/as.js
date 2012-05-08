#AS in your JS

## Running v0.0.5 compiler

    git clone https://github.com/pvwoods/as.js
    npm install -g

or

    git clone https://github.com/pvwoods/as.js
    ./scripts/compile
    node cli.js --help

( you will need to install node-beautifier ) [https://github.com/rickeyski/node-beautifier]

to make a deployment build (pre-compiles the peg parser)

    scripts/buildDeploy


##Road Map

###COMPLETE
    0.0.5 : fix a number of hacks present in the 0.0.4 compiler (base64 encoding, lack of use of statics and consts, general structural bits)
    0.0.4 : get the 0.0.3 compiler to compile itself
    0.0.3 : get the 0.0.2 compiler to parse itself
    0.0.2 compiler passes all 0.0.1 test files

###TO-DO

    0.0.6 : to be determined... though I imagine we could use some serious unit tests up in this joint


##Running list of caveats

* No Support for getters and setters
* No Support for interafaces
* No Support for wild card imports
* Argument splats are not supported
* Consts are actually vars
* access modifiers are currently not enforcable
* Static modifier only works for variables

There are certainly a multitude more
