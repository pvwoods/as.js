package org.osflash.asjs.parser.combinators {
    
    import org.osflash.asjs.parser.combinators.BaseParser;

    public class Choice extends BaseParser{

        public var parsers:Array;

        public function Choice(pid:uint, p:Array):void{

            super(pid, '');

            parsers = [];

            for(var i:uint = 0; i < p.length; i++) parsers.push(toParser(p[i]));



        }


    }

}
