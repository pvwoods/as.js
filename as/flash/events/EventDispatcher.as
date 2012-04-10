package flash.events {

    import flash.events.Event;

    public class EventDispatcher {

        protected var _events:Object;

        public function EventDispatcher(target:EventDispatcher = null){
            _events = {};
        }
        
        // weak refs do not exist as of now
        public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
            //
        }

        public function dispatchEvent(event:Event):Boolean {
            //
        }

        public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
            //
        }

        public function willTrigger(type:String):Boolean {
            //
        }

    }

}

