/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapBlocks.view {
import engine.EngineContext
import engine.data.Consts
import engine.interfaces.IDrawable
import engine.maps.interfaces.IDynObject
import engine.maps.interfaces.IMapBlock
import engine.maps.mapObjects.DynObjectType

import flash.display.BitmapData
import flash.display.Sprite

import loading.LoadedContentType
import loading.LoadedObject

public class MapBlockView extends Sprite implements IDrawable {

    private var block:IMapBlock;
    private var blinking:Boolean = false;
    private var blinkingTime:Number = Consts.BLINKING_TIME;

    private var blockView:Sprite;
    private var objectView:DestroyableSprite;

    public function MapBlockView(block:IMapBlock) {
        super();
        this.block = block;
        x = block.x * Consts.BLOCK_SIZE;
        y = block.y * Consts.BLOCK_SIZE;

        block.viewUpdated.add(draw);

        if (block.state.blinks) {
            block.explosionStarted.add(function():void {
                EngineContext.frameEntered.add(onBlink)
                blinking = true;
            })
            block.explosionStopped.add(function():void {
                EngineContext.frameEntered.remove(onBlink)
                blinking = false;
                draw()
            })
        }
        block.objectSet.add(onObjectSet);
        block.objectCollected.add(onObjectCollected);

        if (block.object != null && block.object.type != DynObjectType.NULL) {
            onObjectSet(block.object)
        }
        draw();
    }

    private function onObjectCollected(byMe:Boolean):void {
        //this.objectView = null
    }

    private function onObjectSet(object:IDynObject):void {
        if (objectView != null && contains(objectView))
            objectView.destroy();
        objectView = ObjectViewFactory.make(object, this);
        addChild(objectView);
        draw();
    }

    private function onBlink(elapsedMilliSecs:int):void {
        if (!block.isExplodingNow) {
            blinking = false;
            alpha = 1
            draw();
            return
        }
        blinkingTime -= elapsedMilliSecs / 1000;
        if (blinkingTime <= 0) {
            blinkingTime += Consts.BLINKING_TIME;
            blinking = !blinking;
            alpha = blinking ? 0 : 1
        }
    }

    public function draw():void {

        drawBlock();

        drawObject();
        drawHiddenObject();
    }

    private function drawHiddenObject():void {
        if (block.isExplodingNow && block.hiddenObject.type != DynObjectType.NULL) {
            trace("DRAWN HIDDEN")
            graphics.beginBitmapFill(Context.imageService.dynObject(block.hiddenObject.type));
            graphics.drawRect(0, 0, Consts.BLOCK_SIZE, Consts.BLOCK_SIZE);
            graphics.endFill();
        }
    }

    private function drawObject():void {
        if (objectView != null) {
            objectView.draw();
            objectView.visible = block.canShowObjects;
        }
    }

    private function drawBlock():void {
        if (blockView != null && contains(blockView)){
            removeChild(blockView)
        }
        if (!block.type.draws) return
        var lo:LoadedObject = Context.imageService.mapBlock(block.type, Context.game.location);
        if (lo.contentType == LoadedContentType.SWF) {
            blockView = new Sprite()
            blockView.addChild(lo.content)
        } else {
            blockView = new Sprite()
            blockView.graphics.clear();
            var bData:BitmapData = lo.content.bitmapData as BitmapData;
            if (bData == null) return;
            blockView.graphics.beginBitmapFill(bData);
            blockView.graphics.drawRect(0, 0, Consts.BLOCK_SIZE, Consts.BLOCK_SIZE);
            blockView.graphics.endFill();
        }
        addChild(blockView)
    }
}
}