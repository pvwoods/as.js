/**
 * AS.JS v0.0.1
 * 
 * This particular version of as.js acts
 * as nothing more than a finicky bootstrap
 * compiler/converter for writing the v0.2
 * actionscript version.  Therefore, there
 * are a lot of hacks here that will be understood as "good enough for now".
 */

var fs = require('fs');

var AS = exports.AS = {
    
    /**
     * CONSTANTS
     **/

    METHOD_MODIFIERS: ["public", "private", "protected", "internal"],

    IMPORT_REG: new RegExp("import\\s\\s*([\\w\\.]*)"),

    CLASS_VARIABLE_REG: "[\\s]*var[\\s]*([\\w]*)([\\:\\s\\w\\*]*)?",

    FUNCTION_REG: "[\\s]*function[\\s]*([\\w]*)\\(([\\w\\s\\:\\,\\=\\-\\'\\*]*)\\)[\\s\\:\\w\\*]*",

    CLASS_REG: "[\\s]*class[\\s]*([\\w]*)[\\w\\s]*",

    EXTENSION_REG: new RegExp("extends\\s*([\\w]*)"),

    PACKAGE_REG: new RegExp("package[\\s]*([\\w\.]*)"),

    /**
     * Where the bulk of the work happens
     **/

    dumping: false,
    verbose: false,

    
    build: function(srcDir, entryClass, noBoot, dump, verb){

       if(Classes[entryClass] === undefined){

           ClassesSeen[entryClass] = true;

           this.dumping = dump === true ? true:this.dumping;

           this.verbose = verb === true ? true:this.verbose;
           
           if(this.verbose) console.log("NOW COMPILING :: " + entryClass);

           var packageToFile = entryClass.replace(new RegExp("\\.", "g"), "/") + ".as";
           var className = entryClass.substr(entryClass.lastIndexOf(".") + 1);

           this._buildPackageStructure(entryClass);

           var js = this.transmogrify(srcDir, packageToFile);  
           if(this.dumping) ASFile += js + '\n';
           if(this.verbose) console.log("NOW EVALUATING :: " + entryClass);
           try{
               //eval(js);
           }catch(err){
               console.log("ERROR EVALUATING :: " + entryClass);
               console.log("DUMPING JS...");
               console.log(js);
               throw err;
           }

           if(!noBoot){
               var bootstrap = "var app = ASPackageRepo." + entryClass + "().__asjs__init__();";
               if(!this.dumping){
                   console.log("\n********************\n**     RUNNING    **\n********************\n");
                   eval(bootstrap);
               }else{
                   ASFile = "var ASPackageRepo = " + JSON.stringify(ASPackageRepo) + "\n" + ASFile;
                   ASFile += "\n" + bootstrap;
                   return ASFile;
               }

           }
       }
       
    },

    transmogrify: function(srcPath, filePath){
        var file = (fs.readFileSync(srcPath + filePath)).toString();
        file = this._replaceTrace(file);
        file = this._strip(file);

        var className = this._extractClassName(file);
        var packageName = this._extractPackage(file);
        var selfClass = packageName + (packageName === '' ? "":".") + className;
        
        file = this._fixDependencies(file, srcPath, selfClass);
        
        var vars = this._extractClassScopeVariables(file);
        var funcs = this._extractFunctions(file);
        
        Classes[selfClass] = MODELS.ASclass(className, this._extractExtensionClass(file), funcs, vars);
        var p = MODELS.ASpackage(packageName, Classes[selfClass]);
        return p.JSForm();
    },

    _replaceTrace: function(s){
        return s.replace(new RegExp("trace", "g"), "AS.trace");
    },
    
    
    // strip any comments or other problems
    _strip: function(s){
        
        // remove double slash comments
        s = s.replace(new RegExp("\\/\\/.*", "g"), "");

        // remove block comments
        s = s.replace(new RegExp("\\/\\*.*\\*\\/", "g"), "");
        
        // create a token to preserve this returns
        s = s.replace(new RegExp("return this", "g"), "%%RETURN__THIS%%");

        // remove any 'this.' references
        s = s.replace(new RegExp("this\\.", "g"), "");

        // remove static ref
        s = s.replace(new RegExp("static", "g"), "");

        // change constants to vars
        s = s.replace(new RegExp("const", "g"), "var");

        // assume that overrides are correct
        s = s.replace(new RegExp("override", "g"), "");

        //if(this.verbose) console.log("FILE AFTER STRIP :: \n" + s);

        return s;

    },

    _getDependencies: function(s){
        
        var r = this.IMPORT_REG;
        var match = r.exec(s);
        var f = [];
        var a = [];

        while(match !== null){

            f.push(match[1]);
            a = s.split("");
            a.splice(match.index, match[0].length + 1);
            s = a.join("");
            match = r.exec(s);

        }

        return f;
        
    },

    _fixDependencies: function(s, srcPath, selfClass){
        var dependencies = this._getDependencies(s);
        dependencies.push(selfClass);
        for(var i = 0; i < dependencies.length; i++){
            if(ClassesSeen[dependencies[i]] !== true) AS.build(srcPath, dependencies[i], true);
            s = s.replace(new RegExp("new\\s*" + dependencies[i].split('.').pop(), "g"), dependencies[i] + "().__asjs__init__");
            s = s.replace(new RegExp(dependencies[i], "g"), "ASPackageRepo." + dependencies[i]);
            s = s.replace(new RegExp("import ASPackageRepo\\.", "g"), "import ");
        }
        return s;
    },

    _extractFunctions: function(s){
        
        var r = this._getFunctionRestructionReg();
        var match = r.exec(s);
        var functions = [];
        var f = {};
        var a = [];

        while(match !== null){
            f = MODELS.ASfunction(match[1], match[2], match[3], "void", this._readFunctionContents(s, (match.index + match[0].length)));
            functions.push(f);
            a = s.split("");
            a.splice(match.index, match[0].length + f.contents.length)
            s = a.join("");
            match = r.exec(s);
        }

        if(this.verbose){
            console.log("FOUND FUNCTIONS ::");
            console.log(functions);
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

        var match = r.exec(s);
        var variables = [];
        var v = {};
        var a = [];

        while(match !== null){
            try{
                v = MODELS.ASClassVariable(match[1], match[2], match[3].substr(1), this._readVariableContents(s, (match.index + match[0].length)));
            }catch(err){
                console.log("ERROR CREATING VARIABLE :: ");
                console.log(match);
                throw err;
            }
            variables.push(v);
            a = s.split("");
            a.splice(match.index, match[0].length + v.value.length)
            s = a.join("");
            match = r.exec(s);
        }

        if(this.verbose){
            console.log("FOUND VARIABLES :: ");
            console.log(variables);
        }

        return variables;

    },
    
    // this current implementation is very naive.
    // Currently, all variables must be ended by a semicolon
    // and does not take into account that a semicolon may not
    // actually be the end of the variable decleration
    // i.e. public var a:String = ";";
    _readVariableContents: function(s, i){
        if(s[i] === ';') return 'null';
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
        return r.exec(s)[2];
    },

    _extractExtensionClass: function(s){
        var r = this._getClassRestructionReg();
        var m = r.exec(s)[0];
        var e = this.EXTENSION_REG.exec(m);
        if(e !== null && e[1] !== null){
            var im = new RegExp("import\\s*([\\w\\.]*" + e[1] + ")").exec(s);
            if(im !== null && im[1] !== null){
                return im[1];
            }else{
                console.log("ERROR :: could not find import statement for extension class " + e[1]);
                return e[1];
            }
        }
        return null;
    },

    _extractPackage: function(s){
        return this.PACKAGE_REG.exec(s)[1];
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
    },

    extendClass: function(a, b){ 
        for(var k in b){ 
            if(b.hasOwnProperty(k) && a[k] === undefined)
                a[k] = b[k]; 
        } 
        return a;
    },

    _buildPackageStructure: function(entryClass){

        var steps = entryClass.split('.');
        steps.pop();
        var c = ASPackageRepo;
        for(var i = 0; i < steps.length; i++){
            if(c[steps[i]] === undefined) c[steps[i]] = {};
            c = c[steps[i]];
        }

    }


}

var MODELS = {
    
   ASpackage: function(p, c){

        return {
            packageName: p || "_",
            clss: c,

            ASForm: function(){
                return '';
            },

            JSForm: function(){
                var result = "ASPackageRepo" + (this.packageName == "_" ? "":("." + this.packageName)) + "." + this.clss.name + " = ";
                result += this.clss.JSForm();
                result += "\n};";
                return result;
            }
        }
    
    },

    ASclass: function(n, e, f, v){

        var c = {
            name: n,
            extendClass: e,
            functions: f,
            variables: v,

            ASForm: function(){
                return '';
            },

            JSForm: function(){
                var result = "function(){ return {\n";
                for(var b = 0; b < this.variables.length; b++){
                    result += this.variables[b].JSForm();
                }
                for(var i = 0; i < this.functions.length; i++){
                    result += this.functions[i].JSForm(this.extendClass != null ? this.extendClass.substr(this.extendClass.lastIndexOf(".") + 1):"");
                }
                result += "__asjs__init__: function(){ ";
                if(this.extendClass !== null) result += "AS.extendClass(this, ASPackageRepo." + this.extendClass + "()); ";
                result += "if(this." + this.name + " !== undefined){ this." + this.name + ".apply(this, arguments); } return this;},"
                result += "\n}";
                return result;
            },

            getFunctionScopableNames: function(addInheritance){
                var functionScopableNames = [];
                for(var j = 0; j < this.variables.length; j++) functionScopableNames.push(this.variables[j].name);
                for(var h = 0; h < this.functions.length; h++) functionScopableNames.push(this.functions[h].methodName);
                if(addInheritance === true && this.extendClass !== null){
                    if(Classes[this.extendClass] == undefined) console.log("ERROR TRYING TO SCOPE FUNCTION NAMES ON " + this.extendClass + " FOR " + this.name);
                    functionScopableNames.push.apply(functionScopableNames, Classes[this.extendClass].getFunctionScopableNames());
                }
                return functionScopableNames;
            }
        }

        var functionScopableNames = c.getFunctionScopableNames(true);
        if(functionScopableNames.length > 0){
            for(var i = 0; i < c.functions.length; i++){
                c.functions[i].scopeFunctionVariables(functionScopableNames);
            }
        }

        return c;
    
    },

    ASfunction: function(m, n, a, r, c){

        return {

            TYPE_DECLERATION_STRUCTURE_REG: new RegExp(":[\\w\\s\\*]*", "gi"),
            VAR_DECLERATION_STRUCTURE_REG: new RegExp("var\\s*([\\w\\s]*):[\\w\\*]*", "gi"),
            OPTIONAL_ARG_REG: new RegExp(/([\w\s]*)\=([\w\s\-\'\*]*)/),
            VARS_OPEN_STRUCTURE_REG: "[\\s\\(\\[]",
            VARS_CLOSE_STRUCTURE_REG: "[\\s\\.\\}\\)\\+\\-\\/\\*\\;\\(\\,\\[\\]]",

            modifier: m,
            methodName: n,
            args: a,
            returnType: r,
            contents: c,
            optionalArgContents: '',

            _argsJSForm: function(){
               var s = this.args;
               s = s.replace(this.TYPE_DECLERATION_STRUCTURE_REG, "");
               var match = this.OPTIONAL_ARG_REG.exec(s);
               while(match !== null){
                   this.optionalArgContents += match[1] + " = " + match[1] + " || " + match[2] + ";\n";
                   s = s.replace(new RegExp(/\s*\=[\w\s\'\-\*]*/), "");
                   match = this.OPTIONAL_ARG_REG.exec(s);
               } 
               return s;
            },

            scopeFunctionVariables: function(variables){
                var corpra = "(" + variables[0];
                for(var i = 1; i < variables.length; i++) corpra += "|" + variables[i];
                var r = new RegExp(this.VARS_OPEN_STRUCTURE_REG + corpra + ')' + this.VARS_CLOSE_STRUCTURE_REG);
                var match = r.exec(this.contents);
                while(match !== null){
                    this.contents = this.contents.replace(r, match[0][0] + "{{THIS}}" + match[1] + match[0].substr(match[0].indexOf(match[1]) + match[1].length));
                    match = r.exec(this.contents);
                }
                var fr = new RegExp("{{THIS}}", "g");
                this.contents = this.contents.replace(fr, "this.");

            },
            
            ASForm: function(){
                return this.modifier + " function " + this.methodName + "(" + this.args + "):" + this.returnTypeForm;
            },
            
            JSForm: function(superReplacement){
                //var c = this.contents.replace(this.TYPE_DECLERATION_STRUCTURE_REG, "");

                var c = this.contents;

                var match = this.VAR_DECLERATION_STRUCTURE_REG.exec(c);
                while(match !== null){
                   c = c.replace(new RegExp("var\\s*" + match[1] + "\\s*:[\\w\\*]*"), "var " + match[1]);
                   match = this.VAR_DECLERATION_STRUCTURE_REG.exec(c);
                }

                c = c.replace("super(", "this." + superReplacement + "(");
                c = c.replace("%%RETURN__THIS%%", "return this");
                return this.methodName + ": function(" + this._argsJSForm() + "){\n" + this.optionalArgContents + c.substr(1) + ",\n";
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

var ASPackageRepo = {};
var Classes = {};
var ClassesSeen = {}; // this guards against circular imports
var ASFile = 'var AS = { trace: function(){ if(console && console.log) console.log.apply(null, arguments) }, extendClass: function(a, b){ for(var k in b){ if(b.hasOwnProperty(k) && a[k] === undefined) a[k] = b[k]; } return a;}};';
    
