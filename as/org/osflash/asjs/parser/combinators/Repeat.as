// A parser combinator that takes one parser. It returns a parser that
// looks for at least N matches of the original parser.

package org.osflash.asjs.parser.combinators {
    
    import org.osflash.asjs.parser.combinators.BaseParser;
    import org.osflash.asjs.parser.structs.ParserStruct;

    public class Repeat extends BaseParser{

        public var parser:BaseParser;
        public var matches:uint;

        public function Repeat(p:*, m:uint):void{

            super('');

            parser = toParser(p);
            matches = m


        }

        override public function getParserStructForState(state:ParserState):ParserStruct{
            
            var cached:ParserState = state.getCached(id);
            if(cached != null) return cached;

            var ast:Array = [];
            var matched:String = "";
            var matchesFound:uint = 0;
            var result:ParserStruct = parser.getParserStructForState(state);

            while(result != null) {
                matchesFound++;
                ast.push(result.ast);
                matched = matched + result.matched;
                if(result.remaining.index == state.index) break;
                state = result.remaining;
                result = parser.getParserStructForState(state);
            }
            
            if(matchesFound >= matches){
                cached = new ParserStruct(state, matched, ast);
            }else{
                cached = null;
            }
            
            state.putCached(id, cached);
            
            return cached; 

        }


    }

}

