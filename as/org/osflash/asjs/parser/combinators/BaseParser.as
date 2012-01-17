package org.osflash.asjs.parser.combinators {

    import org.osflash.asjs.parser.ParserState;
    import org.osflash.asjs.parser.structs.ParserStruct;

    import org.osflash.asjs.util.Utils;

    public class BaseParser {
        
        public var id:uint;
        public var token:String;

        public function BaseParser(s:String){
            
            id = org.osflash.asjs.util.Utils.getUID();

            token = s;

        }

        public function getParserStructForState(state:ParserState):ParserStruct{
            
            var cached:ParserState = state.getCached(id);
            if(cached != null) return cached;

            var r:Boolean = state.length >= token.length && state.substring(0, token.length) == token;

            if(r){
                cached = new ParserStruct(state.from(token.length), token, token);
            }else{
                cached = null;
            }

            state.putCached(id, cached);
            
            return cached;

        }

        public function toParser(p:*):BaseParser {
            if(typeof(p).toLowerCase() == "string") return new BaseParser(p);
            return p;
        }

    }

}
