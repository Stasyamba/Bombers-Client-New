/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapBlocks.mapBlockStates {
import engine.bombers.CreatureBase
import engine.maps.bigObjects.BigObjectBase
import engine.maps.bigObjects.SimpleBigObject
import engine.maps.interfaces.IDynObject
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlockState
import engine.maps.mapBlocks.MapBlockType
import engine.maps.mapObjects.NullDynObject
import engine.model.explosionss.ExplosionType

public class BlockUnderBigObject implements IMapBlockState {

    private var _explodesAndStopsExplosion:Boolean;
    private var _canGoThrough:Boolean;
    private var _canSetBomb:Boolean;
    private var _canExplosionGoThrough:Boolean;
    private var _typeAfterObjectDestroyed:MapBlockType;
    private var _objectAfterObjectDestroyed:IDynObjectType;

    private var objectUnder:BigObjectBase;
    private var _explodes:Boolean;

    private var _hiddenObject:IDynObject;

    public function explodesAndStopsExplosion():Boolean {
        return _explodesAndStopsExplosion;
    }

    public function canGoThrough(creature:CreatureBase = null):Boolean {
        return _canGoThrough;
    }

    public function canSetBomb():Boolean {
        return _canSetBomb;
    }

    public function canExplosionGoThrough():Boolean {
        return _canExplosionGoThrough;
    }

    public function canHaveExplosionPrint(explType:ExplosionType):Boolean {
        return false;
    }

    public function explode(expl:ExplosionType, damage:int = 0):void {
        if (_explodes)
            (objectUnder as SimpleBigObject).explode(expl, damage);
    }

    public function get type():MapBlockType {
        return MapBlockType.UNDER_BIG_OBJECT;
    }

    public function stateAfterExplosion(expl:ExplosionType):MapBlockType {
        return MapBlockType.UNDER_BIG_OBJECT;
    }

    public function get canShowObjects():Boolean {
        return false;
    }

    public function get hiddenObject():IDynObject {
        return _hiddenObject
    }

    public function set hiddenObject(value:IDynObject):void {
        _hiddenObject = value;
    }

    public function BlockUnderBigObject(explodesAndStopsExplosion:Boolean, canGoThrough:Boolean, canSetBomb:Boolean, canExplosionGoThrough:Boolean, typeAfterObjectDestroyed:MapBlockType, objectAfterObjectDestroyed:IDynObjectType, explodes:Boolean, objectUnder:BigObjectBase) {
        _explodesAndStopsExplosion = explodesAndStopsExplosion;
        _canGoThrough = canGoThrough;
        _canSetBomb = canSetBomb;
        _canExplosionGoThrough = canExplosionGoThrough;
        _explodes = explodes;
        _typeAfterObjectDestroyed = typeAfterObjectDestroyed;
        _objectAfterObjectDestroyed = objectAfterObjectDestroyed;
        this.objectUnder = objectUnder;
    }

    public function get typeAfterObjectDestroyed():MapBlockType {
        return _typeAfterObjectDestroyed;
    }

    public function get objectAfterObjectDestroyed():IDynObjectType {
        return _objectAfterObjectDestroyed;
    }

    public function get blinks():Boolean {
        return true
    }

    public function set objectAfterObjectDestroyed(value:IDynObjectType):void {
        _objectAfterObjectDestroyed = value
    }
}
}
