/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers {
import components.common.items.ItemType

import engine.EngineContext
import engine.bombers.interfaces.IEnemyBomber
import engine.explosionss.interfaces.IExplosion
import engine.games.IGame
import engine.playerColors.PlayerColor
import engine.profiles.PlayerGameProfile
import engine.utils.Direction

public class EnemyBomber extends BomberBase implements IEnemyBomber {

    protected var _serverDir:Direction = Direction.NONE;


    public function EnemyBomber(game:IGame, playerProfile:PlayerGameProfile, userName:String, color:PlayerColor) {
        super(game, playerProfile.slot, playerProfile.bomberType.getEngineType(), userName, color, playerProfile.auras);

        _serverDir = Direction.NONE
        EngineContext.moveTick.add(onMoveTick)
        EngineContext.someoneDamaged.add(onDamaged);
        EngineContext.someoneDied.add(onDied);
        EngineContext.enemyDirectionForecast.add(onEnemyDirectionForecast)
    }

    private function onEnemyDirectionForecast(slot:int, dir:Direction):void {
        if (slot != _slot)
            return
        _serverDir = dir
    }

    private function onMoveTick(obj:Object):void {
        if (!Context.gameModel.isPlayingNow || obj == null)
            return
        var tickObject:Object = obj[slot]
        if (tickObject == null)
            return
//        var xPogr:Number = Math.abs(tickObject.x - Math.round(tickObject.x))
//        var yPogr:Number = Math.abs(tickObject.y - Math.round(tickObject.y))
//        if (xPogr < 10e-6)
//            tickObject.x = Math.round(tickObject.x)
//
//        if (yPogr < 10e-6)
//            tickObject.y = Math.round(tickObject.y)

        _coords.setExplicit(tickObject.x, tickObject.y)

        if (!_coords.correctCoords(tickObject.x, tickObject.y)) {
        }
        if (_serverDir != tickObject.dir) {
            _serverDir = tickObject.dir
            EngineContext.enemyInputDirectionChanged.dispatch(slot, coords.getRealX(), coords.getRealY(), _serverDir)
        }
    }

    private function onDied(id:int):void {
        if (id == slot)
            kill();
    }

    protected function onDamaged(id:int, health_left:int):void {
        if (slot == id) {
            life = health_left;
            makeImmortalFor(immortalTime);
        }
    }
	
    public function performSmoothMotion(moveAmount:Number):void {
        if (!Context.gameModel.isPlayingNow)
            return
        switch (_serverDir) {
            case Direction.NONE:
                return;
            case Direction.LEFT:
                _coords.stepLeft(moveAmount);
                break;
            case Direction.RIGHT:
                _coords.stepRight(moveAmount);
                break;
            case Direction.UP:
                _coords.stepUp(moveAmount);
                break;
            case Direction.DOWN:
                _coords.stepDown(moveAmount);
                break;
        }
        EngineContext.enemySmoothMovePerformed.dispatch(slot, _coords.getRealX(), _coords.getRealY());
    }

    public override function move(elapsedMilliSecs:int):void {
        var moveAmount:Number = elapsedMilliSecs * speed / 1000;
        while(true){
            if (moveAmount > 30){
                performSmoothMotion(30)
                moveAmount -= 30
            }else
            {
                performSmoothMotion(moveAmount)
                break
            }
        }
    }

    override public function addItemBonus(_weapon:ItemType, count:int):void {

    }

    public override function kill():void {
        life = 0;
    }

    public override function explode(expl:IExplosion):void {
    }


    override public function get direction():Direction {
        return _serverDir
    }
}
}