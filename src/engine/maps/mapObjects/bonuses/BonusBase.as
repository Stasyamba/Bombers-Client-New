/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.bonuses {
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.IMapBlock
import engine.maps.mapObjects.DynObjectBase

public class BonusBase extends DynObjectBase {

    private var _wasTriedToBeTaken:Boolean = false;

    public function BonusBase(id:int, block:IMapBlock) {
        super(id, block);
    }

    public function canExplosionGoThrough():Boolean {
        return true;
    }

    public function canGoThrough():Boolean {
        return true;
    }

    public function explodesAndStopsExplosion():Boolean {
        return false;
    }

    public function activateOn(player:IBomber, params:Object = null):void {
        block.collectObject(Context.game.playerManager.isItMe(player));
    }

    public function tryToTake():void {
        _wasTriedToBeTaken = true;
    }

    public function get wasTriedToBeTaken():Boolean {
        return _wasTriedToBeTaken;
    }

    public function grabCorrespondingWeapon():void {
    }

    public function get removeAfterActivation():Boolean {
        return true
    }
}
}