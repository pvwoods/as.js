package org.osflash.asjs.parser {
    
    import org.osflash.asjs.parser.JSRenderer;
    import org.osflash.asjs.parser.objects.ASPackageStructure;
    
    public class ASParser {

        protected var PEG:PegJS = require("pegjs");
        protected var FS:fs = require("fs");
        protected var _parser:PegParser;
        
        public var renderer:JSRenderer;

        public function ASParser(pegFile:String):void{
            
            // hack until parser pre-compiling is implemented
            if(ASPackageRepo.___PEG____PARSER == undefined){
                var contents:String = getFileContents(pegFile);
                ASPackageRepo.___PEG____PARSER = PEG.buildParser(contents);
                ASPackageRepo.__PACK_STRUCTURE__ =  new ASPackageStructure();
            }

            _parser = ASPackageRepo.___PEG____PARSER;

        }

        public function evaluate(s:String):void{
            return _parser.parse(s); 
        }

        public function transmogrify(srcDirectory:String, className:String, isMain:boolean = false):String{
            
            var classNamePath:String = className.replace(/\./g, "/") + ".as";

            var structure:Object = _parser.parse(getFileContents(srcDirectory + classNamePath));
            //trace(JSON.stringify(structure));
            renderer = new JSRenderer(structure);

            var s:String = "";
            if(isMain) s += ASPackageRepo.__PACK_STRUCTURE__.toJsonString() + "\n";
            s += renderer.renderAsString() + "\n";
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
