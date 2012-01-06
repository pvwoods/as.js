package {

    public class Scope {
        
        public var a:Number = 1;
        public var b:Number = 2;

        public function Scope(){
            
            this.a += 1;
            
            var c:Number = add(a + b);

            trace(c);

        }

        public function add(e:Number, f:Number):Number{
            return e + f;
        }

    }

}


