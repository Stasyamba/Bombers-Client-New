/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.bombss {
import engine.bombers.interfaces.IBomber
import engine.explosionss.ExplosionsBuilder
import engine.explosionss.interfaces.IExplosion
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock
import engine.maps.interfaces.ITimeActivatableDynObject
import engine.model.explosionss.ExplosionType

public class DynamiteBomb extends BombBase implements ITimeActivatableDynObject {
    private static const EXPLODE_TIME:int = 2000;

    public function DynamiteBomb(id:int, explosionsBuilder:ExplosionsBuilder, block:IMapBlock, player:IBomber) {
        super(id, explosionsBuilder, block, player);
        _explodeTime = EXPLODE_TIME;
    }

    public override function get type():IDynObjectType {
        return BombType.DYNAMITE;
    }

    override protected function getExplosion(power:int = 0, lifetime:int = 0):IExplosion {
        return _explosionsBuilder.make(ExplosionType.DYNAMITE, owner, block.x, block.y, power != 0 ? power : 5 + _owner.bombPower, lifetime)
    }
}
}
