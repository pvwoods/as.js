package {
    
    import HelloWorld;
    import com.asjs.math.SuperAdder;

    public class Imports {
        
        public var importClass:HelloWorld;
        public var adder:SuperAdder;

        public function Imports(){
            
            trace("creating a new instance of hello world");
            importClass = new HelloWorld();
            trace("creating a new SuperAdder and tracing solution");
            adder = new SuperAdder();
            adder.add(3);
            adder.add(17);
            trace(adder.result());


        }

    }

}

