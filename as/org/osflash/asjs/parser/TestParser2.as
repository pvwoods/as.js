package org.osflash.asjs.parser {

    import org.osflash.asjs.parser.ParserState;
    import org.osflash.asjs.parser.combinators.Sequence;
    import org.osflash.asjs.parser.combinators.Choice;
    import org.osflash.asjs.parser.combinators.Repeat;
    import org.osflash.asjs.parser.combinators.Range;
    import org.osflash.asjs.parser.combinators.Action;

    
    public class TestParser2 {

        protected var _expr:*;
        protected var _value:BaseParser;
        protected var _product:BaseParser;
        protected var _sum:BaseParser;
        
        protected var _number:Action;
        protected var _times:Action;
        protected var _divides:Action;
        protected var _plus:Action;
        protected var _minus:Action;

        public function TestParser2():void{
            
            _number = 
                new Action(new Repeat(new Range('0','9'), 1), 
	            function(ast:*):int {
	                return parseInt(ast.join(""));
        	    });

            _value = new Choice(_number, _expr);

            _times = operatorAction('*', multiply);
            _divides = operatorAction('/', divide);
            _plus = operatorAction('+', add);
            _minus = operatorAction('-', subtract);

            _product = chainl(_value, new Choice([_times, _divides]));
            _sum = chainl(_product, new Choice([_plus, _minus]));
            _expr = _sum;

            trace(_expr.getParserStructForState(new ParserState("1+2")));


        }

        public function chainl(p:*, s:*):* {
            if((typeof(p)).toLowerCase() == "string") p = new BaseParser(p);
            return new Action(new Sequence(p, new Repeat(new Sequence(s, p), 0)),
                  function(ast:*):* {
                      var f:Function = function(v:*, action:*):* { return action[0](v, action[1]); };
                      var initial:* = ast[0];
                      var seq:* = ast[1];
                      for(var i = 0; i < seq.length; i++) initial = f(initial, seq[i]);
                      return initial;

                  });
        }

        public function foldl(f:Function, initial:*, seq:Array) {
            for(var i = 0; i < seq.length; i++) initial = f(initial, seq[i]);
            return initial;
        }

        public function operatorAction(p:String, func:Function):Action{
            return new Action(p, function(ast:*):Function{ return func; });
        }

        public function multiply(l:Number, r:Number){
            return l * r;
        }

        public function divide(l:Number, r:Number){
            return l / r;
        }
        
        public function add(l:Number, r:Number){
            return l + r;
        }

        public function subtract(l:Number, r:Number){
            return l - r;
        }


    }

}



