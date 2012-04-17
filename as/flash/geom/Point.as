package flash.geom {
    /** The Point object represents a location in a two-dimensional coordinate system, where x represents the horizontal axis and y represents the vertical axis. The following code creates a point at (0,0): */
    public class Point {

        /** [read-only] The length of the line segment from (0,0) to this point. */
        public var length:Number;

        /** The horizontal coordinate of the point. */
        public var x:Number;

        /** The vertical coordinate of the point. */
        public var y:Number;

        /** Creates a new point. */
        public function Point(_x:Number= 0, _y:Number= 0){
            x = _x;
            y = _y;
            length = Math.sqrt(x * x + y * y);
        }

        /** Adds the coordinates of another point to the coordinates of this point to create a new point. */
        public function add(v:Point):Point{
            var p:Point = new Point();
            p.x = x + v.x;
            p.y = y + v.y;
            return p;
        }

        /** Creates a copy of this Point object. */
        public function clone():Point{
            var p:Point = new Point(x, y);
            return p;
        }

        /** [static] Returns the distance between pt1 and pt2. */
        //public static function distance(pt1:Point, pt2:Point):Number;

        /** Determines whether two points are equal. */
        public function equals(toCompare:Point):Boolean{
            return toCompare.x === x && toCompare.y === y;
        }

        /** [static] Determines a point between two specified points. */
        //public static function interpolate(pt1:Point, pt2:Point, f:Number):Point;

        /** Scales the line segment between (0,0) and the current point to a set length. */
        public function normalize(thickness:Number):void{
            var norm:Number = Math.sqrt(x * x + y * y);
            if (norm != 0) {
                x = scale * x / norm;
                y = scale * y / norm;
            }
        }

        /** Offsets the Point object by the specified amount. */
        public function offset(dx:Number, dy:Number):void{
            //
        }

        /** [static] Converts a pair of polar coordinates to a Cartesian point coordinate. */
        //public static function polar(len:Number, angle:Number):Point;

        /** Subtracts the coordinates of another point from the coordinates of this point to create a new point. */
        public function subtract(v:Point):Point{
            var p:Point = new Point();
            p.x = x - v.x;
            p.y = y - v.y;
            return p;
        }

        /** Returns a string that contains the values of the x and y coordinates. */
        public function toString():String{
            return x + ", " + y;
        }

    }
}
