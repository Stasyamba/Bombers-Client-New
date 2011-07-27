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
import engine.maps.bigObjects.SpecialSimpleBigObject
import engine.model.explosionss.ExplosionType
import engine.utils.IStatedView
import engine.utils.ViewState
import engine.utils.ViewStateManager

import flash.display.BitmapData
import flash.display.BlendMode
import flash.display.Sprite

import greensock.TweenMax

public class BigObjectViewBase extends Sprite implements IDrawable,IStatedView {

    protected var object:BigObjectBase;

    protected var stateManager:ViewStateManager;

    protected var _tunableProperties:Object = {x:true,y:true,alpha:true,blendMode:true,scaleX:true,scaleY:true};
    protected var _defaultAlpha:Number = 1;

    protected var _self:Sprite

    public function BigObjectViewBase(obj:BigObjectBase) {
        super();
        object = obj;
        x = obj.x * Consts.BLOCK_SIZE;
        y = obj.y * Consts.BLOCK_SIZE;

        stateManager = new ViewStateManager(this)

        _self = new Sprite()
        draw()

        addChild(_self)
    }

    protected function addState(state:ViewState):void {
        stateManager.addState(state);
        draw();
    }

    protected function removeState(name:String):void {
        stateManager.removeState(name);
    }

    public function draw():void {

        _self.graphics.clear();
        var bd:BitmapData = Context.imageService.graphic(object.graphicsId)
        _self.graphics.beginBitmapFill(bd);
        _self.graphics.drawRect(0, 0, bd.width, bd.height);
        _self.graphics.endFill();
        _self.x = (object.pixWidth - bd.width) / 2;
        _self.y = (object.pixHeight - bd.height) / 2;

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
        throw Context.Exception("Error in file BigObjectView.as: property " + prop + " is not supported")
    }
}
}