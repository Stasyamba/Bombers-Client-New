/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.mapBlocks.view {
import engine.interfaces.IDestroyable
import engine.interfaces.IDrawable

import flash.display.Sprite

public class DestroyableSprite extends Sprite implements IDestroyable,IDrawable {
    public function DestroyableSprite() {
        super();
    }

    public function destroy():void {
        throw Context.Exception("������ � ����� DestroyableSprite.as: Abstract class method call")
    }

    public function draw():void {
        throw Context.Exception("������ � ����� DestroyableSprite.as: Abstract class method call")
    }
}
}
