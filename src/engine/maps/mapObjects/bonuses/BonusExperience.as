/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.bonuses {
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.ICollectableDynObject
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock

public class BonusExperience extends BonusBase implements ICollectableDynObject {

    private var _amount:int;

    public function BonusExperience(id:int, block:IMapBlock, amount:int) {
        super(id, block)
    }


    public override function activateOn(player:IBomber, params:Object = null):void {
        throw Context.Exception("Error in file BonusExperience.as: implement adding experience")
    }

    public function get type():IDynObjectType {
        return BonusType.EXPERIENCE;
    }

    public function get amount():int {
        return _amount;
    }
}
}
