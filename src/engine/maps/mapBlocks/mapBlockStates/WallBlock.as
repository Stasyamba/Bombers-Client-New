/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapBlocks.mapBlockStates {
import engine.bombers.CreatureBase
import engine.maps.interfaces.IDynObject
import engine.maps.interfaces.IMapBlockState
import engine.maps.mapBlocks.MapBlockType
import engine.maps.mapObjects.NullDynObject
import engine.model.explosionss.ExplosionType

public class WallBlock implements IMapBlockState {
    public function WallBlock() {
    }

    public function explodesAndStopsExplosion():Boolean {
        return false;
    }

    public function get type():MapBlockType {
        return MapBlockType.WALL;
    }

    public function canGoThrough(creature:CreatureBase = null):Boolean {
        return false;
    }

    public function canSetBomb():Boolean {
        return false;
    }

    public function canExplosionGoThrough():Boolean {
        return false;
    }

    public function stateAfterExplosion(expl:ExplosionType):MapBlockType {
        if (expl == ExplosionType.ATOM)
            return MapBlockType.FREE;
        return MapBlockType.WALL;
    }

    public function explode(expl:ExplosionType, damage:int = 0):void {
        //do nothing, this is a wall dude
        // atom explosion makes it free so do nothing either
    }

    public function get canShowObjects():Boolean {
        return false;
    }

    public function canHaveExplosionPrint(explType:ExplosionType):Boolean {
        return (explType == ExplosionType.ATOM)
    }

    public function get hiddenObject():IDynObject {
        return NullDynObject.getInstance();
    }

    public function set hiddenObject(value:IDynObject):void {
    }

    public function get blinks():Boolean {
        return true
    }

}
}