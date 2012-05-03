package {

    public class StaticConst {
        
        private const a:Number = 1;
        internal static var b:Number = 2;

        public function StaticConst():void{
            
            trace("a contains " + a);

            trace("b contains: " + StaticConst.b);

        }

    }

}


