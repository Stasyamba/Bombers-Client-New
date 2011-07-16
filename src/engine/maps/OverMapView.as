/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps {
import engine.EngineContext
import engine.data.Consts
import engine.interfaces.IDrawable
import engine.maps.interfaces.IMapBlock
import engine.model.explosionss.ExplosionType

import flash.display.Sprite

public class OverMapView extends Sprite implements IDrawable {

    private var map:IMap;
    private var prints:Vector.<Sprite>;

    public function OverMapView(map:IMap) {

        this.map = map;
        EngineContext.explosionPrintAdded.add(onPrintAdded)

        prints = new Vector.<Sprite>();
        for each (var block:IMapBlock in map.blocks) {
            var print:Sprite = new Sprite();
            print.x = block.x * Consts.BLOCK_SIZE;
            print.y = block.y * Consts.BLOCK_SIZE;
            prints.push(print);
            addChild(print);
        }
    }

    private function onPrintAdded(x:int, y:int):void {
        var print:Sprite = getPrint(x, y);
        print.graphics.clear();
        print.graphics.beginBitmapFill(Context.imageService.explosionPrint(ExplosionType.REGULAR))
        print.graphics.drawRect(0, 0, Consts.BLOCK_SIZE, Consts.BLOCK_SIZE);
        print.graphics.endFill();
    }

    private function getPrint(x:int, y:int):Sprite {
        return prints[y * map.width + x];
    }

    public function draw():void {
    }
}
}
