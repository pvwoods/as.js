package org.osflash.asjs.parser {
    
    import org.osflash.asjs.parser.objects.ASPackageStructure;

    public class JSRenderer {
        
        protected var _result:String;
        protected var _structure:ASPackageStructure;
        protected var _b64:b64 = require('b64');

        protected var _classScopedVariables:Array = []; // any variable that is declared at the class level

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
            // hack for the finicky nature of the 0.1 compiler with Strings
            return s + _b64.decode("fTs=");

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
            // hack for the finicky nature of the 0.1 compiler with Strings
            return o.name + " " + _b64.decode("PSBmdW5jdGlvbigpIHsgcmV0dXJuIA==");
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

            var s:String = this[getPegFunctionName(o.name.type)](o.name) + "(";
            if(o.arguments != null){
                if(o.arguments.length > 1){
                    for(var i:int = 0; i < o.arguments.length - 1; i++) s += this[getPegFunctionName(o.arguments[i].type)](o.elements[i]) + ", ";
                }
                s += this[getPegFunctionName(o.arguments[o.arguments.length - 1].type)](o.arguments[o.arguments.length - 1]);
            }
            return s + ")" + ((o.eold != undefined && o.eold == true) ? ";":"");
        }

        protected function PEG_PropertyAccess(o:Object):String{
            return this[getPegFunctionName(o.base.type)](o.base) + "." + o.name;
        }

        protected function PEG_ClassVariableStatement(o:Object):String{
            var s:String = "";
            if(o.declarations != undefined && o.declarations != null){
                for(var n:String in o.declarations){
                    _classScopedVariables.push(o.declarations[n].name);
                    s += this[getPegFunctionName(o.declarations[n].type)](o.declarations[n]);
                }
                s = s.replace(/#endDelim#/g, ",");
                s = s.replace(/#eqDelim#/g, ":");
            }
            return s;
        }
        
        protected function PEG_VariableStatement(o:Object):String{
            var s:String = "var ";
            for(var n:String in o.declarations) s += this[getPegFunctionName(o.declarations[n].type)](o.declarations[n]);
            s = s.replace(/#endDelim#/g, ",");
            s = s.substring(0, s.length-1) + (hasMethodModifier ? ",":";");
            s = s.replace(/#eqDelim#/g, (hasMethodModifier ? ":":"="));
            return s;
        }

        protected function PEG_VariableDeclaration(o:Object):String{
            return o.name + (o.value == null ? "#eqDelim#null":"#eqDelim#" + this[getPegFunctionName(o.value.type)](o.value)) + "#endDelim#";
        }

        protected function PEG_Variable(o:Object):String{
            // hack for finicky compiler
            return ((_classScopedVariables.indexOf(o.name) >= 0) ? _b64.decode("dGhpcy4="):"") + o.name;
        }

        protected function PEG_NumericLiteral(o:Object):String{
            return o.value;
        }

        protected function PEG_BooleanLiteral(o:Object):String{
            return o.value;
        }

        protected function PEG_StringLiteral(o:Object):String{
            return "\"" + o.value + "\"";
        }

        protected function PEG_ArrayLiteral(o:Object):String{
            var s:String = "[";
            for(var n:String in o.elements) s += this[getPegFunctionName(o.elements[n].type)](o.elements[n]) + ",";
            return s.substring(0, s.length-1) + "]";
        }

        protected function PEG_AssignmentExpression(o:Object):String{
            return this[getPegFunctionName(o.left.type)](o.left) + o.operator + this[getPegFunctionName(o.right.type)](o.right) + ";";
        }

        protected function PEG_BinaryExpression(o:Object):String{
            return this[getPegFunctionName(o.left.type)](o.left) + o.operator + this[getPegFunctionName(o.right.type)](o.right);
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

