/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers.view {
import engine.bombers.CreatureBase
import engine.bombers.interfaces.IBomber
import engine.data.Consts
import engine.explosionss.destroy.BasicDestroyExplosion
import engine.interfaces.IDrawable
import engine.utils.IStatedView
import engine.utils.ViewState
import engine.utils.ViewStateManager

import flash.display.BlendMode
import flash.display.MovieClip
import flash.display.Sprite
import flash.filters.BitmapFilterQuality
import flash.filters.BlurFilter
import flash.text.TextField
import flash.text.TextFormat

import greensock.TweenMax

public class CreatureViewBase extends Sprite implements IDrawable,IStatedView {

    protected var _creature:CreatureBase;

    protected var _self:MovieClip
    protected var healthBar:Sprite = new Sprite();

    private var stateManager:ViewStateManager;

    private var _tunableProperties:Object = {x:true,y:true,alpha:true,blendMode:true,scaleX:true,scaleY:true};
    private var _defaultAlpha:Number = 1;

    public function CreatureViewBase(creature:CreatureBase) {
        super();
        _creature = creature;
        _self = Context.imageService.creatureSWF(_creature.graphicsId)
//        _self.x = _self.y = Consts.BOMBER_SIZE_2
        _self.x = (Consts.BLOCK_SIZE - _self.width) / 2
        _self.y = (Consts.BLOCK_SIZE - _self.height) / 2
        addChild(_self)

//		_self.setMode(2)
//        if(_creature color != -1)
//            _self.setColor(color)
        if (_creature is IBomber) {
            (_creature as IBomber).color
        }

        this.x = creature.coords.getRealX();
        this.y = creature.coords.getRealY();
        healthBar = new Sprite();
        healthBar.x = int((Consts.BLOCK_SIZE - Consts.HEALTH_BAR_WIDTH) / 2)
        healthBar.y = -4;
        addChild(healthBar);

        stateManager = new ViewStateManager(this);

        this._creature.stateAdded.add(addState);
        this._creature.stateRemoved.add(removeState);
        this._creature.lifeChanged.add(onLifeChanged)
        draw();
    }

    private function onLifeChanged(diff:int):void {
        var lifePopup:Sprite = new Sprite()
        lifePopup.cacheAsBitmap = true;
        var l:TextField = new TextField()
        var tf:TextFormat = new TextFormat();
        tf.size = 20;
        tf.font = "mpbc"
        l.defaultTextFormat = tf;
        l.text = diff.toString();
        l.textColor = diff > 0 ? 0xff00 : 0xff0000;
        lifePopup.addChild(l)

//		l.styleSheet = new StyleSheet();
//		l.styleSheet.setStyle("font-size","30px")
//		l.styleSheet.setStyle("fontSize",30);

//		var s:StyleSheet = new StyleSheet();
//		s.setStyle("fontFamily","mps");
//		s.setStyle("fontSize",30);
//        l.styleSheet = s;

        lifePopup.x = _creature.coords.getRealX() + Consts.BOMBER_SIZE - 25;
        lifePopup.y = y;
        parent.addChild(lifePopup)

        lifePopup.filters = [new BlurFilter(1.5, 1.5, BitmapFilterQuality.HIGH)]

        TweenMax.to(lifePopup, 2, {alpha:0.6,x:"-8",y:"-50",onComplete:function():void {
            parent.removeChild(lifePopup)
        }
        })

//        TweenMax.to(lifePopup, 2, {scaleX:1.5, scaleY:1.5})
    }

    private function addState(state:ViewState):void {
        stateManager.addState(state);
        draw();
    }

    private function removeState(name:String):void {
        stateManager.removeState(name);
    }

    public function draw():void {
        if (_creature.isDead) {
            if (contains(_self))
                removeChild(_self);
            if (contains(healthBar))
                removeChild(healthBar);
            return;
        }

        drawHealthBar();

        _self.setMove(_creature.direction.value)

    }

    private function drawHealthBar():void {
        healthBar.graphics.clear();
        healthBar.graphics.beginBitmapFill(Context.imageService.healthBar(_creature.life / _creature.startLife));
        healthBar.graphics.drawRect(0, 0, Consts.HEALTH_BAR_WIDTH, Consts.HEALTH_BAR_HEIGHT)
        healthBar.graphics.endFill();
    }

    protected function onDied():void {
        _defaultAlpha = 0;
        stateManager.deleteAllStates();

        var tween:TweenMax = BasicDestroyExplosion.getTween();
        var child:Sprite = BasicDestroyExplosion.getChild(19 - BasicDestroyExplosion.WIDTH / 2, 19 - BasicDestroyExplosion.HEIGHT / 2);
        var childTween:TweenMax = BasicDestroyExplosion.getChildTween(child);

        addState(new ViewState(ViewState.DYING_EXPLOSION, {alpha:1}, tween, child, childTween))

    }

    public function get tunableProperties():Object {
        return _tunableProperties;
    }

    public function getDefaultProperty(prop:String):* {
        switch (prop) {
            case "x":
                return _creature.coords.getRealX();
            case "y":
                return _creature.coords.getRealY();
            case "alpha":
                return _defaultAlpha;
            case "blendMode":
                return BlendMode.NORMAL;
            case "scaleX":
                return 1.0;
            case "scaleY":
                return 1.0;
        }
        throw Context.Exception("������ � ����� CreatureViewBase.as: property " + prop + " is not supported");
    }
}
}