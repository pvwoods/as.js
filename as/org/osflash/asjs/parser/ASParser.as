package org.osflash.asjs.parser {
    
    import org.osflash.asjs.parser.JSRenderer;
    import org.osflash.asjs.parser.objects.ASPackageStructure;
    
    public class ASParser {

        public static var CLASSES_SEEN:Array = [];
        public static var PACKAGE_STRUCTURE:ASPackageStructure;
        public static var ROOT_SRC_DIR:String = "";

        protected var PEG:PegJS = require("pegjs");
        protected var FS:fs = require("fs");
        protected var _parser:PegParser;
        
        public var renderer:JSRenderer;

        public function ASParser(pegFile:String):void{
            
            // fall back for when there is no pre-compiled PegParser
            if(___PEG____PARSER == null){
                var contents:String = getFileContents(pegFile);
                ___PEG____PARSER = PEG.buildParser(contents); 
            }

            _parser = ___PEG____PARSER;

        }

        public function evaluate(s:String):void{
            return _parser.parse(s); 
        }

        public function transmogrify(srcDirectory:String, className:String, isMain:boolean = false):String{
            
            var classNamePath:String = className.replace(/\./g, "/") + ".as";

            // circular imports check
            if(isMain){
                ASParser.CLASSES_SEEN = {};
                ASParser.CLASSES_SEEN[className] = true;
                ASParser.PACKAGE_STRUCTURE =  new ASPackageStructure();
            }

            var structure:Object = _parser.parse(getFileContents(srcDirectory + classNamePath));
            //trace(JSON.stringify(structure));
            renderer = new JSRenderer(structure);

            var s:String = "";
            if(isMain) s += ASParser.PACKAGE_STRUCTURE.toJsonString();
            s += renderer.renderAsString();
            if(isMain) s += "new " + className + "();";

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
