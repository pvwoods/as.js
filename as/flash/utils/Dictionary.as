package flash.utils {
    
    // A simple shell for the Dictionary class.  Weak Keys
    // are not currently supported.

    public class Dictionary {
        
        protected var _useWeakKeys:Boolean;

        // Weak keys are NOT supported
        public function Dictionary(test:string, weakKeys:Boolean = false):void{

            _useWeakKeys = weakKeys;

        }

    }

}
