package org.osflash.asjs.parser {
    
    public class Prelude {
        
        protected var _PRELUDE:String = "if(typeof ___PEG____PARSER == 'undefined') var ___PEG____PARSER = null;var trace = function(){ if(console && console.log) console.log.apply(null, arguments); }; var ASJS_extendClass = function(a, b){ for(var k in b){ if(b.hasOwnProperty(k) && a[k] === undefined) a[k] = b[k]; } return a;};"; 

        public function Prelude(){}

        public function generatePrelude():String {

            return _PRELUDE;
        }

    }

}
