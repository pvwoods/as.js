// 'choice' is a parser combinator that provides a choice between other parsers.
// It takes any number of parsers as arguments and returns a parser that will try
// each of the given parsers in order. The first one that succeeds results in a
// successful parse. It fails if all parsers fail.

package org.osflash.asjs.parser.combinators {
    
    import org.osflash.asjs.parser.combinators.BaseParser;
    import org.osflash.asjs.parser.structs.ParserStruct;

    public class Choice extends BaseParser{

        public var parsers:Array;

        public function Choice(p:Array):void{

            super('');

            parsers = [];

            for(var i:uint = 0; i < p.length; i++) parsers.push(toParser(p[i]));



        }

        override public function getParserStructForState(state:ParserState):ParserStruct{
            
            var cached:ParserState = state.getCached(id);
            if(cached != null) return cached;     

            var i:uint;
            var result:ParserStruct;

            for(i = 0; i < parsers.length; i++) {
                var result = parser[i].getParserStructForState(state);
                if(result) break;
            }

            if(i == parsers.length){
                cached = null;
            } else {
                cached = result;
            }

            state.putCached(id, cached);
            
            return cached;

        }


    }

}
