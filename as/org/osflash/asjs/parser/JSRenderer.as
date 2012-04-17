package org.osflash.asjs.parser {
    
    import org.osflash.asjs.parser.objects.ASPackageStructure;
    import org.osflash.asjs.parser.ASParser;

    import flash.utils.Dictionary;

    public class JSRenderer {

        protected var _BUILT_IN_FUNCTIONS:Array = ["trace"];
        
        protected var _result:String;
        protected var _structure:ASPackageStructure;

        protected var _classScopedVariables:Array = []; // any variable that is declared at the class level
        protected var _classScopedFunctions:Array = []; // any class functions

        protected var _importedClasses:String = "";
        protected var _extensionClass:String = "";
        protected var _classnameToParser:Dictionary;

        public function JSRenderer(structure:Object):void{

            _classnameToParser = new Dictionary();
            
            _result = translateObjectToJS(structure);
            // hack until statics implemented
            _structure = ASPackageRepo.__PACK_STRUCTURE__;
            
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
                    case "Block":
                        s+= PEG_PackageBlock(a[i]);
                        break;
                }
            }
            
            // new lines in do not parse properly
            return _importedClasses + s;

        }
        
        // special handler for a package level block
        protected function PEG_PackageBlock(o:Object, p:Object):String{

            var elems:Array = o.statements;

            if(elems == null) return "";

            var importMaps:String = "";

            var s:String = "";
            
            for(var i:int = 0; i < elems.length; i++){
                switch(elems[i].type){
                    case "ImportStatement":
                        // circular imports hack
                        if(ASPackageRepo.__CLASSES__SEEN[elems[i].name] !== true){
                            ASPackageRepo.__CLASSES__SEEN[elems[i].name] = true;
                            var parser:ASParser = new ASParser("");
                            _importedClasses += parser.transmogrify(ASPackageRepo.ROOT_SRC_DIR, elems[i].name);
                            _classnameToParser[elems[i].name.split(".").pop()] = parser; 
                        }
                        importMaps += "CLASS_" + elems[i].name.split(".").pop() + ": " + elems[i].name + ", ";
                        break;
                    default:
                        s += this[getPegFunctionName(elems[i].type)](elems[i], o);
                        break;
                }
            }
            // hack for the finicky nature of the 0.1 compiler with Strings '};'
            s += ";";
            s = s.replace("###IMPORT_MAPS###{", "{" + importMaps);
            if(_extensionClass != "") s += "ASJS_extendClass(ret, new ret.CLASS_" + _extensionClass + "(true));";
            s += "if(ret[CLASS_NAME] !== undefined && noInvoke != true) ret[CLASS_NAME].apply(ret, arguments); return ret;};";
            return s;

        }

        protected function PEG_Block(o:Object, p:Object):String{

            var elems:Array = o.statements;
            
            if(elems == null) return "";

            var s:String = "";
            
            for(var i:int = 0; i < elems.length; i++) s += this[getPegFunctionName(elems[i].type)](elems[i], o);
            
            return "{" + s + "}";

        }

        protected function PEG_EmptyStatement(o:Object, p:Object):String {
            return "";
        }

        protected function PEG_PackageStatement(o:Object, p:Object):String{
            if(o.name == "" || o.name == undefined) return "var ";
            ASPackageRepo.__PACK_STRUCTURE__.addToPackageStructure(o.name);
            return o.name + ".";
        }

        protected function PEG_ClassStatement(o:Object, p:Object):String{
            var s:String = o.name + " = function(noInvoke){"
            s += "var CLASS_NAME = '" + o.name + "'; var ret = ###IMPORT_MAPS###";
            _extensionClass = o.extension;
            if(_extensionClass != ""){
                _classScopedVariables = _classScopedVariables.concat(_classnameToParser[_extensionClass].renderer.getClassScopedVariables());
                _classScopedFunctions = _classScopedFunctions.concat(_classnameToParser[_extensionClass].renderer.getClassScopedFunctions());
            }
            return s;
        }

        protected function PEG_Function(o:Object, p:Object):String{

            var s:String = (o.name  == null ? "":o.name + ": ") + "function(";

            _classScopedFunctions.push(o.name);

            var optionalSetters:String = "";
            
            for(var n:string in o.params){
                s += o.params[n].head + ",";
                if(o.params[n].defaultValue != ""){
                    optionalSetters += o.params[n].head + " = " + o.params[n].head + " || " + o.params[n].defaultValue.value + ";";
                }
            }
            
            if(s.charAt(s.length - 1) == ",") s = s.substring(0, s.length - 1);

            s += "){" + optionalSetters;


            //handle anything within the function
            if(o.elements != null){
                for(var i:int = 0; i < o.elements.length; i++) s += this[getPegFunctionName(o.elements[i].type)](o.elements[i], o);
            }
            // this needs a better way of determining end delimiter needs
            return s + "}" + (o.name != null ? ",":"");
        }

        protected function PEG_FunctionCall(o:Object, p:Object):String{

            var s:String = this[getPegFunctionName(o.name.type)](o.name, o);
            if(s == "super") s = "this." + _extensionClass;
            s += "(";
            if(o.arguments != null){
                
                if(o.arguments.length > 1){
                    for(var i:int = 0; i < o.arguments.length - 1; i++) s += this[getPegFunctionName(o.arguments[i].type)](o.arguments[i], o) + ", ";
                }
                if(o.arguments.length > 0) s += this[getPegFunctionName(o.arguments[o.arguments.length - 1].type)](o.arguments[o.arguments.length - 1], o);
            }
            return s + ")" + (needsSemiColon(p) ? ";":"");
        }

        protected function PEG_ReturnStatement(o:Object, p:Object):String{
           return "return " +   this[getPegFunctionName(o.value.type)](o.value, o) + ";";
        }

        protected function PEG_PropertyAccess(o:Object, p:Object):String{
            return this[getPegFunctionName(o.base.type)](o.base, o) + ((typeof o.name == "string") ? ("." + o.name):("[" + this[getPegFunctionName(o.name.type)](o.name, o) + "]"));
        }

        protected function PEG_ClassVariableStatement(o:Object, p:Object):String{
            var s:String = "";
            if(o.declarations != undefined && o.declarations != null){
                for(var n:String in o.declarations){
                    s += this[getPegFunctionName(o.declarations[n].type)](o.declarations[n], o) + ",";
                }
                s = s.replace(/#eqDelim#/g, ":");
                s = s.replace(/#null#/g, ": null");
                if(o.isStatic == true ){
                    // handle static variable
                }
            }
            return s;
        }
        
        protected function PEG_VariableStatement(o:Object, p:Object):String{
            var s:String = "var ";
            for(var n:String in o.declarations) s += this[getPegFunctionName(o.declarations[n].type)](o.declarations[n], o);
            s = s.replace(/#null#/g, "=null;");
            s = s.replace(/#eqDelim#/g, "=");
            return s + (needsSemiColon(p) ? ";":"");
        }

        protected function PEG_VariableDeclaration(o:Object, p:Object):String{
            return o.name + (o.value == null ? "#null#":"#eqDelim#" + this[getPegFunctionName(o.value.type)](o.value, o));
        }

        protected function PEG_Variable(o:Object, p:Object):String{
            // hack for finicky compiler
            return ((isBuiltInFunc(o.name) == false && isClassScoped(o.name)) ? "this.":"") + o.name;
        }

        protected function PEG_NumericLiteral(o:Object, p:Object):String{
            return o.value;
        }

        protected function PEG_BooleanLiteral(o:Object, p:Object):String{
            return o.value;
        }

        protected function PEG_StringLiteral(o:Object, p:Object):String{
            return o.value.quoteType + o.value.contents + o.value.quoteType;
        }

        protected function PEG_ArrayLiteral(o:Object, p:Object):String{
            var s:String = "[";
            for(var n:String in o.elements) s += this[getPegFunctionName(o.elements[n].type)](o.elements[n], o) + ",";
            if(s.charAt(s.length - 1) == ',') s = s.substring(0, s.length-1);
            return s + "]";
        }

        protected function PEG_ObjectLiteral(o:Object, p:Object):String{
            var s:String = "{";
            for(var n:String in o.properties) s += this[getPegFunctionName(o.properties[n].type)](o.properties[n], o) + ",";
            return s + "}";
        }

        protected function PEG_PropertyAssignment(o:Object, p:Object):String {
            return o.name + ": " + this[getPegFunctionName(o.value.type)](o.value, o);
        }

        protected function PEG_This(o:Object, p:Object):String{
            return "this";
        }

        protected function PEG_NullLiteral(o:Object, p:Object):String{
            return "null";
        }

        protected function PEG_NewOperator(o:Object, p:Object):String{
            var s:String = "new this.CLASS_" + this[getPegFunctionName(o.cnstruct.type)](o.cnstruct, o) + "(";
            for(var n:String in o.arguments) s += this[getPegFunctionName(o.arguments[n].type)](o.arguments[n], o) + ",";
            if(s.charAt(s.length - 1) == ",") s = s.substring(0, s.length-1);
            return s + ")" + (p.type == "Block" ? ";":"");
        }

        protected function PEG_AssignmentExpression(o:Object, p:Object):String{
            return this[getPegFunctionName(o.left.type)](o.left, o) + o.operator + this[getPegFunctionName(o.right.type)](o.right, o) + ";";
        }

        protected function PEG_UnaryExpression(o:Object, p:Object):String{
            return o.operator +  " " + this[getPegFunctionName(o.expression.type)](o.expression, o) + (needsSemiColon(p) ? ";":"");
        }

        protected function PEG_BinaryExpression(o:Object, p:Object):String{
            return this[getPegFunctionName(o.left.type)](o.left, o) + " " + o.operator + " " + this[getPegFunctionName(o.right.type)](o.right, o);
        }

        protected function PEG_PostfixExpression(o:Object, p:Object):String{
            return this[getPegFunctionName(o.expression.type)](o.expression, o) + " " + o.operator + (needsSemiColon(p) ? ";":"");
        }

        protected function PEG_IfStatement(o:Object, p:Object):String{
            var s:String = "if(" + this[getPegFunctionName(o.condition.type)](o.condition, o);
            s += "){" + this[getPegFunctionName(o.ifStatement.type)](o.ifStatement, o) + "}";
            if(o.elseStatement != null) s += "else{ " + this[getPegFunctionName(o.elseStatement.type)](o.elseStatement, o) + "}";
            return s;
        }

        protected function PEG_ConditionalExpression(o:Object, p:Object):String{
            var s:String = "(" + this[getPegFunctionName(o.condition.type)](o.condition, o) + " ? ";
            s += "(" + this[getPegFunctionName(o.trueExpression.type)](o.trueExpression, o) + "):(";
            s += this[getPegFunctionName(o.falseExpression.type)](o.falseExpression, o) + "))";
            return s;
        }

        protected function PEG_WhileStatement(o:Object, p:Object):String{
            return "while(" + this[getPegFunctionName(o.condition.type)](o.condition, o) + ")" +  this[getPegFunctionName(o.statement.type)](o.statement, o);
        }

        protected function PEG_DoWhileStatement(o:Object, p:Object):String{
            var s:String = "do";
            s += this[getPegFunctionName(o.statement.type)](o.statement,o);
            s += "while(" + this[getPegFunctionName(o.condition.type)](o.condition,o) + ");";
            return s;
        }

        protected function PEG_ForStatement(o:Object, p:Object):String{
            var s:String = "for(";
            if(o.initializer != undefined && o.initializer != null) s += this[getPegFunctionName(o.initializer.type)](o.initializer,o) + ";";
            if(o.test != undefined && o.test != null) s += this[getPegFunctionName(o.test.type)](o.test,o) + ";";
            if(o.counter) s += this[getPegFunctionName(o.counter.type)](o.counter,o) + ")";
            return s + this[getPegFunctionName(o.statement.type)](o.statement,o);
        }

        protected function PEG_ForInStatement(o:Object, p:Object):String{
            var s:String = "for(var ";
            s += this[getPegFunctionName(o.iterator.type)](o.iterator,o) + " in " + this[getPegFunctionName(o.collection.type)](o.collection,o) + ")";
            s = s.replace(/#null#/g, "");
            return s + this[getPegFunctionName(o.statement.type)](o.statement,o);
        }

        protected function PEG_SwitchStatement(o:Object, p:Object):String{
            var s:String = "switch(" + this[getPegFunctionName(o.expression.type)](o.expression,o) + "){";
            for(var i:uint = 0; i < o.clauses.length; i++){
                s+= this[getPegFunctionName(o.clauses[i].type)](o.clauses[i],o);
            }
            return s + "}";
        }

        protected function PEG_CaseClause(o:Object, p:Object):String{
            var s:String = "case " + this[getPegFunctionName(o.selector.type)](o.selector,o) + ":";
            for(var i:uint = 0; i < o.statements.length; i++){
                s+= this[getPegFunctionName(o.statements[i].type)](o.statements[i],o);
            }
            return s;
        }

        protected function PEG_DefaultClause(o:Object, p:Object):String{
            var s:String = "default:";
            for(var i:uint = 0; i < o.statements.length; i++){
                s+= this[getPegFunctionName(o.statements[i].type)](o.statements[i],o);
            }
            return s;
        }

        protected function PEG_BreakStatement(o:Object, p:Object):String{
            return "break;";
        }

        protected function PEG_RegularExpressionLiteral(o:Object, p:Object):String{
            return "/" + o.body + "/" + o.flags;
        }

        protected function PEG_ThrowStatement(o:Object, p:Object):String{
            return "throw " + this[getPegFunctionName(o.exception.type)](o.exception,o);
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
            // this is an ugly hack until I determine a good way to place semicolons
            s = s.replace(/;;/g, ";");
            return s;
        }
                
        public function renderAsString():String{
            return _result;
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

        protected function needsSemiColon(p:Object):Boolean{
            return ((p.type == "Block") || (p.type == "Function") || (p.type == "CaseClause") || (p.type == "DefaultClause"));
        }

        public function getClassScopedVariables():Array {
            return _classScopedVariables;
        }

        public function getClassScopedFunctions():Array {
            return _classScopedFunctions;
        }

    }

}

