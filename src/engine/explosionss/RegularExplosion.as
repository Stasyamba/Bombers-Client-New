/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.explosionss {
import engine.bombers.interfaces.IBomber
import engine.explosionss.interfaces.IExplosion
import engine.maps.IMap
import engine.maps.interfaces.IMapBlock
import engine.model.explosionss.ExplosionType
import engine.utils.Direction

public class RegularExplosion extends ExplosionBase implements IExplosion {

    protected var initialPower:int;
    protected var _damage:int = 5

    public function RegularExplosion(map:IMap, owner:IBomber, centerX:int = -1, centerY:int = -1, power:int = 0, lifetime:int = 0) {
        super(map, centerX, centerY, owner)
        timeToLive = lifetime > 0 ? lifetime : type.timeToLive
        this.initialPower = power;
    }

    protected function canExpand(dir:Direction, fromX:int, fromY:int):Boolean {

        var from:IMapBlock = map.getBlock(fromX, fromY);
        if (from.explodesAndStopsExplosion())
            return false;

        var b:IMapBlock = map.getNeighbour(fromX, fromY, dir);
        return b.canExplosionGoThrough();
    }


    protected function expand(toX:int, toY:int, direction:Direction, power:int):void {

        var willExpand:Boolean = canExpand(direction, toX, toY) && power > 0;

        var epType:ExplosionPointType = ExplosionPointType.getExplosionPointType(willExpand, direction);
        addPoint(new ExplosionPoint(toX, toY, epType, _owner, type));


        if (willExpand) {
            var to:IMapBlock = map.getNeighbour(toX, toY, direction)
            expand(to.x, to.y, direction, power - 1);
        }
    }


    public function perform():void {
        addPoint(new ExplosionPoint(centerX, centerY, ExplosionPointType.CROSS, _owner, type));

        if (canExpand(Direction.LEFT, centerX, centerY))
            expand(centerX - 1, centerY, Direction.LEFT, initialPower - 1);
        if (canExpand(Direction.RIGHT, centerX, centerY))
            expand(centerX + 1, centerY, Direction.RIGHT, initialPower - 1);
        if (canExpand(Direction.UP, centerX, centerY))
            expand(centerX, centerY - 1, Direction.UP, initialPower - 1);
        if (canExpand(Direction.DOWN, centerX, centerY))
            expand(centerX, centerY + 1, Direction.DOWN, initialPower - 1);
    }


    public function get type():ExplosionType {
        return ExplosionType.REGULAR;
    }

    public function set damage(value:int):void {
        _damage = value
    }

    public function get damage():int {
        return _damage;
    }


}
}