var AS = exports.AS = {
    
    /**
     * CONSTANTS
     **/

    METHOD_MODIFIERS: ["public", "private", "protected", "internal"],

    FUNCTION_REG: "[\\s]*function[\\s]*([\\w]*)\\(([\\w\\s\\:\\,]*)\\)[\\s\\:\\w]*",

    CLASS_REG: "[\\s]*class[\\s]*([\\w]*)",

    
    /**
     * Where the bulk fo the work happens
     **/


    transmogrify: function(file){
        file = this._replaceTrace(file);
        var f = this._extractFunctions(file);
        var c = MODELS.ASclass(this._extractClassName(file), f);
        console.log(c.name);
        return file;
    },

    _replaceTrace: function(s){
        return s.replace("trace", "AS.trace");
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


    _extractClassName: function(s){
        var r = this._getClassRestructionReg();
        return r(s)[2];
    },

    /**
     * Getters/Setters and utility functions
     **/

    _getFunctionRestructionReg: function(){
      return new RegExp("(" + this.METHOD_MODIFIERS.join("|") + ")" + this.FUNCTION_REG); 
    },

    _getClassRestructionReg: function(){
      return new RegExp("(" + this.METHOD_MODIFIERS.join("|") + ")" + this.CLASS_REG); 
    },

    trace: function(){
        if(console && console.log){
            console.log(arguments);
        }
    }



}

var MODELS = {
    
    ASclass: function(n, f){

        return {
            name: n,
            functions: f,

            ASForm: function(){
                return '';
            },

            JSForm: function(){
                var result = this.name + ": {\n";
                for(var i = 0; i < this.functions.length; i++){
                    result += this.functions[i].JSForm();
                }
                result += "\n}";
                return result;
            }
        }
    
    },

    ASfunction: function(m, n, a, r, c){

        return {

            ARGS_STRUCTURE_REG: new RegExp(":[\\w]*", "g"),

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
            
            ASForm: function(){
                return this.modifier + " function " + this.methodName + "(" + this.args + "):" + this.returnTypeForm;
            },
            
            JSForm: function(){
                return this.methodName + ": function(" + this._argsJSForm() + ")" + this.contents + ",\n";
            }

        }
    }

}
    
