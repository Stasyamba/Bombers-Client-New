/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.weapons {
import engine.EngineContext
import engine.bombers.interfaces.IBomber
import engine.bombss.BombType
import engine.model.managers.interfaces.IMapManager
import engine.weapons.interfaces.IActivatableWeapon

public class AtomBombWeapon extends ActivatableWeaponBase implements IActivatableWeapon {

    private var mapManager:IMapManager;

    public function AtomBombWeapon(mapManager:IMapManager, charges:int = 3) {
        super(charges)
        this.mapManager = mapManager;
    }

    public function activate(x:uint, y:uint, by:IBomber):void {
        if (!canActivate(x, y, by)) return;
        _charges--;
        EngineContext.triedToActivateWeapon.dispatch(by.slot, by.coords.getRealX(), by.coords.getRealY(), BombType.ATOM)
    }

    public function canActivate(x:uint, y:uint, by:IBomber):Boolean {
        if (!mapManager.canUseMap)
            return false;
        return _charges > 0 && mapManager.map.getBlock(x, y).canSetBomb();
    }

    public override function get type():WeaponType {
        return WeaponType.ATOM_BOMB_WEAPON;
    }


    public function activateStatic(x:int, y:int, by:IBomber):void {
    }

    public function qActivate(x:uint, y:uint, by:IBomber):void {
        _charges--
        qActivateStatic(x, y, by)
    }

    public function qActivateStatic(x:int, y:int, by:IBomber):void {
        EngineContext.qAddObject.dispatch(by.slot, x, y, BombType.ATOM, null)
    }
}
}