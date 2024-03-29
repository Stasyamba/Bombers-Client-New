/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.mapBlocks.mapBlockStates {
import engine.bombers.CreatureBase
import engine.maps.interfaces.IActiveMapBlockState
import engine.maps.interfaces.IDynObject
import engine.maps.mapBlocks.MapBlockType
import engine.maps.mapObjects.NullDynObject
import engine.model.explosionss.ExplosionType

public class GlueBlock implements IActiveMapBlockState {
    public function GlueBlock() {
    }

    public function activateOn(creature:CreatureBase):void {
        creature.setSpeed(20)
    }

    public function deactivateOn(creature:CreatureBase):void {
        creature.resetSpeed()
    }

    public function explodesAndStopsExplosion():Boolean {
        return false
    }

    public function canGoThrough(creature:CreatureBase = null):Boolean {
        return true
    }

    public function canSetBomb():Boolean {
        return true
    }

    public function canExplosionGoThrough():Boolean {
        return true
    }

    public function canHaveExplosionPrint(explType:ExplosionType):Boolean {
        return false
    }

    public function explode(expl:ExplosionType, damage:int = 0):void {
    }

    public function get type():MapBlockType {
        return MapBlockType.GLUE
    }

    public function stateAfterExplosion(expl:ExplosionType):MapBlockType {
        return MapBlockType.GLUE
    }

    public function get canShowObjects():Boolean {
        return true
    }

    public function get hiddenObject():IDynObject {
        return NullDynObject.getInstance();
    }

    public function set hiddenObject(value:IDynObject):void {
    }

    public function get blinks():Boolean {
        return false
    }

}
}
