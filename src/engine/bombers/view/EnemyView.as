/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers.view {
import engine.EngineContext
import engine.bombers.CreatureBase
import engine.bombers.interfaces.IEnemyBomber
import engine.interfaces.IDestroyable
import engine.utils.Direction

public class EnemyView extends CreatureViewBase implements IDestroyable {

    public function EnemyView(bomber:IEnemyBomber) {
        super(bomber as CreatureBase);
        EngineContext.enemyInputDirectionChanged.add(inputDirectionChanged);
        EngineContext.enemySmoothMovePerformed.add(updateCoords)
        EngineContext.someoneDied.add(onEnemyDied);
    }

    private function inputDirectionChanged(slot:int, x:Number, y:Number, dir:Direction):void {
        if (slot == bomber.slot && !bomber.isDead) {
            this.x = x;
            this.y = y;
            draw();
        }
    }

    private function updateCoords(slot:int, x:int, y:int):void {

        if (slot == bomber.slot && !bomber.isDead) {
            this.x = x;
            this.y = y;
        }
    }

    private function get bomber():IEnemyBomber {
        return _creature as IEnemyBomber;
    }

    public function destroy():void {
        EngineContext.enemyInputDirectionChanged.remove(inputDirectionChanged);
        EngineContext.enemySmoothMovePerformed.remove(updateCoords)
    }

    protected function onEnemyDied(slot:int):void {
        if (slot == _creature.slot) {
            onDied();
            destroy();
        }
    }
}
}