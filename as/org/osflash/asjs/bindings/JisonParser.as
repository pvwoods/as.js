/**
 * Binding classes act as a way of
 * keeping as/js/node mixed code out
 * of the core
 */

package org.osflash.asjs.bindings {

    public class JisonParser {

        protected var _parser:Jison = require('jison');

        public var tokens:Array = [];

        public var grammer:Array = [];

        public var operators:Array = [];

        public var startSymbol:String = [];

        public function JisonParser(t:String, g:Array, o:Array, s:String):void{

            tokens = t;
            grammer = g;
            operators = o;
            startSymbol = s;

        }

        public function getParser():Parser{

            return _parser.Parser(tokens.join(' '), grammer, operators, startSymbol);

        }

    }

}
