package org.osflash.asjs.parser {
    
    public class Prelude {
        // ##SC## is used in place of semi colons due to 0.1's inability to handle semicolon's within strings
        // ASPackageRepo is a hold over from an old hack and should be removed at the earliest convenience
        // ___PEG____PARSER is also a hack for now
        protected var _PRELUDE:String = "if(typeof ___PEG____PARSER == 'undefined') var ___PEG____PARSER = null##SC##var ASPackageRepo = {}##SC## var trace = function(){ if(console && console.log) console.log.apply(null, arguments)##SC## }##SC## var ASJS_extendClass = function(a, b){ for(var k in b){ if(b.hasOwnProperty(k) && a[k] === undefined) a[k] = b[k]##SC## } return a##SC##}##SC##"; 

        public function Prelude(){}

        public function generatePrelude():String {

            var r:String = _PRELUDE.replace(/##SC##/g, ";");

            return r;
        }

    }

}
