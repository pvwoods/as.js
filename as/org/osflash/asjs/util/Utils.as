package org.osflash.asjs.util {
    
    public class Utils {

        private static var _uid:uint = 0;

        public static function getUID():uint{
            _uid++;
            return _uid;
        }
    }

}
