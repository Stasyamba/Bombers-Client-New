package engine.explosionss {
import engine.bombers.interfaces.IBomber
import engine.maps.IMap
import engine.model.explosionss.ExplosionType

public class DynamiteExplosion extends RegularExplosion {

    public function DynamiteExplosion(map:IMap, owner:IBomber, centerX:int, centerY:int, power:int, lifetime:int) {
        super(map, owner, centerX, centerY, power, lifetime)
        damage = 15;
    }

    override public function get type():ExplosionType {
        return ExplosionType.DYNAMITE
    }
}
}
