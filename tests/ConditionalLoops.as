package {

    public class ConditionalLoops {

        public function ConditionalLoops(){

            var a:Boolean = true;

            if(a) trace("a is true");

            if(!a){
                trace("this should not be traced");
            }

            var b:int = 0;

            while(b < 10){
                trace("b is less than 10");
                b++;
            }

            do{
                --b;
                trace("b is " + b);
            }while(b > 5);

            for(var i:int = 0; i < 10; i++){
                trace("i = " + i);
            }


        }
    }

}


