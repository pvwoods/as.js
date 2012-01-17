package org.osflash.asjs.parser.objects {

    public class ASObject {

        public var id:String;

        public function ASObject(){

            id = getUniqueParserId();

        }

        protected function getUniqueParserId():String{
            var pattern:Array = ('xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx').split('');
            for(var i:uint = 0; i < pattern.length; i++){
                var r:int = Math.random()*16|0;
                if(pattern[i] == 'x'){
                    pattern[i] = r.toString(16);
                }else if(pattern[i] == 'y'){
                    pattern[i] = (r&0x3|0x8).toString(16);
                }
            }
            return pattern.join('');
        }

    }

}
