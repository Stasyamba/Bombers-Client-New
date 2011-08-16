/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.mines {
import engine.bombers.interfaces.IBomber
import engine.bombers.interfaces.IPlayerBomber
import engine.explosionss.RegularExplosion
import engine.maps.interfaces.ICollectableDynObject
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock
import engine.maps.mapObjects.DynObjectBase
import engine.weapons.WeaponType

public class RegularMine extends DynObjectBase implements ICollectableDynObject {

    private var _owner:IBomber

    private var _wasTriedToBeTaken:Boolean = false;

    private static const DAMAGE:int = 15

    public function RegularMine(id:int, block:IMapBlock, owner:IBomber) {
        super(id, block)
        _owner = owner
    }

    public function grabCorrespondingWeapon():void {
        if (_owner is IPlayerBomber)
            Context.game.playerManager.me.decWeapon(WeaponType.byValue(type.value))
    }

    public function get removeAfterActivation():Boolean {
        return true
    }

    public function canExplosionGoThrough():Boolean {
        return true
    }

    public function canGoThrough():Boolean {
        return true
    }

    public function explodesAndStopsExplosion():Boolean {
        return false
    }

    public function get type():IDynObjectType {
        return MineType.REGULAR;
    }

    public function activateOn(player:IBomber, params:Object = null):void {
        if (!player.isImmortal) {
            var e:RegularExplosion = new RegularExplosion(null, null, -1, -1, 1)
            e.damage = DAMAGE;
            player.explode(e);
        }
        block.collectObject(Context.game.playerManager.isItMe(player))
    }

    public function tryToTake():void {
        _wasTriedToBeTaken = true;
    }

    public function get wasTriedToBeTaken():Boolean {
        return _wasTriedToBeTaken;
    }

    public function get owner():IBomber {
        return _owner
    }


}
}
