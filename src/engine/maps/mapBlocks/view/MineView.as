/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.mapBlocks.view {
import engine.data.Consts
import engine.explosionss.destroy.BasicDestroyExplosion
import engine.maps.interfaces.IMapBlock
import engine.maps.mapObjects.DynObjectType
import engine.utils.IStatedView
import engine.utils.ViewState
import engine.utils.ViewStateManager

import flash.display.BlendMode
import flash.display.Sprite

import greensock.TweenMax

public class MineView extends DynObjectView implements IStatedView {

    /*stated view*/
    private var stateManager:ViewStateManager;
    private var _tunableProperties:Object = {x:true,y:true,alpha:true,blendMode:true,scaleX:true,scaleY:true};
    private var _defaultAlpha:Number = 1;

    public function MineView(block:IMapBlock, baseView:Sprite) {
        super(block,baseView);
        this.block.objectCollected.add(onTakenAnimation)

        stateManager = new ViewStateManager(this)

        TweenMax.delayedCall(2,function(){
            if(_defaultAlpha != 0)
                alpha = 0.3;
        })
    }



    public function onTakenAnimation(byMe:Boolean):void {

        _defaultAlpha = 0;
        stateManager.deleteAllStates();

        var tween:TweenMax = BasicDestroyExplosion.getTween();
        var child:Sprite = BasicDestroyExplosion.getChild(this.width / 2 - BasicDestroyExplosion.WIDTH / 2, this.height / 2 - BasicDestroyExplosion.HEIGHT / 2);
        var childTween:TweenMax = BasicDestroyExplosion.getChildTween(child);

        addState(new ViewState(ViewState.DYING_EXPLOSION, {alpha:1}, tween, child, childTween))
    }

    override public function destroy():void {
        super.destroy()
        block.objectCollected.remove(onTakenAnimation);
    }

    /*stated view*/

    private function addState(state:ViewState):void {
        stateManager.addState(state);
        //draw();
    }

    private function removeState(name:String):void {
        stateManager.removeState(name);
    }

    public function get tunableProperties():Object {
        return _tunableProperties;
    }

    public function getDefaultProperty(prop:String):* {
        switch (prop) {
            case "x": return 0;
            case "y": return 0;
            case "alpha": return _defaultAlpha;
            case "blendMode":return BlendMode.NORMAL;
            case "scaleX": return 1.0;
            case "scaleY": return 1.0;
        }
        throw Context.Exception("Error in file MineView.as: property " + prop + " is not supported")
    }
}
}
