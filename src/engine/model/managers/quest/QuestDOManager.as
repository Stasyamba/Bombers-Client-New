/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.model.managers.quest {
import engine.EngineContext
import engine.bombers.interfaces.IBomber
import engine.games.quest.monsters.Monster
import engine.maps.interfaces.ICollectableDynObject
import engine.maps.interfaces.IDynObject
import engine.maps.interfaces.IMapBlock
import engine.maps.interfaces.ITimeActivatableDynObject
import engine.model.managers.interfaces.IMapManager
import engine.model.managers.interfaces.IPlayerManager
import engine.model.managers.regular.DynObjectManager

import greensock.TweenMax

import mx.collections.ArrayList

public class QuestDOManager extends DynObjectManager {

    private var _monstersManager:MonstersManager;
    protected var readyToActivate:ArrayList = new ArrayList();

    protected var timeSinceLastExplosion:int = 0;
    protected static const EXPLOSION_PERIOD:int = 800;

    public function QuestDOManager(playerManager:IPlayerManager, monstersManager:MonstersManager, mapManager:IMapManager) {
        super(playerManager, mapManager)
        _monstersManager = monstersManager;
    }


    override public function checkObjectsActivated(elapsedMilliSecs:int):void {
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
        checkBuffer(elapsedMilliSecs)
    }

    public override function activateObject(x:int, y:int, player:IBomber):void {
        var object:IDynObject = getObjectAt(x, y);
        if (object == null) {
            trace("OH MY GOD!!! NO OBJECT AT " + x + "," + y)
        }
        if (object is ITimeActivatableDynObject) {
            (object as ITimeActivatableDynObject).addVictim(player)
            readyToActivate.addItem(object)
        }
        else
            object.activateOn(player)

        if (object.removeAfterActivation)
            _objects.removeItem(object);
        trace("removed at " + x + "," + y);
    }

    protected function checkBuffer(elapsedMilliSecs:int):void {
        if (Context.game == null)
            return
        timeSinceLastExplosion += elapsedMilliSecs;
        if (timeSinceLastExplosion >= EXPLOSION_PERIOD) {
            timeSinceLastExplosion -= EXPLOSION_PERIOD;

            Context.game.explosionExchangeBuffer.length = 0
            if (readyToActivate.length > 0) {
                for each (var b:ITimeActivatableDynObject in readyToActivate.source) {
                    b.activateOn(b.victim)
                }
                readyToActivate.removeAll();
                if (Context.game.explosionExchangeBuffer.length > 0)
                    EngineContext.explosionGroupAdded.dispatch(Context.game.explosionExchangeBuffer);
            }
        }
    }

    private function checkTimeActivatedObject(object:ITimeActivatableDynObject, elapsedMilliSecs:int):void {
        object.onTimeElapsed(elapsedMilliSecs);
        if (object.timeToActivate <= 0) {
            EngineContext.qPlayerActivateObject.dispatch(object.victim == null ? -1 : object.victim.slot, object.block.x, object.block.y, object.type)
        }
    }

    private function checkCollectableObject(object:ICollectableDynObject):void {
        if (playerManager.checkPlayerMetObject(object)) {
            if (!object.wasTriedToBeTaken) {
                trace("player tried to take")
                object.tryToTake();
                EngineContext.qPlayerActivateObject.dispatch(playerManager.mySlot, object.block.x, object.block.y, object.type);
            }
        }
        _monstersManager.forEachAliveMonster(function todo(monster:Monster, id:int) {
            if (_monstersManager.checkMonsterTakenObject(monster, object)) {
                if (!object.wasTriedToBeTaken) {
                    trace("monster " + id + " tried to take")
                    if (monster.activatesObjects(object.type)) {
                        object.tryToTake()
                        EngineContext.qMonsterActivateObject.dispatch(id, object.block.x, object.block.y, object.type);
                    }
                }
            }
        })
    }

}
}
