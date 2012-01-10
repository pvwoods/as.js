package org.osflash.asjs {
    
    import flash.utils.Dictionary;

    public class CLI {

        private var _commands:Dictionary = new Dictionary();

        public function CLI() {

            
            _commands["-h"] = printHelp;
            _commands["--help"] = printHelp;
            _commands["--credits"] = printCredits;
            _commands["-t"] = transmogrify;
            _commands["--transmogrify"] = transmogrify;
            
            // handle the args
            for(var i:int = 0; i < process.argv.length; i++){
                if(_commands[process.argv[i]] !== undefined) _commands[process.argv[i]]();
            }

        }

        public function printCredits():void{

            trace('\n      ___  _____     ___ _____ ');
            trace('     / _ \\/  ___|   |_  /  ___|');
            trace('    / /_\\ \\ `--.      | \\ `--. ');
            trace('    |  _  |`--. \\     | |`--. \\');
            trace('    | | | /\\__/ /_/\\__/ /\\__/ /');
            trace('    \\_| |_|____/(_)____/\____/ ');
            trace('ActionScript 3 to JavaScript Compiler\n');

        }

        public function printHelp():void{

            trace("\nUsage -> asjs [<args>]");
            trace("\nAvailable Commands:");
            trace("\t-t --transmogrify\ttransform AS3 to JS and print");
            trace("\t-h --help\t\tShow AS.JS help");
            trace("\t--credits\t\tShow AS.JS credits");


        }

        public function transmogrify(file:String):void{

            

        }

    }

}
