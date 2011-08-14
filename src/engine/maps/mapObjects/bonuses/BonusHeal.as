/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.bonuses {
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.ICollectableDynObject
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock

public class BonusHeal extends BonusBase implements ICollectableDynObject {

    public function BonusHeal(id:int, block:IMapBlock) {
        super(id, block)
    }

    public override function activateOn(player:IBomber, params:Object = null):void {
        super.activateOn(player)
        if (player.life < player.startLife)
            player.life += 5;
    }

    public function get type():IDynObjectType {
        return BonusType.HEAL;
    }


}
}