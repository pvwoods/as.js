package org.osflash.asjs.parser.combinators {

    import org.osflash.asjs.parser.ParserState;
    import org.osflash.asjs.parser.structs.ParserStruct;
    import org.osflash.asjs.parser.combinators.BaseParser;

    public class Action extends BaseParser {
        
        public var parser:BaseParser;
        public var func:Function;

        public function Action(p:*, f:Function){
            
            parser = toParser(p);
            func = f;

        }

        public function getParserStructForState(state:ParserState):ParserStruct{
            
            var cached:ParserState = state.getCached(id);
            if(cached != null) return cached;
            
            var x:ParserStruct = parser.getParserStructForState(state);
            if(x != null) {
                x.ast = func(x.ast);
                cached = x;
            } else {
                cached = null;
            }
            
            state.putCached(id, cached);
            
            return cached;

        }

    }

}

