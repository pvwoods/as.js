package org.osflash.asjs.parser {
    
    import org.osflash.asjs.parser.ParserToken;

    public class ASParser {

        public function ASParser():void{


        }

        public function evaluate(s:String):void{
            var index:int = 0;
            var head:ParserToken = new ParserToken("START", null);
            var currentToken:ParserToken = head;
            s = toPostfix(s);
            while(index < s.length){
                var c:String = s.substring(index, index + 1);
                switch(c){
                    case '+':
                    case '-':
                    case '*':
                    case '/':
                        currentToken.next = new ParserToken(getOperator(c), null);
                        break;
                    default:
                        currentToken.next = new ParserToken(getNumber(c), null);
                        break;
                }
                currentToken = currentToken.next;
                index++;
            }
            var count:uint = 0;
            var highestPriorityNode:ParserToken;
            currentToken = head.next;
            var stack:Array = [];
            do{
                switch(currentToken.token){
                    case '+':
                    case '-':
                    case '*':
                    case '/':
                        stack.push(sum(currentToken.token, stack.pop(), stack.pop()));
                        break;
                    default:
                        stack.push(parseFloat(currentToken.token));
                }
                currentToken = currentToken.next;
            }while(currentToken != null)
            trace(stack[0]);
        }

        protected function getNumber(n:String):Number{
            if (isNaN(parseFloat(n))) parserError("Number Expected but was not found.", n);
            return n; 
        }

        protected function getOperator(o:String):String {
            return o;
        }

        protected function parserError(e:String, s:String):void{
            throw Error("Evaluation error for '" + s + "', " + e);
        }

        protected function sum(o:String, rhs:Number, lhs:Number):void{
            if(o == '-'){
                return lhs - rhs;
            }else if(o == '+'){
                return lhs + rhs;
            }else if(o == '/'){
                return lhs / rhs;
            }else {
                return lhs * rhs;
            }
        }

        protected function toPostfix(s:String):String{

            var a:Array = s.split("");

            var precedence = {};
            precedence['*'] = 4;
            precedence['/'] = 3;
            precedence['+'] = 2;
            precedence['-'] = 1;

            var stack:Array = [];
            var postfix:String = "";

            for(var n:int in a){
                var c:String = a[n];
                switch(c){
                    case '+':
                    case '-':
                    case '/':
                    case '*':
                        if(stack.length == 0){
                            stack.push(c);
                        }else {
                            while( precedence[stack[stack.length - 1]] > precedence[c]) postfix += stack.pop();
                            stack.push(c);
                        }
                        break;
                    default:
                        postfix += c;
                        break;
                }
            }
            while(stack.length > 0) postfix += stack.pop();
            return postfix;

        }

    }

}
