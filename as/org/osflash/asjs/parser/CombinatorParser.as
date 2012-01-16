/*
 * A majority of the implementation here is
 * from https://github.com/doublec/jsparse
 */

package org.osflash.asjs.parser {

    import org.osflash.asjs.parser.ParserState;
    
    public class CombinatorParser {

        protected var _parserState:ParserState;

        public function CombinatorParser():void{
            
            _parserState = new ParserState();

        }



    }

}

