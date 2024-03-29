/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombss {
import engine.bombers.interfaces.IBomber;
import engine.explosionss.ExplosionsBuilder;
import engine.explosionss.interfaces.IExplosion;
import engine.maps.interfaces.IDynObjectType;
import engine.maps.interfaces.IMapBlock;
import engine.maps.interfaces.ITimeActivatableDynObject;
import engine.model.explosionss.ExplosionType;

import mx.controls.Alert;

public class RegularBomb extends BombBase implements ITimeActivatableDynObject {

    private static const EXPLODE_TIME:int = 2000;

    protected var _power:int;

    public function RegularBomb(id:int, explosionsBuilder:ExplosionsBuilder, block:IMapBlock, player:IBomber) {
        super(id, explosionsBuilder, block, player);
//		Alert.show("created: " + id);
        _power = player.bombPower;
        _explodeTime = EXPLODE_TIME;
    }

    public override function get type():IDynObjectType {
        return BombType.REGULAR;
    }

    public override function grabCorrespondingWeapon():void {
        owner.takeBomb()
    }

    override protected function getExplosion(power:int = 0, lifetime:int = 0):IExplosion {
        var act_power:int

        if (power > 0)
            act_power = power;
        else
            act_power = owner != null ? owner.bombPower : _power

        return _explosionsBuilder.make(ExplosionType.REGULAR, owner, block.x, block.y, act_power, lifetime)
    }

    override public function activateOn(player:IBomber, params:Object = null):void {
        super.activateOn(player, params)
        _owner.returnBomb();
    }
}
}