package org.osflash.asjs.parser {
    
    public class ParserToken {
        
        public var token:String;
        public var next:ParserToken;

        public function ParserToken(t:String, n:ParserToken):void{
            
            token = t;
            next = n;

        }     
    }

}

