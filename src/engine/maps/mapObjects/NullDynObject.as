/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects {
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.IDynObject
import engine.maps.interfaces.IDynObjectType
import engine.maps.mapBlocks.NullMapBlock

public class NullDynObject extends DynObjectBase implements IDynObject {

    private static var instance:NullDynObject;

    public function grabCorrespondingWeapon():void {
    }

    public function get removeAfterActivation():Boolean {
        return false
    }

    public static function getInstance():NullDynObject {
        if (instance == null)
            instance = new NullDynObject();
        return instance;
    }

    function NullDynObject() {
        super(-1, NullMapBlock.getInstance())
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

    public function get type():IDynObjectType {
        return DynObjectType.NULL;
    }

    public function activateOn(player:IBomber, params:Object = null):void {
    }

    public function tryToTake():void {
    }

    public function get wasTriedToBeTaken():Boolean {
        return false;
    }

}
}