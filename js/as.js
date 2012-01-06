var AS = exports.AS = {
    
    /**
     * CONSTANTS
     **/

    METHOD_MODIFIERS: ["public", "private", "protected", "internal"],

    FUNCTION_REG: "[\\s]*function[\\s]*([\\w]*)\\(([\\w\\s\\:\\,]*)\\)[\\s\\:\\w]*",

    CONVERSION_STEPS: [this._replaceTrace, this._restructureFunctions],

    
    /**
     * Where the bulk fo the work happens
     **/


    transmogrify: function(file){
        file = this._replaceTrace(file);
        file = this._restructureFunctions(file);
        return file;
    },

    _replaceTrace: function(s){
        return s.replace("trace", "AS.trace");
    },

    _restructureFunctions: function(s){
        var r = this._getFunctionRestructionReg();
        var arr = r(s);
        var functionBeginIndex = arr[4] + arr[0].length;

        var f = MODELS.ASfunction(arr[1], arr[2], arr[3], "void");
        
        return s.replace(r, "[[FUNCTION]]");
    },

    _readFunctionContents: function(s, i){
        var brackets = 1;
        var result = '';
        while(brackets != 0){
            //result += 
        }
    },


    _fixClassScope: function(s){
        return s;
    },

    /**
     * Getters/Setters and utility functions
     **/

    _getFunctionRestructionReg: function(){
      return new RegExp("(" + this.METHOD_MODIFIERS.join("|") + ")" + this.FUNCTION_REG, "g"); 
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
                return '';
            }
        }
    
    },

    ASfunction: function(m, n, a, r){

        return {

            ARGS_STRUCTURE_REG: new RegExp(":[\\w]*", "g"),

            modifier: m,
            methodName: n,
            args: a,
            returnType: r,

            _argsJSForm: function(){
               var s = this.args;
               s.replace(this.ARGS_STRUCTURE_REG, "");
               return s;
            },
            
            ASForm: function(){
                return this.modifier + " function " + this.methodName + "(" + this.args + "):" + this.returnTypeForm;
            },
            
            JSForm: function(){
                return this.methodName + ": function(" + this._argsJSForm() + ")";
            }

        }
    }

}
    
