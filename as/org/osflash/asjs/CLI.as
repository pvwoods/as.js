package org.osflash.asjs {
    
    import flash.utils.Dictionary;

    import org.osflash.asjs.ConfigData;

    public class CLI {

        private var _configData:ConfigData = new ConfigData(); // In later versions, Config shouldn't need to be instantiated
        private var _commands:Dictionary = new Dictionary();
        private var _fs:fs = require('fs');

        public function CLI() {
            
            _commands["-h"] = printHelp;
            _commands["--help"] = printHelp;
            _commands["--credits"] = printCredits;
            _commands["-v"] = printVersion;
            _commands["--version"] = printVersion;
            _commands["-t"] = transmogrify;
            _commands["--transmogrify"] = transmogrify;
            
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

            trace('\n      ___  _____     ___ _____ ');
            trace('     / _ \\/  ___|   |_  /  ___|');
            trace('    / /_\\ \\ `--.      | \\ `--. ');
            trace('    |  _  |`--. \\     | |`--. \\');
            trace('    | | | /\\__/ /_/\\__/ /\\__/ /');
            trace('    \\_| |_|____/(_)____/\____/ ');
            trace('ActionScript 3 to JavaScript Compiler\n');

        }

        public function printHelp(argIndex:uint, args:Array):void{
            
            trace("\nUsage -> asjs [<args>]");
            trace("\nAvailable Commands:");
            trace("\t-t --transmogrify\ttransform AS3 to JS and print");
            trace("\t-h --help\t\tShow AS.JS help");
            trace("\t-v --version\t\tShow AS.JS version");
            trace("\t--credits\t\tShow AS.JS credits");


        }

        public function printVersion(argIndex:uint, args:Array):void{

            trace("v" + _configData.VERSION_NUMBER);

        }

        public function transmogrify(argIndex:uint, args:Array):void{


        }

        public function runREPL():void{
            trace("Starting AS.JS REPL\n");
        }

    }

}
