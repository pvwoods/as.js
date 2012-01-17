// 'range' is a parser combinator that returns a single character parser
// (similar to 'ch'). It parses single characters that are in the inclusive
// range of the 'lower' and 'upper' bounds ("a" to "z" for example).

package org.osflash.asjs.parser.combinators {
    
    import org.osflash.asjs.parser.combinators.BaseParser;
    import org.osflash.asjs.parser.structs.ParserStruct;

    public class Range extends BaseParser{

        public var upper:String;
        public var lower:String;

        public function Range(l:String, u:String):void{

            super('');

            lower = l;
            upper = u;

        }

        override public function getParserStructForState(state:ParserState):ParserStruct{
            
            var cached:ParserState = state.getCached(id);
            if(cached != null) return cached;

            if(state.length < 1){
                cached = null;
            } else {
                var ch:String = state.at(0);
                trace(ch);
                trace(ch >= lower);
                trace(ch <= upper);
                if(ch >= lower && ch <= upper) {
                    cached = new ParserStruct(state.from(1), ch, ch );
                } else {
                    cached = null;
                }
            }

            state.putCached(id, cached);
            
            return cached; 

        }


    }

}


