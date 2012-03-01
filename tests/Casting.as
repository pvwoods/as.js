package {

    public class Casting {
        
        public var a:Number = 1;
        public var b:Number = 2;

        public function Casting(){
            
            var c:int = add(a + b);

            trace(c);

        }

        public function add(e:Number, f:Number):int{
            return e + f;
        }

    }

}



