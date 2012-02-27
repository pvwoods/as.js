package org.osflash.asjs.parser {
    
    import org.osflash.asjs.parser.JSRenderer;
    
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

        public function transmogrify(srcDirectory:String, className:String):String{
            
            var classNamePath:String = className.replace(/\./g, "/") + ".as";

            var structure:Object = _parser.parse(getFileContents(srcDirectory + classNamePath));
            var renderer:JSRenderer = new JSRenderer(structure);

            var s:String = renderer.renderAsString() + "\n";
            s += "new " + className + "();";

            return s;
        }

        public function getPegJsonString(srcDirectory:String, className:String):String{
            return JSON.stringify(_parser.parse(getFileContents(srcDirectory + className.replace(/\./g, "/") + ".as")));
        }
        
        protected function getFileContents(fileName:String):String{
            return FS.readFileSync(fileName).toString();
        }

    }

}
