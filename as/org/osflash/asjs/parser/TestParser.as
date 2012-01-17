package org.osflash.asjs.parser {

    import org.osflash.asjs.parser.ParserState;
    import org.osflash.asjs.parser.combinators.Sequence;
    import org.osflash.asjs.parser.combinators.Choice;
    import org.osflash.asjs.parser.combinators.Repeat;
    import org.osflash.asjs.parser.combinators.Range;

    
    public class TestParser {

        protected var _expr:*;
        protected var _value:BaseParser;
        protected var _product:BaseParser;
        protected var _sum:BaseParser;

        public function TestParser():void{
            
            _expr = function(state:ParserState) { return _expr(state); }
            _value = new Choice([new Repeat(new Range('0','9'), 1), _expr]);
            _product = new Sequence([_value, new Repeat(new Sequence([new Choice(['*', '/']), _value]), 0)]);
            _sum = new Sequence([_product, new Repeat(new Sequence([new Choice(['+', '-']), _product]), 0)]);
            _expr = _sum;

            trace(_expr.getParserStructForState(new ParserState("1+2*3+4")));
            //trace(_expr);


        }

    }

}


