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
import engine.maps.mapBlocks.MapBlockType
import engine.maps.mapObjects.DynObjectType

import flash.display.Sprite

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

        draw();
        if (block.object != null && block.object.type != DynObjectType.NULL) {
            onObjectSet(block.object)
        }
    }

    private function onObjectCollected(byMe:Boolean):void {
        draw();
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
//        drawHiddenObject();
    }

//    private function drawHiddenObject():void {
//        if (block.isExplodingNow && block.hiddenObject.type != DynObjectType.NULL) {
//            trace("DRAWN HIDDEN")
//            graphics.beginBitmapFill(Context.imageService.dynObject(block.hiddenObject.type));
//            graphics.drawRect(0, 0, Consts.BLOCK_SIZE, Consts.BLOCK_SIZE);
//            graphics.endFill();
//        }
//    }

    private function drawObject():void {
        if (objectView != null && contains(objectView)) {
            objectView.draw();
            objectView.visible = block.canShowObjects;
            setChildIndex(objectView, numChildren - 1);
        }
    }

    private function drawBlock():void {
        if (blockView != null && contains(blockView)) {
            removeChild(blockView)
        }
        if (!block.type.draws) return
        alpha = 1;

        if (block.type == MapBlockType.BOX && block.isGold)
            blockView = Context.imageService.mapBlock(block.type, Context.game.location, true);
        else
            blockView = Context.imageService.mapBlock(block.type, Context.game.location);
        addChild(blockView)
    }
}
}