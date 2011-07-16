/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.interfaces {
import engine.bombers.CreatureBase
import engine.maps.mapBlocks.MapBlockType
import engine.model.explosionss.ExplosionType

public interface IMapBlockState {

    function explodesAndStopsExplosion():Boolean

    function canGoThrough(creature:CreatureBase = null):Boolean;

    function canSetBomb():Boolean;

    function canExplosionGoThrough():Boolean

    function canHaveExplosionPrint(explType:ExplosionType):Boolean;

    function explode(expl:ExplosionType, damage:int = 0):void;

    function get type():MapBlockType;

    function stateAfterExplosion(expl:ExplosionType):MapBlockType;

    function get canShowObjects():Boolean;

    function get hiddenObject():IDynObject;

    function set hiddenObject(value:IDynObject):void ;

    function get blinks():Boolean
}
}