/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombss {
import engine.maps.interfaces.IDynObjectType
import engine.maps.mapObjects.DynObjectType

public class BombType extends DynObjectType implements IDynObjectType {

    public static const NULL:BombType = new BombType(-1, "NULL", false);
    public static const REGULAR:BombType = new BombType(00, "REGULAR", true);
    public static const ATOM:BombType = new BombType(01, "ATOM", false);
    public static const BOX:BombType = new BombType(02, "BOX", false);
    public static const DYNAMITE:BombType = new BombType(03, "DYNAMITE", false);
    public static const SMOKE:BombType = new BombType(04, "SMOKE", false);

    private var _needGlow:Boolean;


    public function BombType(value:int, key:String, needGlow:Boolean, swfClassName:String = null) {
        super(value, key, swfClassName)
        _needGlow = needGlow
    }


    public function get needGlow():Boolean {
        return _needGlow;
    }

    public static function byValue(value:int):BombType {
        switch (value) {
            case NULL.value:
                return NULL;
            case REGULAR.value:
                return REGULAR;
            case ATOM.value:
                return ATOM;
            case BOX.value:
                return BOX;
            case DYNAMITE.value:
                return DYNAMITE;
            case SMOKE.value:
                return SMOKE
        }
        throw new ArgumentError("wrong bombType value");
    }

}
}