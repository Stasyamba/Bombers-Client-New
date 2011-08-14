/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombss {
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.ITimeActivatableDynObject
import engine.maps.mapBlocks.NullMapBlock

public class NullBomb extends BombBase implements ITimeActivatableDynObject {

    private static var instance:NullBomb;

    public static function getInstance():NullBomb {
        if (instance == null)
            instance = new NullBomb();
        return instance;
    }

    public override function get timeToActivate():int {
        return 0
    }

    public override function addVictim(player:IBomber):void {
    }

    public override function get victim():IBomber {
        return null
    }

    public override function activateOn(player:IBomber, params:Object = null):void {
    }

    public override function grabCorrespondingWeapon():void {
    }

    public override function get owner():IBomber {
        return null
    }

    public override function get removeAfterActivation():Boolean {
        return true
    }

    function NullBomb() {
        super(-1, null, NullMapBlock.getInstance(), null)
    }

    public override function onTimeElapsed(elapsedMilliSecs:int):void {
    }

    public override function get type():IDynObjectType {
        return BombType.NULL;
    }

    public override function canExplosionGoThrough():Boolean {
        return true;
    }

    public override function canGoThrough():Boolean {
        return true;
    }

    public override function explodesAndStopsExplosion():Boolean {
        return false;
    }
}
}