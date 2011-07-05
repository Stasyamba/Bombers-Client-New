/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.mapBlocks.view {
import engine.interfaces.IDrawable
import engine.maps.interfaces.IMapBlock

import flash.display.Sprite

import greensock.TweenMax

public class SpecialObjectView extends DynObjectView implements IDrawable {

    public function SpecialObjectView(block:IMapBlock, baseView:Sprite) {
        super(block, baseView)
        this.block.objectCollected.add(onTakenAnimation)
    }

    public function onTakenAnimation(byMe:Boolean):void {
        if (byMe)
            TweenMax.to(this, 1, {x:"60",y:"-40",rotation:"360",scaleX:0,scaleY:0,alpha:0,onComplete:destroy});
        else
            TweenMax.to(this, 0.7, {x:"20",y:"20",scaleX:0,scaleY:0,alpha:0,onComplete:destroy});
    }

    override public function destroy():void {
        super.destroy()
        block.objectCollected.remove(onTakenAnimation);
    }
}
}
