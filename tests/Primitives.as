package {

    public class Primitives {
        
        public var a:Number = 1;
        public var b:Number = 2;
        public var c:int = 0;
        public var d:Boolean = true;
        public var e:Array =
            [
                "a", "b",
                "c", "d"
            ];
        public var f:String = "Hello World!";

        public var g:int;

        public function Primitives(){
            
            c = a + b;
            
            trace("a + b = " + c);

            trace("d = " + d);
            d = false;
            trace("d = " + d);

            trace("e contains " + e.join(','));

            trace("f contains: '" + f + "'");

            trace("g is " + g);

        }

    }

}

