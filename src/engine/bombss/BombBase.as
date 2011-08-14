/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombss {
import engine.bombers.interfaces.IBomber
import engine.explosionss.ExplosionsBuilder
import engine.explosionss.interfaces.IExplosion
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock
import engine.maps.mapObjects.DynObjectBase
import engine.weapons.WeaponType

public class BombBase extends DynObjectBase {

    public function BombBase(id:int, explosionsBuilder:ExplosionsBuilder, block:IMapBlock, owner:IBomber) {
        super(id, block)
        _owner = owner;
        _explosionsBuilder = explosionsBuilder;
    }

    protected var _explodeTime:int;
    protected var _owner:IBomber;
    protected var _explosionsBuilder:ExplosionsBuilder;

    public function canExplosionGoThrough():Boolean {
        return true;
    }

    public function canGoThrough():Boolean {
        return false;
    }

    public function explodesAndStopsExplosion():Boolean {
        return false;
    }

    public function onTimeElapsed(elapsedMilliSecs:int):void {
        _explodeTime -= elapsedMilliSecs;
    }

    public function get timeToActivate():int {
        return _explodeTime;
    }

    public function get owner():IBomber {
        return _owner;
    }

    public function get removeAfterActivation():Boolean {
        return true
    }

    public function grabCorrespondingWeapon():void {
        if (Context.game.playerManager.isItMe(_owner))
            Context.game.playerManager.me.decWeapon(WeaponType.byValue(type.value))
    }

    public function activateOn(player:IBomber, params:Object = null):void {
        var expl:IExplosion = params != null ? getExplosion(params["power"], params["lifetime"]) : getExplosion()
        expl.perform();
        Context.game.explosionExchangeBuffer.push(expl)

        block.collectObject(false)

    }

    public function get type():IDynObjectType {
        throw Context.Exception("Error in file BombBase.as: abstract method call")
    }

    protected function getExplosion(power:int = 0, lifetime:int = 0):IExplosion {
        throw Context.Exception("Error in file BombBase.as: abstract method call")
    }

    public function addVictim(player:IBomber):void {
    }

    public function get victim():IBomber {
        return null
    }
}
}