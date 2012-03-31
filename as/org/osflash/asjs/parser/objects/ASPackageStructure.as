package org.osflash.asjs.parser.objects {

    public class ASPackageStructure {

        protected var _structure:Object;

        public function ASPackageStructure():void{
            _structure = {};
        }

        public function addToPackageStructure(entryClass:String){

            var steps = entryClass.split('.');
            var c = _structure;
            for(var i = 0; i < steps.length; i++){
                if(c[steps[i]] === undefined) c[steps[i]] = {};
                c = c[steps[i]];
            }
    
        }

        public function toJsonString():String{
            var s:String = "";
            for(var n:String in _structure){
                s += "var " + n + " = " + JSON.stringify(_structure[n]) + ";";
            }
            return s;
        }

        

    }

}
