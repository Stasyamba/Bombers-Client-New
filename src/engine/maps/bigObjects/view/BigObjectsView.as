/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.bigObjects.view {
import engine.interfaces.IDrawable;
import engine.maps.IMap;
import engine.maps.bigObjects.BigObjectBase;

import flash.display.DisplayObject

import flash.display.Sprite;

public class BigObjectsView extends Sprite implements IDrawable {

    private var map:IMap;
    private var isHigher:Boolean;


    public function BigObjectsView(map:IMap, isHigher:Boolean) {
        this.map = map;
        this.isHigher = isHigher;

        for each (var obj:BigObjectBase in getObjects()) {
            addChild(BigObjectViewFactory.make(obj));
        }
    }

    public function draw():void {
        for (var i:int = 0; i < numChildren; i++) {
            var child:IDrawable = getChildAt(i) as IDrawable;
            child.draw();
        }
    }

    public function getObjects():Vector.<BigObjectBase> {
        return isHigher ? map.higherBigObjects : map.lowerBigObjects
    }
}
}
