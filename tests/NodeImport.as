

package {
    
    public class NodeImport {

        public var files:fs = require("fs");

        public function NodeImport(){

            trace(files.readFileSync("app.js").toString());

        }

    }

}

