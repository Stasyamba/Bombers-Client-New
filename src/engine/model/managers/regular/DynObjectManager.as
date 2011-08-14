/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.managers.regular {
import engine.EngineContext
import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.ICollectableDynObject
import engine.maps.interfaces.IDynObject
import engine.maps.interfaces.IMapBlock
import engine.maps.interfaces.ITimeActivatableDynObject
import engine.model.explosionss.ExplosionType
import engine.model.managers.interfaces.IDynObjectManager
import engine.model.managers.interfaces.IMapManager
import engine.model.managers.interfaces.IPlayerManager

import greensock.TweenMax

import mx.collections.ArrayList
import mx.controls.Alert

public class DynObjectManager implements IDynObjectManager {

    protected var playerManager:IPlayerManager;
    protected var mapManager:IMapManager;

    protected var _objects:ArrayList = new ArrayList();

    public function DynObjectManager(playerManager:IPlayerManager, mapManager:IMapManager) {
        this.playerManager = playerManager;
        this.mapManager = mapManager;
    }

    public function checkObjectsActivated(elapsedMilliSecs:int):void {
        var l:int = _objects.length;
        for (var i:int = 0; i < l; i++) {
            var object:IDynObject = _objects.getItemAt(i) as IDynObject;
            if (object is ICollectableDynObject)
                checkCollectableObject(object as ICollectableDynObject)
            if (object is ITimeActivatableDynObject)
                checkTimeActivatedObject(object as ITimeActivatableDynObject, elapsedMilliSecs)
            if (l > _objects.length) {
                i--;
                l--
            }
        }
    }

    private function checkCollectableObject(object:ICollectableDynObject):void {
        if (playerManager.checkPlayerMetObject(object)) {
            if (!object.wasTriedToBeTaken) {
                object.tryToTake();
                EngineContext.triedToActivateObject.dispatch(object);
            }
        }
    }

    public function addObject(object:IDynObject):void {
        _objects.addItem(object);
        trace("added")
    }

    public function activateObject(x:int, y:int, player:IBomber, params:Object = null):void {
        var object:IDynObject = getObjectAt(x, y);
        if (object == null) {
            throw Context.Exception("SERVER ERROR: No object to activate at (" + x + "," + y + ").")
//            return;
        }
        object.activateOn(player, params)

        if (object.removeAfterActivation)
            _objects.removeItem(object);
        trace("removed at " + x + "," + y);

    }


    public function activateObjectById(id:int, player:IBomber, params:Object = null):void {
//        Alert.show("activated: " + id);
        var object:IDynObject = getObjectById(id);
        if (object == null) {
            throw Context.Exception("SERVER ERROR: No object to activate with id = " + id);
//            return;
        }
        object.activateOn(player, params)

        if (object.removeAfterActivation)
            _objects.removeItem(object);
    }

    private function getObjectById(id:int):IDynObject {
        for each (var object:IDynObject in _objects.source) {
            if (id == object.id)
                return object;
        }
        return null
    }

    protected function getObjectAt(x:int, y:int):IDynObject {
        for each (var object:IDynObject in _objects.source) {
            if (x == object.x && y == object.y)
                return object;
        }
        return null
    }

    private function checkTimeActivatedObject(object:ITimeActivatableDynObject, elapsedMilliSecs:int):void {
        object.onTimeElapsed(elapsedMilliSecs);
    }

    public function explodeBlock(x:int, y:int, etype:ExplosionType, damage:int):void {
        var bb:IMapBlock = mapManager.map.getBlock(x, y)
        bb.explode(etype, damage)
        TweenMax.delayedCall(etype.timeToLive / 1000, bb.stopExplosion)
    }
}
}

import engine.model.explosionss.ExplosionType

class DestroyListEntry {

    public function DestroyListEntry(x:int, y:int, explType:ExplosionType) {
        this.x = x
        this.y = y
        this.explType = explType
    }

    public var x:int
    public var y:int
    public var explType:ExplosionType;


}