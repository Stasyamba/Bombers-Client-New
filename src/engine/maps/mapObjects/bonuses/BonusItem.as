package engine.maps.mapObjects.bonuses {
import components.common.items.ItemType

import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.ICollectableDynObject
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock
import engine.weapons.WeaponType

public class BonusItem extends BonusBase implements ICollectableDynObject {

    private var _weapon:ItemType
    private var _count:int;

    public function BonusItem(block:IMapBlock, wt:ItemType, count:int) {
        super(block);
        _weapon = wt;
        _count = count
    }

    public override function activateOn(player:IBomber, params:Object = null):void {
        super.activateOn(player)
        player.addItemBonus(_weapon, _count);
    }

    public function get type():IDynObjectType {
        return BonusType.ITEM;
    }

    public function get weapon():ItemType {
        return _weapon
    }

    public function get count():int {
        return _count
    }
}
}
