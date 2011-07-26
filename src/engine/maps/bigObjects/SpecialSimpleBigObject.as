/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.bigObjects {
import engine.maps.IMap
import engine.maps.builders.DynObjectBuilder
import engine.maps.builders.MapBlockStateBuilder
import engine.model.explosionss.ExplosionType

public class SpecialSimpleBigObject extends SimpleBigObject {

    private var _explType:ExplosionType

    public function SpecialSimpleBigObject(xml:XML, map:IMap, mapBlockStateBuilder:MapBlockStateBuilder, mapObjectBuilder:DynObjectBuilder, life:int, explType:ExplosionType) {
        super(xml, map, mapBlockStateBuilder, mapObjectBuilder, life)
        _explType = explType;
    }

    public override function explode(expl:ExplosionType, damage:int):void {
        if (expl != _explType) return;
        super.explode(expl, damage);
    }

    public function get explType():ExplosionType {
        return _explType
    }
}
}
