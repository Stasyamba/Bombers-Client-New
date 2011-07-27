package engine.maps.bigObjects.view {
import engine.maps.bigObjects.SpecialSimpleBigObject

import flash.display.BitmapData

import flash.display.Sprite

public class SpecialSimpleBigObjectView extends SimpleBigObjectView {

    public function SpecialSimpleBigObjectView(obj:SpecialSimpleBigObject) {

        super(obj)

        var tip:Sprite = new Sprite();
        var tipBitmap:BitmapData = Context.imageService.weaponTip(obj.explType);
        tip.graphics.beginBitmapFill(tipBitmap);
        tip.graphics.drawRect(0, 0, tipBitmap.width, tipBitmap.height);
        tip.graphics.endFill()
        tip.x = obj.pixWidth - 10;
        tip.y = -tipBitmap.height + 10;
        addChild(tip);
    }
}
}
