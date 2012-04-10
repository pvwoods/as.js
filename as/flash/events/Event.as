package flash.events {
    
    public class Event {
        
        public var type:String;
        public var bubbles:Boolean;
        public var cancelable:Boolean;
        public var eventPhase:uint;
        public var currentTarget:Object;
        public var target:Object;

        protected var _preventDefault:Boolean = false;

        // Creates an Event object to pass as a parameter to event listeners.
        public function Event(t:String, bubble:Boolean = false, c:Boolean = false):void {
            
            type = t;
            bubbles = b;
            cancelable = c;

        }


        // Duplicates an instance of an Event subclass.
        public function clone():Event{
            //
        }
        
        // TODO :: missing the arguments splat
        // A utility function for implementing the toString() method in custom ActionScript 3.0 Event classes.
        public function formatToString(className:String):String {
            //
        }
        
        // Checks whether the preventDefault() method has been called on the event.
        public function isDefaultPrevented():Boolean {
            return _preventDefault;
        }
        
        // Cancels an event's default behavior if that behavior can be canceled.
        public function preventDefault():void {
            _preventDefault = true;
        }
        
        // Prevents processing of any event listeners in nodes subsequent to the current node in the event flow.
        public function stopPropagation():void {
            //
        }

        // Returns a string containing all the properties of the Event object.
        public function toString():String {
            //
        }



    }

}
