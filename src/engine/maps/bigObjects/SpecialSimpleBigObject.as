/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.bigObjects {
import engine.EngineContext
import engine.maps.IMap
import engine.maps.builders.DynObjectBuilder
import engine.maps.builders.MapBlockStateBuilder
import engine.model.explosionss.ExplosionType

public class SpecialSimpleBigObject extends SimpleBigObject {

    private var _explType:ExplosionType

    public function SpecialSimpleBigObject(xml:XML, map:IMap, mapBlockStateBuilder:MapBlockStateBuilder, mapObjectBuilder:DynObjectBuilder, life:int, explType:ExplosionType) {
        super(xml, map, mapBlockStateBuilder, mapObjectBuilder, life)
        _explType = explType;
        EngineContext.specialObjectExploded.add(onExploded)
    }

    private function onExploded(x:int,y:int, lifeLeft:int):void {
        explode(_explType,life - lifeLeft);
    }

    public override function explode(expl:ExplosionType, damage:int):void {
        if (expl != _explType) return;
        super.explode(expl, damage);
    }

    public function get explType():ExplosionType {
        return _explType
    }

    public static function asBox(id:int, x:int, y:int, graphicsId:String, life:int, map:IMap, mapBlockStateBuilder:MapBlockStateBuilder, dynObjectBuilder:DynObjectBuilder):SpecialSimpleBigObject {
        var xml:XML = getAsBoxXml();
        xml.@id = id
        xml.@x = x;
        xml.@y = y;
        xml.@graphicsId = graphicsId

        return new SpecialSimpleBigObject(xml, map, mapBlockStateBuilder, dynObjectBuilder, ExplosionType.DYNAMITE.damage * life, ExplosionType.DYNAMITE)
    }
}
}
