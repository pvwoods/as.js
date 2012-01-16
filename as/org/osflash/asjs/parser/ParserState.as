package org.osflash.asjs.parser {
    
    //import flash.utils.Dictionary;

    public class ParserState {
        
        protected static const _memoize:Boolean = true;

        public var parserInput:String;
        public var parserIndex:uint;
        public var parserLength:uint;

        //public var cache:Dictionary;

        public function ParserState(input:String, index:uint):void {
            
            parserInput = input;
            parserIndex = index;
            parserLength = parserInput.length - parserIndex;

            //cache = new Dictionary();

        }

        public function from(index:uint):ParserState{
            
            var result:ParserState = new ParserState(parserInput, parserIndex + index);
            result.cache = cache;
            result.parserLength = parserLength - index;
            return result;

        }

        public function substring(begin:uint = 1, end:uint):String {

            //return parserInput.substr

        }

    }

}

