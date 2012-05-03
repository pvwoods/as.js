package org.osflash.asjs {
    
    import flash.utils.Dictionary;

    import org.osflash.asjs.ConfigData;
    import org.osflash.asjs.parser.ASParser;
    import org.osflash.asjs.parser.Prelude;

    public class CLI {

        private var _commands:Dictionary;
        private var _fs:fs = require('fs');

        public function CLI() {

            _commands = new Dictionary();
            
            _commands["-h"] = printHelp;
            _commands["--help"] = printHelp;
            _commands["--credits"] = printCredits;
            _commands["-v"] = printVersion;
            _commands["--version"] = printVersion;
            _commands["-t"] = transmogrify;
            _commands["--transmogrify"] = transmogrify;
            _commands["-e"] = evaluate;
            _commands["--evaluate"] = evaluate;
             _commands["-p"] = printPeg;
            _commands["--peg"] = printPeg;



            
            // handle the args
            if(process.argv.length == 2){
                runREPL();
            }else{
                for(var i:int = 0; i < process.argv.length; i++){
                    if(_commands[process.argv[i]] !== undefined){
                        _commands[process.argv[i]].apply(this, [i, process.argv]);
                    }
                }
            }

        }

        public function printCredits(argIndex:uint, args:Array):void{
            
            trace('');
            trace("  .d8b.  .d8888.       d88b .d8888. ");
            trace(" d8' `8b 88'  YP       `8P' 88'  YP ");
            trace(" 88ooo88 `8bo.          88  `8bo.   ");
            trace(" 88~~~88   `Y8b.        88    `Y8b. ");
            trace(" 88   88 db   8D db db. 88  db   8D ");
            trace(" YP   YP `8888Y' VP Y8888P  `8888Y' ");
            trace('ActionScript 3 to JavaScript Compiler');
            trace('');

        }

        public function printHelp(argIndex:uint, args:Array):void{

            trace('');
            trace("Usage -> asjs [<args>]");
            trace('');
            trace("Available Commands:");
            trace("\t-t --transmogrify\t<sourceDirectory> <MainClass>\ttransform AS3 to JS and print");
            trace("\t-e --evaluate\t\t<sourceDirectory> <MainClass>\tevaluate AS3 file");
            trace("\t-p --peg\t\t<sourceDirectory> <MainClass>\tdumps the peg JSON");
            trace("\t-h --help\t\t\t\t\t\tShow AS.JS help");
            trace("\t-v --version\t\t\t\t\t\tShow AS.JS version");
            trace("\t--credits\t\t\t\t\t\tShow AS.JS credits");


        }

        public function printVersion(argIndex:uint, args:Array):void{

            trace("v" + ConfigData.VERSION_NUMBER);

        }

        public function printPeg(argIndex:uint, args:Array):void{
            var parser:ASParser = new ASParser("./peg/as3.pegjs");
            trace(parser.getPegJsonString(args[argIndex + 1], args[argIndex + 2]));
        }

        public function transmogrify(argIndex:uint, args:Array):void{
            
            ASPackageRepo.ROOT_SRC_DIR = args[argIndex + 1];
            
            var parser:ASParser = new ASParser("./peg/as3.pegjs");
            var prelude:Prelude = new Prelude();
            trace(prelude.generatePrelude());
            trace(parser.transmogrify(args[argIndex + 1], args[argIndex + 2], true));

        }

        public function evaluate(argIndex:uint, args:Array):void{
            
            ASPackageRepo.ROOT_SRC_DIR = args[argIndex + 1];

            var parser:ASParser = new ASParser("./peg/as3.pegjs");
            var prelude:Prelude = new Prelude();
            eval(prelude.generatePrelude() + parser.transmogrify(args[argIndex + 1], args[argIndex + 2], true));
        }

        public function runREPL():void{
            trace('');
            trace("+ Starting AS.JS REPL +");
            trace('');
            var stdin = process.openStdin();
            process.stdout.write("> ");
            var parser:ASParser = new ASParser("./peg/as3.pegjs");
            stdin.on('data', function(chunk) {
                var s:String = chunk.toString();
                s = s.substring(0, s.length - 1);
                if(s == "exit()" || s == "exit" || s == "exit();" || s == "exit;") process.exit();
                console.log(parser.evaluate(s));
                trace('');
                process.stdout.write("> ");
            });
        }

    }

}
