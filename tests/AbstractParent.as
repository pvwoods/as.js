package {

    public class AbstractParent {

        protected var _callee:String;

        public function AbstractParent(calleeName:String):void{
            trace("hello " + calleeName + " from the abstract parent!");
            _callee = calleeName;
        }

        public function execute():void{
            trace(_callee + " is executing abstract parent class");
        }

    }

}
