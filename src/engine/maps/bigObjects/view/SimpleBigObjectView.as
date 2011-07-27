package engine.maps.bigObjects.view {
import engine.data.Consts
import engine.explosionss.destroy.BasicDestroyExplosion
import engine.maps.bigObjects.SimpleBigObject
import engine.utils.ViewState

import flash.display.Sprite

import greensock.TweenMax

public class SimpleBigObjectView extends BigObjectViewBase {

    protected var healthBar:Sprite;

    public function SimpleBigObjectView(obj:SimpleBigObject) {

        healthBar = new Sprite();
        healthBar.y = -4;
        addChild(healthBar);

        super(obj)

        obj.explosionStarted.add(onExplosionStarted)
        obj.explosionStopped.add(onExplosionStopped)
        obj.destroyed.add(onDestroyed)
    }


    override public function draw():void {
        super.draw()
        drawHealthBar()
    }

    private function drawHealthBar():void {
        var so:SimpleBigObject = object as SimpleBigObject;

        healthBar.graphics.clear();
        healthBar.graphics.beginBitmapFill(Context.imageService.healthBar(so.life / so.startLife, so.pixWidth));
        healthBar.graphics.drawRect(0, 0, so.pixWidth, Consts.HEALTH_BAR_HEIGHT)
        healthBar.graphics.endFill();
    }


    private function onDestroyed():void {
        _defaultAlpha = 0;
        stateManager.deleteAllStates();

        var tween:TweenMax = BasicDestroyExplosion.getTween();
        var child:Sprite = BasicDestroyExplosion.getChild(object.pixWidth / 2 - BasicDestroyExplosion.WIDTH / 2, object.pixHeight / 2 - BasicDestroyExplosion.HEIGHT / 2);
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
}
}
