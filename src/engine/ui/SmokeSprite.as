/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.ui {
import engine.data.Consts

import flash.display.BitmapData
import flash.display.DisplayObjectContainer
import flash.display.Sprite

import greensock.TweenMax

public class SmokeSprite extends Sprite {
    private var _baseX:Number
    private var _baseY:Number
    private var _base:DisplayObjectContainer

    public function SmokeSprite(baseX:Number, baseY:Number, base:DisplayObjectContainer) {
        super()
        _baseX = baseX
        _baseY = baseY
        x = _baseX;
        y = _baseY;
        scaleX = 0.5;
        scaleY = 0.5;
        _base = base;
    }

    public function start():void {
        var bm:BitmapData = Context.imageService.smoke()
        graphics.beginBitmapFill(bm)
        graphics.drawRect(0, 0, Consts.SMOKE_WIDTH, Consts.SMOKE_HEIGHT)
        graphics.endFill()
        TweenMax.fromTo(this, 10,
                {alpha:1,scaleX:0.5,scaleY:0.5,x:_baseX + Consts.BLOCK_SIZE_2 - Consts.SMOKE_WIDTH / 4,y:_baseY + Consts.BLOCK_SIZE_2 - Consts.SMOKE_HEIGHT / 4},
                {alpha:1,scaleX:4,scaleY:4,x:_baseX + Consts.BLOCK_SIZE_2 - 2 * Consts.SMOKE_WIDTH,y:_baseY + Consts.BLOCK_SIZE_2 - 2 * Consts.SMOKE_HEIGHT,onComplete:defaultState})
        _base.addChild(this);
    }

    private function defaultState():void {
        TweenMax.to(this, 70,
                {alpha:0.95,scaleX:4 * 1.2,scaleY:4 * 1.2,x:_baseX + Consts.BLOCK_SIZE_2 - 1.2 * 2 * Consts.SMOKE_WIDTH,y:_baseY + Consts.BLOCK_SIZE_2 - 1.2 * 2 * Consts.SMOKE_HEIGHT,onComplete:finish})
    }

    private function finish():void {
        TweenMax.to(this, 5, {alpha:0,onComplete:destroy})
    }

    private function destroy():void {
        parent.removeChild(this)
    }
}
}
