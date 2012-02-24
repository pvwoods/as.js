package org.osflash.asjs.parser {
    
    public class ASParser {

        protected var PEG:PegJS = require("pegjs");
        protected var FS:fs = require("fs");
        protected var _parser:PegParser;

        public function ASParser(pegFile:String):void{
            
            var contents:String = getFileContents(pegFile);
            _parser = PEG.buildParser(contents);

        }

        public function evaluate(s:String):void{
            return _parser.parse(s); 
        }

        public function transmogrify(fileName:String):String{
            return JSON.stringify(_parser.parse(getFileContents(fileName)));
        }
        
        protected function getFileContents(fileName:String):String{
            return FS.readFileSync(fileName).toString();
        }

    }

}
