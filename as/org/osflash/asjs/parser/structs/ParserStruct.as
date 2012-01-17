package org.osflash.asjs.parser.structs {

    import org.osflash.asjs.parser.ParserState;

    public class ParserStruct {
        
        public var remaining:ParserState;
        public var match:String;
        public var ast:*;

        public function ParserStruct(r:ParserState, m:String, a:*){
            
            remaining = r;
            match = m;
            ast = a;

        }
        
    }

}

