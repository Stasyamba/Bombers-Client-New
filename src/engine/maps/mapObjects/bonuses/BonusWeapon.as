package engine.maps.mapObjects.bonuses {
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.ICollectableDynObject
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock
import engine.weapons.WeaponType

public class BonusWeapon extends BonusBase implements ICollectableDynObject {

    private var _weapon:WeaponType
    private var _count:int;

    public function BonusWeapon(block:IMapBlock, wt:WeaponType, count:int) {
        super(block);
        _weapon = wt;
        _count = count
    }

    public override function activateOn(player:IBomber, params:Object = null):void {
        super.activateOn(player)
        player.addWeaponBonus(_weapon,_count);
    }

    public function get type():IDynObjectType {
        return BonusType.WEAPON;
    }

    public function get weapon():WeaponType {
        return _weapon
    }

    public function get count():int {
        return _count
    }
}
}
