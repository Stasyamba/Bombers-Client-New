/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.bigObjects.view {
import engine.data.Consts
import engine.explosionss.destroy.BasicDestroyExplosion
import engine.interfaces.IDrawable
import engine.maps.bigObjects.BigObjectBase
import engine.maps.bigObjects.SimpleBigObject
import engine.utils.IStatedView
import engine.utils.ViewState
import engine.utils.ViewStateManager

import flash.display.BitmapData
import flash.display.BlendMode
import flash.display.Sprite

import greensock.TweenMax

public class BigObjectView extends Sprite implements IDrawable,IStatedView {

    private var object:BigObjectBase;

    private var stateManager:ViewStateManager;

    private var _tunableProperties:Object = {x:true,y:true,alpha:true,blendMode:true,scaleX:true,scaleY:true};
    private var _defaultAlpha:Number = 1;

    private var _self:Sprite
    protected var healthBar:Sprite;

    public function BigObjectView(obj:BigObjectBase) {
        super();
        object = obj;
        x = obj.x * Consts.BLOCK_SIZE;
        y = obj.y * Consts.BLOCK_SIZE;

        stateManager = new ViewStateManager(this)

        if (obj is SimpleBigObject) {

            var so:SimpleBigObject = obj as SimpleBigObject
            so.explosionStarted.add(onExplosionStarted)
            so.explosionStopped.add(onExplosionStopped)
            so.destroyed.add(onDestroyed)

            healthBar = new Sprite();
            healthBar.y = -4;
            addChild(healthBar);
        }

//      _self = Context.imageService.bigObjectSWF(object.graphicsId)
        _self = new Sprite()
        draw()

        addChild(_self)
    }

    private function addState(state:ViewState):void {
        stateManager.addState(state);
        draw();
    }

    private function removeState(name:String):void {
        stateManager.removeState(name);
    }

    private function onDestroyed():void {
        _defaultAlpha = 0;
        stateManager.deleteAllStates();

        var tween:TweenMax = BasicDestroyExplosion.getTween();
        var child:Sprite = BasicDestroyExplosion.getChild(this.width / 2 - BasicDestroyExplosion.WIDTH / 2, this.height / 2 - BasicDestroyExplosion.HEIGHT / 2);
        var childTween:TweenMax = BasicDestroyExplosion.getChildTween(child);

        addState(new ViewState(ViewState.DYING_EXPLOSION, {alpha:1}, tween, child, childTween))
    }

    private function onExplosionStopped():void {
        removeState(ViewState.BLINKING);
    }

    private function onExplosionStarted():void {
        draw()
        addState(new ViewState(ViewState.BLINKING, {}, TweenMax.fromTo(new Object(), Consts.BLINKING_TIME, {alpha:0}, {alpha:ViewState.GET_DEFAULT_VALUE, repeat:-1,yoyo:true,paused:true,data:{alpha:ViewState.GET_DEFAULT_VALUE}})))
    }

    public function draw():void {

        _self.graphics.clear();
        var bd:BitmapData = Context.imageService.graphic(object.graphicsId)
        _self.graphics.beginBitmapFill(bd);
        _self.graphics.drawRect(0, 0, bd.width, bd.height);
        _self.graphics.endFill();
        _self.x = (object.pixWidth - bd.width) / 2;
        _self.y = (object.pixHeight - bd.height) / 2;

        if (object is SimpleBigObject) {
            drawHealthBar()
        }
    }

    private function drawHealthBar():void {
        var so:SimpleBigObject = object as SimpleBigObject;

        healthBar.graphics.clear();
        healthBar.graphics.beginBitmapFill(Context.imageService.healthBar(so.life / so.startLife, so.pixWidth));
        healthBar.graphics.drawRect(0, 0, so.pixWidth, Consts.HEALTH_BAR_HEIGHT)
        healthBar.graphics.endFill();
    }

    public function get tunableProperties():Object {
        return _tunableProperties;
    }

    public function getDefaultProperty(prop:String):* {
        switch (prop) {
            case "x": return object.x * Consts.BLOCK_SIZE;
            case "y": return object.y * Consts.BLOCK_SIZE;
            case "alpha": return _defaultAlpha;
            case "blendMode":return BlendMode.NORMAL;
            case "scaleX": return 1.0;
            case "scaleY": return 1.0;
        }
        throw Context.Exception("Îרטבךא ג פאיכו BigObjectView.as: property " + prop + " is not supported")
    }
}
}