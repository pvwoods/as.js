package flash.display{
    /** The InteractiveObject class is the abstract base class for all display objects with which the user can interact, using the mouse and keyboard. You cannot instantiate the InteractiveObject class directly. A call to the new InteractiveObject() constructor throws an ArgumentError exception.  The InteractiveObject class itself does not include any APIs for rendering content onscreen. For that reason, if you want create a custom subclass of the InteractiveObject class, you will want to extend one of its subclasses that do have APIs for rendering content onscreen, such as the Sprite, SimpleButton, TextField, or MovieClip class. */

    import flash.display.DisplayObject;

    public class InteractiveObject extends  DisplayObject {

        /** Specifies the context menu associated with this object. */
        public var contextMenu:NativeMenu;

        /** Specifies whether the object receives doubleClick events. */
        public var doubleClickEnabled:Boolean;

        /** Specifies whether this object displays a focus rectangle. */
        public var focusRect:Object;

        /** Specifies whether this object receives mouse messages. */
        public var mouseEnabled:Boolean;

        /** Specifies whether this object is in the tab order. */
        public var tabEnabled:Boolean;

        /** Specifies the tab ordering of objects in a SWF file. */
        public var tabIndex:int;

        /** Calling the new InteractiveObject() constructor throws an ArgumentError exception. */
        public function InteractiveObject(){
            //
        }

    }
}
