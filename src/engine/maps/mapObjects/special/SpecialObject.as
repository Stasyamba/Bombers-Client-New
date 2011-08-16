/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.special {
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.ICollectableDynObject
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock
import engine.maps.mapObjects.bonuses.BonusBase

public class SpecialObject extends BonusBase implements ICollectableDynObject {

    private var _type:IDynObjectType

    public function SpecialObject(id:int, block:IMapBlock, type:SpecialObjectType) {
        super(id, block);
        _type = type
    }

    public override function activateOn(player:IBomber, params:Object = null):void {
        super.activateOn(player)
    }

    public function get type():IDynObjectType {
        return _type;
    }

}
}
