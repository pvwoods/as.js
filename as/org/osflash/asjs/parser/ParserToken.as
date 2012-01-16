package org.osflash.asjs.parser {

    import org.osflash.asjs.parser.ParserState;

    public class ParserToken {
        
        public var id:uint;
        public var token:String;

        public function ParserToken(pid:uint, s:String){
            
            id = pid;

            token = s;

        }

        public function getState(state:ParserState):*{
            
            var cached:ParserState = state.getCached(id);
            if(cached != null) return cached;

        }

    }

}
