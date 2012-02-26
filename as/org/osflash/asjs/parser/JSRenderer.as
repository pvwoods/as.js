package org.osflash.asjs.parser {
    
    import org.osflash.asjs.parser.objects.ASPackageStructure;

    public class JSRenderer {
        
        protected var _result:String;
        protected var _structure:ASPackageStructure;

        public function JSRenderer(structure:Object):void{
            
            _result = translateObjectToJS(structure);
            _structure = new ASPackageStructure();
            
        } 

        /**
         * Peg Element Types
         **/

        protected function PEG_Program(a:Array):String{
            
            if(a == null) return "";

            var s:String = "";
            
            for(var i:int = 0; i < a.length; i++){
                switch(a[i].type){
                    case "PackageStatement":
                        s += this[getPegFunctionName(a[i].type)](a[i]);
                        break;
                    case "ImportStatement":
                        s += "";
                        break;
                    case "Block":
                        s+= PEG_PackageBlock(a[i]);
                        break;
                }
            }
            
            return s;

        }
        
        // the package block is rendered without {}
        protected function PEG_PackageBlock(o:Object):String{

            var elems:Array = o.statements;
            
            if(elems == null) return "";

            var s:String = "";
            
            for(var i:int = 0; i < elems.length; i++) s += this[getPegFunctionName(elems[i].type)](elems[i]);
            
            return s;

        }

        protected function PEG_Block(o:Object):String{

            var elems:Array = o.statements;
            
            if(elems == null) return "";

            var s:String = "";
            
            for(var i:int = 0; i < elems.length; i++) s += this[getPegFunctionName(elems[i].type)](elems[i]);
            
            return "{" + s + "}";

        }

        protected function PEG_PackageStatement(o:Object):String{
            if(o.name == "") return "var ";
            _structure.addToPackageStructure(o.name);
            return o.name + ".";
        }

        protected function PEG_ClassStatement(o:Object):String{
            return o.name + " = ";
        }

        protected function PEG_Function(o:Object):String{

            var s:String = o.name + ": function(";
            
            //handle params
            
            s += "){"
            
            //handle anything within the function
            if(o.elements != null){
                for(var i:int = 0; i < o.elements.length; i++) s += this[getPegFunctionName(o.elements[i].type)](o.elements[i]);
            }

            return s + "}";
        }

        protected function PEG_FunctionCall(o:Object):String{

            var s:String = o.name.name + "(";
            if(o.arguments != null){
                if(o.arguments.length > 1){
                    for(var i:int = 0; i < o.arguments.length - 1; i++) s += this[getPegFunctionName(o.arguments[i].type)](o.elements[i]) + ", ";
                }
                s += this[getPegFunctionName(o.arguments[o.arguments.length - 1].type)](o.arguments[o.arguments.length - 1]);
            }
            return s + ");";
        }

        protected function PEG_StringLiteral(o:Object):void{
            return "\"" + o.value + "\"";
        }

        /**
         * Helper functions
         **/

        protected function getPegFunctionName(n:String):String {
            return "PEG_" + n;
        }
        
        protected function translateObjectToJS(o:Object):String{ 
            return this[getPegFunctionName(o.type)](o.elements);
        }
        
        public function renderAsString():String{
            return _structure.toJsonString() + "\n" + _result;
        }

    }

}

