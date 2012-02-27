package org.osflash.asjs.parser {
    
    import org.osflash.asjs.parser.objects.ASPackageStructure;

    public class JSRenderer {

        protected var _BUILT_IN_FUNCTIONS:Array = ["trace"];
        
        protected var _result:String;
        protected var _structure:ASPackageStructure;
        protected var _b64:b64 = require('b64');

        protected var _classScopedVariables:Array = []; // any variable that is declared at the class level
        protected var _classScopedFunctions:Array = []; // any class functions

        public function JSRenderer(structure:Object):void{
            
            _result = translateObjectToJS(structure);
            _structure = new ASPackageStructure();
            
        } 

        /**
         * Peg Element Types
         **/

        protected function PEG_Program(a:Array, o:Object):String{
            
            if(a == null) return "";

            var s:String = "";
            
            for(var i:int = 0; i < a.length; i++){
                switch(a[i].type){
                    case "PackageStatement":
                        s += this[getPegFunctionName(a[i].type)](a[i], a);
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
        protected function PEG_PackageBlock(o:Object, p:Object):String{

            var elems:Array = o.statements;
            
            if(elems == null) return "";

            var s:String = "";
            
            for(var i:int = 0; i < elems.length; i++) s += this[getPegFunctionName(elems[i].type)](elems[i], o);
            // hack for the finicky nature of the 0.1 compiler with Strings '};'
            return s + "; if(ret[CLASS_NAME] !== undefined) ret[CLASS_NAME](arguments); return ret;" + _b64.decode("fTs=");

        }

        protected function PEG_Block(o:Object, p:Object):String{

            var elems:Array = o.statements;
            
            if(elems == null) return "";

            var s:String = "";
            
            for(var i:int = 0; i < elems.length; i++) s += this[getPegFunctionName(elems[i].type)](elems[i], o);
            
            return "{" + s + "}";

        }

        protected function PEG_PackageStatement(o:Object, p:Object):String{
            if(o.name == "") return "var ";
            _structure.addToPackageStructure(o.name);
            return o.name + ".";
        }

        protected function PEG_ClassStatement(o:Object, p:Object):String{
            // hack for the finicky nature of the 0.1 compiler with Strings '= function(){'
            var s:String = o.name + " " + _b64.decode("PSBmdW5jdGlvbigpeyA=");
            s += "var CLASS_NAME = '" + o.name + "'; var ret = ";
            return s;
        }

        protected function PEG_Function(o:Object, p:Object):String{

            var s:String = o.name + ": function(";

            _classScopedFunctions.push(o.name);
            
            s += o.params.join(", ");
            
            s += "){"
            
            //handle anything within the function
            if(o.elements != null){
                for(var i:int = 0; i < o.elements.length; i++) s += this[getPegFunctionName(o.elements[i].type)](o.elements[i], o);
            }

            return s + "},";
        }

        protected function PEG_FunctionCall(o:Object, p:Object):String{

            var s:String = this[getPegFunctionName(o.name.type)](o.name, o);
            s += "(";
            if(o.arguments != null){
                
                if(o.arguments.length > 1){
                    for(var i:int = 0; i < o.arguments.length - 1; i++) s += this[getPegFunctionName(o.arguments[i].type)](o.arguments[i], o) + ", ";
                }
                if(o.arguments.length > 0) s += this[getPegFunctionName(o.arguments[o.arguments.length - 1].type)](o.arguments[o.arguments.length - 1], o);
            }
            return s + ")" + ((o.eold != undefined && o.eold == true) ? ";":"");
        }

        protected function PEG_ReturnStatement(o:Object, p:Object):String{
           return "return " +   this[getPegFunctionName(o.value.type)](o.value, o) + ";";
        }

        protected function PEG_PropertyAccess(o:Object, p:Object):String{
            return this[getPegFunctionName(o.base.type)](o.base, o) + "." + o.name;
        }

        protected function PEG_ClassVariableStatement(o:Object, p:Object):String{
            var s:String = "";
            if(o.declarations != undefined && o.declarations != null){
                for(var n:String in o.declarations){
                    s += this[getPegFunctionName(o.declarations[n].type)](o.declarations[n], o);
                }
                s = s.replace(/#endDelim#/g, ",");
                s = s.replace(/#eqDelim#/g, ":");
                // remove extraneous ; if added (sometimes added by functions) (find a better way to handle this during 0.3 optimization)
                if(s.charAt(s.length - 2) == ";") s = s.substring(0, s.length - 2) + s.charAt(s.length - 1);
            }
            return s;
        }
        
        protected function PEG_VariableStatement(o:Object, p:Object):String{
            var s:String = "var ";
            for(var n:String in o.declarations) s += this[getPegFunctionName(o.declarations[n].type)](o.declarations[n], o);
            s = s.replace(/#endDelim#/g, ",");
            s = s.substring(0, s.length-1) + ";";
            s = s.replace(/#eqDelim#/g, "=");
            return s;
        }

        protected function PEG_VariableDeclaration(o:Object, p:Object):String{
            return o.name + (o.value == null ? "#eqDelim#null":"#eqDelim#" + this[getPegFunctionName(o.value.type)](o.value, o)) + "#endDelim#";
        }

        protected function PEG_Variable(o:Object, p:Object):String{
            // hack for finicky compiler
            return ((p.type != "PropertyAccess" && isBuiltInFunc(o.name) == false && isClassScoped(o.name)) ? _b64.decode("dGhpcy4="):"") + o.name;
        }

        protected function PEG_NumericLiteral(o:Object, p:Object):String{
            return o.value;
        }

        protected function PEG_BooleanLiteral(o:Object, p:Object):String{
            return o.value;
        }

        protected function PEG_StringLiteral(o:Object, p:Object):String{
            return "\"" + o.value + "\"";
        }

        protected function PEG_ArrayLiteral(o:Object, p:Object):String{
            var s:String = "[";
            for(var n:String in o.elements) s += this[getPegFunctionName(o.elements[n].type)](o.elements[n], o) + ",";
            return s.substring(0, s.length-1) + "]";
        }

        protected function PEG_This(o:Object, p:Object):String{
            return "this";
        }

        protected function PEG_AssignmentExpression(o:Object, p:Object):String{
            return this[getPegFunctionName(o.left.type)](o.left, o) + o.operator + this[getPegFunctionName(o.right.type)](o.right, o) + ";";
        }

        protected function PEG_BinaryExpression(o:Object, p:Object):String{
            return this[getPegFunctionName(o.left.type)](o.left, o) + o.operator + this[getPegFunctionName(o.right.type)](o.right, o);
        }

        /**
         * Helper functions
         **/

        protected function getPegFunctionName(n:String):String {
            return "PEG_" + n;
        }
        
        protected function translateObjectToJS(o:Object):String{
            extractClassScopedIdentifiers(o);
            var s:String = this[getPegFunctionName(o.type)](o.elements, o);
            return s;
        }
                
        public function renderAsString():String{
            return _structure.toJsonString() + "\n" + _result;
        }

        protected function isBuiltInFunc(f:String):Boolean {
            return _BUILT_IN_FUNCTIONS.indexOf(f) >= 0;
        }

        protected function isClassScoped(f:String):Boolean {
            return (_classScopedFunctions.indexOf(f) >= 0 || _classScopedVariables.indexOf(f) >= 0);
        }

        protected function extractClassScopedIdentifiers(o:Object){
            if(o != undefined && o != null){
                if(o.type != undefined && o.type != null){
                    if(o.type == "ClassVariableStatement"){
                        for(var n:String in o.declarations) _classScopedVariables.push(o.declarations[n].name);
                    }
                    if(o.type == "Function"){
                        if(o.modifier != undefined && o.modifier != "") _classScopedFunctions.push(o.name);
                    }
                }
                for(var nn:String in o){
                    if(o[nn] instanceof Object) extractClassScopedIdentifiers(o[nn]);
                }
            }
        }

    }

}

