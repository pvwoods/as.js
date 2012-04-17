package flash.display {

    /** The DisplayObject class is the base class for all objects that can be placed on the display list. The display list manages all objects displayed in Flash Player or Adobe AIR. Use the DisplayObjectContainer class to arrange the display objects in the display list. DisplayObjectContainer objects can have child display objects, while other display objects, such as Shape and TextField objects, are "leaf" nodes that have only parents and siblings, no children. The DisplayObject class supports basic functionality like the x and y position of an object, as well as more advanced properties of the object such as its transformation matrix.  DisplayObject is an abstract base class; therefore, you cannot call DisplayObject directly. Invoking new DisplayObject() throws an ArgumentError exception.  All display objects inherit from the DisplayObject class.  The DisplayObject class itself does not include any APIs for rendering content onscreen. For that reason, if you want create a custom subclass of the DisplayObject class, you will want to extend one of its subclasses that do have APIs for rendering content onscreen, such as the Shape, Sprite, Bitmap, SimpleButton, TextField, or MovieClip class.  The DisplayObject class contains several broadcast events. Normally, the target of any particular event is a specific DisplayObject instance. For example, the target of an added event is the specific DisplayObject instance that was added to the display list. Having a single target restricts the placement of event listeners to that target and in some cases the target's ancestors on the display list. With broadcast events, however, the target is not a specific DisplayObject instance, but rather all DisplayObject instances, including those that are not on the display list. This means that you can add a listener to any DisplayObject instance to listen for broadcast events. In addition to the broadcast events listed in the DisplayObject class's Events table, the DisplayObject class also inherits two broadcast events from the EventDispatcher class: activate and deactivate .  Some properties previously used in the ActionScript 1.0 and 2.0 MovieClip, TextField, and Button classes (such as _alpha , _height , _name , _width , _x , _y , and others) have equivalents in the ActionScript 3.0 DisplayObject class that are renamed so that they no longer begin with the underscore (_) character.  For more information, see the "Display Programming" chapter of the Programming ActionScript 3.0 book. */

    import flash.events.EventDispatcher;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.display.DisplayObjectContainer;

    public class DisplayObject extends EventDispatcher {
        
        /** The current accessibility options for this display object. */
        public var accessibilityProperties:AccessibilityProperties;

        /** Indicates the alpha transparency value of the object specified. */
        public var alpha:Number;

        /** A value from the BlendMode class that specifies which blend mode to use. */
        public var blendMode:String;

        /** [write-only] Sets a shader that is used for blending the foreground and background. */
        public var blendShader:Shader;

        /** If set to true, Flash Player or Adobe AIR caches an internal bitmap representation of the display object. */
        public var cacheAsBitmap:Boolean;

        /** An indexed array that contains each filter object currently associated with the display object. */
        public var filters:Array;

        /** Indicates the height of the display object, in pixels. */
        public var height:Number;

        /** [read-only] Returns a LoaderInfo object containing information about loading the file to which this display object belongs. */
        public var loaderInfo:LoaderInfo;

        /** The calling display object is masked by the specified mask object. */
        public var mask:DisplayObject;

        /** [read-only] Indicates the x coordinate of the mouse position, in pixels. */
        public var mouseX:Number;

        /** [read-only] Indicates the y coordinate of the mouse position, in pixels. */
        public var mouseY:Number;

        /** Indicates the instance name of the DisplayObject. */
        public var name:String;

        /** Specifies whether the display object is opaque with a certain background color. */
        public var opaqueBackground:Object;

        /** [read-only] Indicates the DisplayObjectContainer object that contains this display object. */
        public var parent:DisplayObjectContainer;

        /** [read-only] For a display object in a loaded SWF file, the root property is the top-most display object in the portion of the display list's tree structure represented by that SWF file. */
        public var root:DisplayObject;

        /** Indicates the rotation of the DisplayObject instance, in degrees, from its original orientation. */
        public var rotation:Number;

        /** Indicates the x-axis rotation of the DisplayObject instance, in degrees, from its original orientation relative to the 3D parent container. */
        public var rotationX:Number;

        /** Indicates the y-axis rotation of the DisplayObject instance, in degrees, from its original orientation relative to the 3D parent container. */
        public var rotationY:Number;

        /** Indicates the z-axis rotation of the DisplayObject instance, in degrees, from its original orientation relative to the 3D parent container. */
        public var rotationZ:Number;

        /** The current scaling grid that is in effect. */
        public var scale9Grid:Rectangle;

        /** Indicates the horizontal scale (percentage) of the object as applied from the registration point. */
        public var scaleX:Number;

        /** Indicates the vertical scale (percentage) of an object as applied from the registration point of the object. */
        public var scaleY:Number;

        /** Indicates the depth scale (percentage) of an object as applied from the registration point of the object. */
        public var scaleZ:Number;

        /** The scroll rectangle bounds of the display object. */
        public var scrollRect:Rectangle;

        /** [read-only] The Stage of the display object. */
        public var stage:Stage;

        /** An object with properties pertaining to a display object's matrix, color transform, and pixel bounds. */
        public var transform:Transform;

        /** Whether or not the display object is visible. */
        public var visible:Boolean;

        /** Indicates the width of the display object, in pixels. */
        public var width:Number;

        /** Indicates the x coordinate of the DisplayObject instance relative to the local coordinates of the parent DisplayObjectContainer. */
        public var x:Number;

        /** Indicates the y coordinate of the DisplayObject instance relative to the local coordinates of the parent DisplayObjectContainer. */
        public var y:Number;

        /** Indicates the z coordinate position along the z-axis of the DisplayObject instance relative to the 3D parent container. */
        public var z:Number;

        /** Returns a rectangle that defines the area of the display object relative to the coordinate system of the targetCoordinateSpace object. */
        public function getBounds(targetCoordinateSpace:DisplayObject):Rectangle{
            //
        }

        /** Returns a rectangle that defines the boundary of the display object, based on the coordinate system defined by the targetCoordinateSpace parameter, excluding any strokes on shapes. */
        public function getRect(targetCoordinateSpace:DisplayObject):Rectangle{
            //
        }

        /** Converts the point object from the Stage (global) coordinates to the display object's (local) coordinates. */
        public function globalToLocal(point:Point):Point{
            //
        }

        /** Converts a two-dimensional point from the Stage (global) coordinates to a three-dimensional display object's (local) coordinates. */
        public function globalToLocal3D(point:Point):Vector3D{
            throw new Error("3d is not supported at this time");
        }

        /** Evaluates the bounding box of the display object to see if it overlaps or intersects with the bounding box of the obj display object. */
        public function hitTestObject(obj:DisplayObject):Boolean{
            //
        }

        /** Evaluates the display object to see if it overlaps or intersects with the point specified by the x and y parameters. */
        public function hitTestPoint(x:Number, y:Number, shapeFlag:Boolean= false):Boolean{
            //
        }

        /** Converts a three-dimensional point of the three-dimensional display object's (local) coordinates to a two-dimensional point in the Stage (global) coordinates. */
        public function local3DToGlobal(point3d:Vector3D):Point{
            throw new Error("3d is not supported at this time");
        }

        /** Converts the point object from the display object's (local) coordinates to the Stage (global) coordinates. */
        public function localToGlobal(point:Point):Point{
            //
        }

}
}
