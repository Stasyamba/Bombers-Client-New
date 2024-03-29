/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.weapons {
import engine.EngineContext

public class ActivatableWeaponBase {
    protected var _charges:int;

    public function ActivatableWeaponBase(charges:int) {
        _charges = charges
    }

    public function get charges():int {
        return _charges
    }

    public function decCharges():void {
        _charges--
        trace("minus charges " + type.key + ", now " + _charges)
        EngineContext.weaponUnitSpent.dispatch(type)
    }
	
	public function incCharges():void {
		_charges++
		trace("+1 charges " + type.key + ", now " + _charges)
	}

    public function get type():WeaponType {
        throw Context.Exception("Error in file ActivatableWeaponBase.as: abstract method call")
    }
}
}
