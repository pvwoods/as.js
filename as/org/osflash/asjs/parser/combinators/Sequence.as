// 'sequence' is a parser combinator that processes a number of parsers in sequence.
// It can take any number of arguments, each one being a parser. The parser that 'sequence'
// returns succeeds if all the parsers in the sequence succeeds. It fails if any of them fail.

package org.osflash.asjs.parser.combinators {
    
    import org.osflash.asjs.parser.combinators.BaseParser;
    import org.osflash.asjs.parser.structs.ParserStruct;

    public class Sequence extends BaseParser{
        
        public var parsers:Array;

        public function Sequence(p:Array):void{

            super('');

            parsers = [];

            for(var i = 0; i < p.length; i++) parsers.push(toParser(p[i]));


        }

        override public function getParserStructForState(state:ParserState):ParserStruct{
            
            var cached:ParserState = state.getCached(id);
            if(cached != null) return cached;

            var ast:Array = [];
            var matched:String = "";
            var i:uint;
            for(i=0; i< parsers.length; i++) {
                var result = parsers[i].getParserStructForState(state);
                if(result != null) {
                    state = result.remaining;
                    if(result.ast != undefined && result.ast != null) {
                        ast.push(result.ast);
                        matched = matched + result.matched;
                    }
                } else {
                    break;
                }
            }
            if(i == parsers.length) {
                cached = new ParserStruct(state, matched, ast);
            } else {
                cached = null;
            }

            state.putCached(id, cached);
            
            return cached; 

        }


    }

}



