package flash.geom {
    /** A Rectangle object is an area defined by its position, as indicated by its top-left corner point ( x , y ) and by its width and its height. The x , y , width , and height properties of the Rectangle class are independent of each other; changing the value of one property has no effect on the others. However, the right and bottom properties are integrally related to those four properties. For example, if you change the value of the right property, the value of the width property changes; if you change the bottom property, the value of the height property changes.  The following methods and properties use Rectangle objects:   The applyFilter() , colorTransform() , copyChannel() , copyPixels() , draw() , fillRect() , generateFilterRect() , getColorBoundsRect() , getPixels() , merge() , paletteMap() , pixelDisolve() , setPixels() , and threshold() methods, and the rect property of the BitmapData class  The getBounds() and getRect() methods, and the scrollRect and scale9Grid properties of the DisplayObject class  The getCharBoundaries() method of the TextField class  The pixelBounds property of the Transform class  The bounds parameter for the startDrag() method of the Sprite class  The printArea parameter of the addPage() method of the PrintJob class   You can use the new Rectangle() constructor to create a Rectangle object.   Note: The Rectangle class does not define a rectangular Shape display object. To draw a rectangular Shape object onscreen, use the drawRect() method of the Graphics class. */

    import flash.geom.Point;

    public class Rectangle {

        /** The sum of the y and height properties. */
        public var bottom:Number;

        /** The location of the Rectangle object's bottom-right corner, determined by the values of the right and bottom properties. */
        public var bottomRight:Point;

        /** The height of the rectangle, in pixels. */
        public var height:Number;

        /** The x coordinate of the top-left corner of the rectangle. */
        public var left:Number;

        /** The sum of the x and width properties. */
        public var right:Number;

        /** The size of the Rectangle object, expressed as a Point object with the values of the width and height properties. */
        public var size:Point;

        /** The y coordinate of the top-left corner of the rectangle. */
        public var top:Number;

        /** The location of the Rectangle object's top-left corner, determined by the x and y coordinates of the point. */
        public var topLeft:Point;

        /** The width of the rectangle, in pixels. */
        public var width:Number;

        /** The x coordinate of the top-left corner of the rectangle. */
        public var x:Number;

        /** The y coordinate of the top-left corner of the rectangle. */
        public var y:Number;

        /** Creates a new Rectangle object with the top-left corner specified by the x and y parameters and with the specified width and height parameters. */
        public function Rectangle(x:Number= 0, y:Number= 0, width:Number= 0, height:Number= 0):void{
            //
        }

        /** Returns a new Rectangle object with the same values for the x, y, width, and height properties as the original Rectangle object. */
        public function clone():Rectangle{
            //
        }

        /** Determines whether the specified point is contained within the rectangular region defined by this Rectangle object. */
        public function contains(x:Number, y:Number):Boolean{
            //
        }

        /** Determines whether the specified point is contained within the rectangular region defined by this Rectangle object. */
        public function containsPoint(point:Point):Boolean{
            //
        }

        /** Determines whether the Rectangle object specified by the rect parameter is contained within this Rectangle object. */
        public function containsRect(rect:Rectangle):Boolean{
            //
        }

        /** Determines whether the object specified in the toCompare parameter is equal to this Rectangle object. */
        public function equals(toCompare:Rectangle):Boolean{
            //
        }

        /** Increases the size of the Rectangle object by the specified amounts, in pixels. */
        public function inflate(dx:Number, dy:Number):void{
            //
        }

        /** Increases the size of the Rectangle object. */
        public function inflatePoint(point:Point):void{
            //
        }

        /** If the Rectangle object specified in the toIntersect parameter intersects with this Rectangle object, returns the area of intersection as a Rectangle object. */
        public function intersection(toIntersect:Rectangle):Rectangle{
            //
        }

        /** Determines whether the object specified in the toIntersect parameter intersects with this Rectangle object. */
        public function intersects(toIntersect:Rectangle):Boolean{
            //
        }

        /** Determines whether or not this Rectangle object is empty. */
        public function isEmpty():Boolean{
            //
        }

        /** Adjusts the location of the Rectangle object, as determined by its top-left corner, by the specified amounts. */
        public function offset(dx:Number, dy:Number):void{
            //
        }

        /** Adjusts the location of the Rectangle object using a Point object as a parameter. */
        public function offsetPoint(point:Point):void{
            //
        }

        /** Sets all of the Rectangle object's properties to 0. */
        public function setEmpty():void{
            //
        }

        /** Builds and returns a string that lists the horizontal and vertical positions and the width and height of the Rectangle object. */
        public function toString():String{
            //
        }

        /** Adds two rectangles together to create a new Rectangle object, by filling in the horizontal and vertical space between the two rectangles. */
        public function union(toUnion:Rectangle):Rectangle{
            //
        }

    }
}
