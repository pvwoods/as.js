package org.osflash.asjs.parser {
    
    public class Prelude {
        // ##SC## is used in place of semi colons due to 0.1's inability to handle semicolon's within strings
        protected static const _PRELUDE:String = 'var trace = function(){ if(console && console.log) console.log.apply(null, arguments)##SC## }##SC## var ASJS_extendClass = function(a, b){ for(var k in b){ if(b.hasOwnProperty(k) && a[k] === undefined) a[k] = b[k]##SC## } return a##SC##}##SC##'; 

        public function Prelude(){}

        public function generatePrelude():String {

            var r:String = _PRELUDE.replace(/##SC##/g, ";");

            return r;
        }

    }

}
