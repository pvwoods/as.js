package org.osflash.asjs.parser {
    
    public class Prelude {
        // ASPackageRepo is a hold over from an old hack and should be removed at the earliest convenience
        // ___PEG____PARSER is also a hack for now
        protected var _PRELUDE:String = "if(typeof ___PEG____PARSER == 'undefined') var ___PEG____PARSER = null;var ASPackageRepo = {}; var trace = function(){ if(console && console.log) console.log.apply(null, arguments); }; var ASJS_extendClass = function(a, b){ for(var k in b){ if(b.hasOwnProperty(k) && a[k] === undefined) a[k] = b[k]; } return a;};"; 

        public function Prelude(){}

        public function generatePrelude():String {

            return _PRELUDE;
        }

    }

}
