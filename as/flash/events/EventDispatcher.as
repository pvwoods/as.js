package flash.events {

    import flash.events.Event;

    public class EventDispatcher {

        protected var _events:Object;

        public function EventDispatcher(target:EventDispatcher = null){
            _events = {};
        }
        
        // weak refs do not exist as of now
        public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
            if(_events[type] === undefined) _events[type] = [];
            _events[type].push(listener);
        }

        public function dispatchEvent(event:Event):Boolean {
            if(_events[event.type] !== undefined){
                var e:Array = _events[event.type];
                for(var f:Function in e){
                    e[f](event);
                }
            }
        }

        public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
            if(_events[type] !== undefined){
                var index:uint = _events[type].indexOf(listener);
                if(index != -1) _events[type] = _events[type].splice(index, 1);
            }
        }

        public function willTrigger(type:String):Boolean {
            //
        }

    }

}

