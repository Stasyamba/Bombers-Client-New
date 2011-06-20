package engine.maps.mapObjects.bonuses {
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.ICollectableDynObject
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock
import engine.weapons.WeaponType

public class BonusWeapon extends BonusBase implements ICollectableDynObject {

    private var _weapon:WeaponType

    public function BonusWeapon(block:IMapBlock, wt:WeaponType) {
        super(block);
        _weapon = wt;
    }

    public override function activateOn(player:IBomber):void {
        super.activateOn(player)
        player.addWeaponBonus(_weapon);
    }

    public function get type():IDynObjectType {
        return BonusType.WEAPON;
    }

    public function get weapon():WeaponType {
        return _weapon
    }
}
}
