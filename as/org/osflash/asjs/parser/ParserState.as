package org.osflash.asjs.parser {
    
    import flash.utils.Dictionary;

    public class ParserState {
        
        protected static const _memoize:Boolean = true;

        public var parserInput:String;
        public var parserIndex:uint;
        public var parserLength:uint;

        public var cache:Dictionary;

        public function ParserState(input:String, index:uint):void {
            
            parserInput = input;
            parserIndex = index;
            parserLength = parserInput.length - parserIndex;

            cache = new Dictionary();

        }

        public function from(index:uint):ParserState {
            
            var result:ParserState = new ParserState(parserInput, parserIndex + index);
            result.cache = cache;
            result.parserLength = parserLength - index;
            return result;

        }

        public function substring(begin:uint, end:int = -1):String {
            
            if(end == -1) end = parserLength;
            return parserInput.substring(begin + parserIndex, end + parserIndex);

        }

        public function trimLeft():ParserState{
            var s:String = parserInput.substring(0);
            var m:Array = s.match(new RegExp(/^\s+/));
            if(m != undefined && m.length > 0) return from(m[0].length);
            return this;
        }

        public function at(index:uint):String {
            return parserInput.charAt(parserIndex + index);
        }

        public function getCached(pid:uint):*{

           if(!memoize) return null;

           var p:Dictionary = cache[pid];
           if(p){
               return p[parserIndex];
           }else{
               return null;
           }


        }

        public function putCached(pid:uint, cache:*):void{
            
            if(!memoize) return null;
            
            if(cache[pid] == undefined) cache[pid] = new Dictionary();
               
            cache[pid][parserIndex] = cache; 


        }

        public function toString():String{
            return "PS_['" + substring(0) + "']";
        }

    }

}

