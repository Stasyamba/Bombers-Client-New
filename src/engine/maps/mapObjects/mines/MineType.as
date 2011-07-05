/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.mines {
import engine.maps.interfaces.IDynObjectType

import engine.maps.mapObjects.DynObjectType

import loading.LoaderUtils

public class MineType extends DynObjectType implements IDynObjectType {

    public static const REGULAR:MineType = new MineType(41, "REGULAR");

    public function MineType(value:int, key:String, swfClassName:String = null) {
        super(value, key, swfClassName)
    }


    public override function get waitToAdd():Number {
        return 2
    }

}
}
