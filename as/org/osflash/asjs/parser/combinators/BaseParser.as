package org.osflash.asjs.parser.combinators {

    import org.osflash.asjs.parser.ParserState;
    import org.osflash.asjs.parser.structs.ParserStruct;

    public class BaseParser {
        
        public var id:String;
        public var token:String;

        public function BaseParser(s:String){
            
            id = getUniqueParserId();

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
            if((typeof(p)).toLowerCase() == "string") return new BaseParser(p);
            return p;
        }
        
        protected function getUniqueParserId():String{
            var pattern:Array = ('xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx').split('');
            for(var i:uint = 0; i < pattern.length; i++){
                var r:int = Math.random()*16|0;
                if(pattern[i] == 'x'){
                    pattern[i] = r.toString(16);
                }else if(pattern[i] == 'y'){
                    pattern[i] = (r&0x3|0x8).toString(16);
                }
            }
            return pattern.join('');
        }

    }

}
