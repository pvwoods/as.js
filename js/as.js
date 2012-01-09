var AS = exports.AS = {
    
    /**
     * CONSTANTS
     **/

    METHOD_MODIFIERS: ["public", "private", "protected", "internal"],

    CLASS_VARIABLE_REG: "[\\s]*var[\\s]*([\\w]*)([\\:\\s\\w]*)?",

    FUNCTION_REG: "[\\s]*function[\\s]*([\\w]*)\\(([\\w\\s\\:\\,]*)\\)[\\s\\:\\w]*",

    CLASS_REG: "[\\s]*class[\\s]*([\\w]*)",

    PACKAGE_REG: new RegExp("package[\\s]*([\\w\.]*)"),

    /**
     * Where the bulk of the work happens
     **/

    
    build: function(file, entryPackage, entryClass){
       var js = this.transmogrify(file);
       eval(js);
       var bootstrap = "var app = ASPackageRepo." + entryPackage + (entryPackage === '' ? "":".") + entryClass + "();\n app." + entryClass + "();";
       eval(bootstrap);
       
    },

    transmogrify: function(file){
        file = this._replaceTrace(file);
        var vars = this._extractClassScopeVariables(file);
        var funcs = this._extractFunctions(file);
        var p = MODELS.ASpackage(this._extractPackage(file), MODELS.ASclass(this._extractClassName(file), funcs, vars));
        return p.JSForm();
    },

    _replaceTrace: function(s){
        return s.replace(new RegExp("trace", "g"), "AS.trace");
    },

    _extractFunctions: function(s){
        
        var r = this._getFunctionRestructionReg();
        var match = r(s);
        var functions = [];
        var f = {};
        var a = [];

        while(match !== null){
            f = MODELS.ASfunction(match[1], match[2], match[3], "void", this._readFunctionContents(s, (match.index + match[0].length)));
            functions.push(f);
            a = s.split("");
            a.splice(match.index, match[0].length + f.contents.length)
            s = a.join("");
            match = r(s);
        }

        return functions;
    },

    _readFunctionContents: function(s, i){
        var brackets = 1;
        var result = s[i];
        var c = ''
        while(brackets > 0){
            i++;
            c = s[i];
            result += c;
            if(c === "{") brackets += 1;
            else if(c === "}") brackets -= 1;
        }
        return result;
    },

    _extractClassScopeVariables: function(s){
        
        var r = this._getClassVairableRestructionReg();

        var match = r(s);
        var variables = [];
        var v = {};
        var a = [];

        while(match !== null){
            v = MODELS.ASClassVariable(match[1], match[2], match[3].substr(1), this._readVariableContents(s, (match.index + match[0].length)));
            variables.push(v);
            a = s.split("");
            a.splice(match.index, match[0].length + v.value.length)
            s = a.join("");
            match = r(s);
        }

        return variables;

    },
    
    // this current implementation is very naive.
    // Currently, all variables must be ended by a semicolon
    // and does not take into account that a semicolon may not
    // actually be the end of the variable decleration
    // i.e. public var a:String = ";";
    _readVariableContents: function(s, i){
        var result = s[i];
        var c = ''
        while(c != ';'){
            result += c;
            i++;
            c = s[i];
        }
        return result;
    },


    _extractClassName: function(s){
        var r = this._getClassRestructionReg();
        return r(s)[2];
    },

    _extractPackage: function(s){
        return this.PACKAGE_REG(s)[1];
    },

    /**
     * Getters/Setters and utility functions
     **/

    _getFunctionRestructionReg: function(){
      return new RegExp("(" + this.METHOD_MODIFIERS.join("|") + ")" + this.FUNCTION_REG); 
    },

    _getClassVairableRestructionReg: function(){
      return new RegExp("(" + this.METHOD_MODIFIERS.join("|") + ")" + this.CLASS_VARIABLE_REG); 
    },

    _getClassRestructionReg: function(){
      return new RegExp("(" + this.METHOD_MODIFIERS.join("|") + ")" + this.CLASS_REG); 
    },

    _getPackageRestructionReg: function(){
      return new RegExp("(" + this.METHOD_MODIFIERS.join("|") + ")" + this.CLASS_REG); 
    },

    trace: function(){
        if(console && console.log){
            console.log.apply(this, arguments);
        }
    }



}

var MODELS = {
    
   ASpackage: function(p, c){

        return {
            packageName: p || "ASPackageRepo",
            clss: c,

            ASForm: function(){
                return '';
            },

            JSForm: function(){
                var result = "var " + this.packageName + " = {\n";
                result += this.clss.JSForm();
                result += "\n};";
                return result;
            }
        }
    
    },

    ASclass: function(n, f, v){

        var c = {
            name: n,
            functions: f,
            variables: v,

            ASForm: function(){
                return '';
            },

            JSForm: function(){
                var result = this.name + ": function(){ return {\n";
                for(var b = 0; b < this.variables.length; b++){
                    result += this.variables[b].JSForm();
                }
                for(var i = 0; i < this.functions.length; i++){
                    result += this.functions[i].JSForm();
                }
                result += "\n}\n}";
                return result;
            }
        }
        if(c.variables && c.variables.length > 0){
            for(var i = 0; i < c.functions.length; i++){
                c.functions[i].scopeFunctionVariables(c.variables);
            }
        }

        return c;
    
    },

    ASfunction: function(m, n, a, r, c){

        return {

            ARGS_STRUCTURE_REG: new RegExp(":[\\w]*", "g"),
            VARS_OPEN_STRUCTURE_REG: "[\\s\\.]",
            VARS_CLOSE_STRUCTURE_REG: "[\\s\\.\\}\\)\\+\\-\\/\\*\\;]",

            modifier: m,
            methodName: n,
            args: a,
            returnType: r,
            contents: c,

            _argsJSForm: function(){
               var s = this.args;
               s.replace(this.ARGS_STRUCTURE_REG, "");
               return s;
            },

            _structureLocalVariables: function(){
                
                

            },

            scopeFunctionVariables: function(variables){
                var corpra = "(" + variables[0].name;
                for(var i = 1; i < variables.length; i++) corpra += "|" + variables[i].name;
                var r = new RegExp(this.VARS_OPEN_STRUCTURE_REG + corpra + ')' + this.VARS_CLOSE_STRUCTURE_REG);
                var match = r(this.contents);
                while(match !== null){
                    this.contents = this.contents.replace(r, " {{THIS}}" + match[1] + match[0].substr(match[0].indexOf(match[1]) + match[1].length));
                    match = r(this.contents);
                }
                var fr = new RegExp("{{THIS}}", "g");
                this.contents = this.contents.replace(fr, "this.");

            },
            
            ASForm: function(){
                return this.modifier + " function " + this.methodName + "(" + this.args + "):" + this.returnTypeForm;
            },
            
            JSForm: function(){
                return this.methodName + ": function(" + this._argsJSForm() + ")" + this.contents + ",\n";
            }

        }
    },

    ASClassVariable: function(m, n, t, v){

        return {
            
            modifier: m,
            name: n,
            type: t,
            value: v,

            ASForum: function(){
                return this.modifier + " var " + this.name + ":" + this.type + this.value;
            },

            JSForm: function(){
                var equalIndex = this.value.indexOf('=');
                return this.name + ": " + this.value.substr(equalIndex + 1) + ",\n";
            }
            

        }

    }

}
    
