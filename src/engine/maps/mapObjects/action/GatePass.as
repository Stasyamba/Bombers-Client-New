package engine.maps.mapObjects.action {
import engine.bombers.interfaces.IBomber
import engine.explosionss.RegularExplosion
import engine.games.quest.monsters.Monster
import engine.maps.interfaces.ICollectableDynObject
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock
import engine.maps.mapObjects.DynObjectBase

import flash.events.TimerEvent
import flash.utils.Timer

import org.osflash.signals.Signal

public class GatePass extends DynObjectBase implements ICollectableDynObject {

    private var _isVert:Boolean
    private var _state:Boolean
    private var _period:Number

    public var stateChanged:Signal = new Signal(Boolean);

    private var _timer:Timer;

    public function GatePass(id:int, block:IMapBlock, isVert:Boolean, startState:Boolean, period:Number = 0) {
        super(id, block);
        _isVert = isVert;
        _state = startState;
        _period = period
        if (_period > 0)
            startAction();
        trace("GATEPASS: " + [_block.x.toString(),_block.y.toString(), isVert.toString(), _state.toString() ].join(", "))
    }

    private function startAction():void {
        _timer = new Timer(period);

        Context.gameModel.questEnded.addOnce(onQE)
        Context.gameModel.leftQuest.addOnce(onLG)

        _timer.addEventListener(TimerEvent.TIMER, changeState)
        _timer.start();
    }

    private function onLG():void {
        stopAction()
    }

    private function onQE(p:*, p1:*):void {
        stopAction()
    }

    private function stopAction():void {
        _timer.stop()
        _timer.removeEventListener(TimerEvent.TIMER, changeState)
        _timer = null;
    }

    private function changeState(event:TimerEvent):void {
        activateOn(null);
    }

    public function grabCorrespondingWeapon():void {
        //do nothing
    }

    public function get removeAfterActivation():Boolean {
        return false
    }

    public function canExplosionGoThrough():Boolean {
        return !_state;
    }

    public function canGoThrough():Boolean {
        return !_state
    }

    public function explodesAndStopsExplosion():Boolean {
        return false
    }

    public function get type():IDynObjectType {
        return GatePassType.GATE_PASS;
    }

    public function activateOn(player:IBomber, params:Object = null):void {
        if (player != null)
            return

         _state = params["active"] ? params["active"] : !_state;
        stateChanged.dispatch(_state)

        if (_state) {
            if (Context.game.playerManager.checkPlayerMetObject(this)) {
                if (!Context.game.playerManager.me.isImmortal && !Context.game.playerManager.me.isDead) {
                    var e:RegularExplosion = new RegularExplosion(null, null, -1, -1, 1)
                    Context.game.playerManager.me.explode(e);
                }
            }

            Context.game.monstersManager.forEachAliveMonster(function todo(monster:Monster, id:int) {
                if (Context.game.monstersManager.checkMonsterTakenObject(monster, this)) {
                    if (!monster.isImmortal && !monster.isDead) {
                        var e:RegularExplosion = new RegularExplosion(null, null, -1, -1, 1)
                        monster.explode(e);
                    }
                }
            })

        }
    }

    public function tryToTake():void {
    }

    public function get wasTriedToBeTaken():Boolean {
        return true;
    }

    public function get isVert():Boolean {
        return _isVert
    }

    public function get state():Boolean {
        return _state
    }

    public function get period():Number {
        return _period
    }


}
}
