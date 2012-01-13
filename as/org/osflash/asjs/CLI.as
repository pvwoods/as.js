package org.osflash.asjs {
    
    import flash.utils.Dictionary;

    import org.osflash.asjs.ConfigData;

    public class CLI {

        private var _configData:ConfigData = new ConfigData(); // In later versions, Config shouldn't need to be instantiated
        private var _commands:Dictionary = new Dictionary();

        public function CLI() {
            
            _commands["-h"] = printHelp;
            _commands["--help"] = printHelp;
            _commands["--credits"] = printCredits;
            _commands["-v"] = printVersion;
            _commands["--version"] = printVersion;
            _commands["-t"] = transmogrify;
            _commands["--transmogrify"] = transmogrify;
            
            // handle the args
            for(var i:int = 0; i < process.argv.length; i++){
                if(_commands[process.argv[i]] !== undefined){
                    //var o:Object = {"0": i, "1": process.argv};
                    _commands[process.argv[i]].apply(this, null);
                }
            }

        }

        public function printCredits(argIndex, args):void{

            trace('\n      ___  _____     ___ _____ ');
            trace('     / _ \\/  ___|   |_  /  ___|');
            trace('    / /_\\ \\ `--.      | \\ `--. ');
            trace('    |  _  |`--. \\     | |`--. \\');
            trace('    | | | /\\__/ /_/\\__/ /\\__/ /');
            trace('    \\_| |_|____/(_)____/\____/ ');
            trace('ActionScript 3 to JavaScript Compiler\n');

        }

        public function printHelp(argIndex, args):void{
            
            trace("\nUsage -> asjs [<args>]");
            trace("\nAvailable Commands:");
            trace("\t-t --transmogrify\ttransform AS3 to JS and print");
            trace("\t-h --help\t\tShow AS.JS help");
            trace("\t--credits\t\tShow AS.JS credits");


        }

        public function printVersion(argIndex, args):void{

            trace("v" + _configData.VERSION_NUMBER);

        }

        public function transmogrify(argIndex, args):void{

         //   

        }

        public function runREPL():void{
            //
        }

    }

}
