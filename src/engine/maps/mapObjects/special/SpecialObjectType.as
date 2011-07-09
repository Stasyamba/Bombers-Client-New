/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.special {
import engine.maps.interfaces.IDynObjectType

import engine.maps.mapObjects.DynObjectType

import loading.LoaderUtils

public class SpecialObjectType extends DynObjectType implements IDynObjectType {

    public static const VIOLET_MUSHROOM:SpecialObjectType = new SpecialObjectType(1011, "VIOLET_MUSHROOM");
    public static const GREEN_MUSHROOM:SpecialObjectType = new SpecialObjectType(1012, "GREEN_MUSHROOM","GreenMarshrum");
    public static const RED_MUSHROOM:SpecialObjectType = new SpecialObjectType(1013, "RED_MUSHROOM");


    public function SpecialObjectType(value:int, key:String, swfClassName:String = null) {
        super(value, key, swfClassName)
    }

    public static function byValue(value:int):SpecialObjectType {
        switch (value) {
            case VIOLET_MUSHROOM.value:
                return VIOLET_MUSHROOM;
            case GREEN_MUSHROOM.value:
                return GREEN_MUSHROOM;
            case RED_MUSHROOM.value:
                return RED_MUSHROOM;
        }
        throw Context.Exception("Îרטבךא ג פאיכו SpecialObjectType.as: wrong special object type value " + int)
    }


}
}
