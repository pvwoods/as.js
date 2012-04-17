package flash.display {

    /** The DisplayObjectContainer class is the base class for all objects that can serve as display object containers on the display list. The display list manages all objects displayed in Flash Player or Adobe AIR. Use the DisplayObjectContainer class to arrange the display objects in the display list. Each DisplayObjectContainer object has its own child list for organizing the z-order of the objects. The z-order is the front-to-back order that determines which object is drawn in front, which is behind, and so on. DisplayObject is an abstract base class; therefore, you cannot call DisplayObject directly. Invoking new DisplayObject() throws an ArgumentError exception. The DisplayObjectContainer class is an abstract base class for all objects that can contain child objects. It cannot be instantiated directly; calling the new DisplayObjectContainer() constructor throws an ArgumentError exception. For more information, see the "Display Programming" chapter of the Programming ActionScript 3.0 book. */

    import flash.display.InteractiveObject;
    import flash.display.DisplayObject;
    import flash.geom.Point;
    
    public class DisplayObjectContainer extends  InteractiveObject {
    
        /** Determines whether or not the children of the object are mouse enabled. */
        public var mouseChildren:Boolean;

        /** [read-only] Returns the number of children of this object. */
        public var numChildren:int;

        /** Determines whether the children of the object are tab enabled. */
        public var tabChildren:Boolean;

        /** [read-only] Returns a TextSnapshot object for this DisplayObjectContainer instance. */
        public var textSnapshot:TextSnapshot;

        protected var _displayList:Array;

        /** Calling the new DisplayObjectContainer() constructor throws an ArgumentError exception. */
        public function DisplayObjectContainer(){
            _displayList = [];
        }

        /** Adds a child DisplayObject instance to this DisplayObjectContainer instance. */
        public function addChild(child:DisplayObject):DisplayObject{
            _displayList.push(child);
        }

        /** Adds a child DisplayObject instance to this DisplayObjectContainer instance. */
        public function addChildAt(child:DisplayObject, index:int):DisplayObject{
            if(index < _displayList.length){
                _displayList[index] = child;
            }else{
                throw new Error("The supplied index is out of bounds.");
            }
        }

        /** Indicates whether the security restrictions would cause any display objects to be omitted from the list returned by calling the DisplayObjectContainer.getObjectsUnderPoint() method with the specified point point. */
        public function areInaccessibleObjectsUnderPoint(point:Point):Boolean{
            //return getObjectsUnderPoint(point).length >= 1;
            return false;
        }

        /** Determines whether the specified display object is a child of the DisplayObjectContainer instance or the instance itself. */
        public function contains(child:DisplayObject):Boolean{
            return _displayList.indexOf(child) > -1;
        }

        /** Returns the child display object instance that exists at the specified index. */
        public function getChildAt(index:int):DisplayObject{
            return _displayList[index];
        }

        /** Returns the child display object that exists with the specified name. */
        public function getChildByName(name:String):DisplayObject{
            //
        }

        /** Returns the index position of a child DisplayObject instance. */
        public function getChildIndex(child:DisplayObject):int{
            return _displayList.indexOf(child);
        }

        /** Returns an array of objects that lie under the specified point and are children (or grandchildren, and so on) of this DisplayObjectContainer instance. */
        public function getObjectsUnderPoint(point:Point):Array{
            //
        }

        /** Removes the specified child DisplayObject instance from the child list of the DisplayObjectContainer instance. */
        public function removeChild(child:DisplayObject):DisplayObject{
            var i:int = _displayList.indexOf(i);
            if(i != -1) return removeChildAt(i);
            return null;
        }

        /** Removes a child DisplayObject from the specified index position in the child list of the DisplayObjectContainer. */
        public function removeChildAt(index:int):DisplayObject{
            return _displayList.splice(i, 1);
        }

        /** Changes the  position of an existing child in the display object container. */
        public function setChildIndex(child:DisplayObject, index:int):void{
            var newIndex:int = _displayList.indexOf(child);
            if(newIndex != -1){
               var temp:DisplayObject = _displayList.splice(newIndex, 1);
               _displayList.splice(index, 0, temp);
            }
        }

        /** Swaps the z-order (front-to-back order) of the two specified child objects. */
        public function swapChildren(child1:DisplayObject, child2:DisplayObject):void{
            
            var c1i:int = getChildIndex(child1);
            var c2i:int = getChildIndex(child2);

            if(c1i + c2i >= 1){
                swapChildrenAt(c1i, c2i);
            }

        }

        /** Swaps the z-order (front-to-back order) of the child objects at the two specified index positions in the child list. */
        public function swapChildrenAt(index1:int, index2:int):void{
            var temp:DisplayObject = _displayList[index1];
            _displayList[index1] = _displayList[index2];
            _displayList[index2] = temp;
        }

    }
}
