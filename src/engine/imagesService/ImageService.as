/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.imagesService {
import components.common.worlds.locations.LocationType

import engine.bombers.BomberType
import engine.bombers.skin.BasicSkin
import engine.bombers.skin.SkinElement
import engine.bombss.BombType
import engine.data.Consts
import engine.explosionss.ExplosionPointType
import engine.maps.interfaces.IDynObjectType
import engine.maps.mapBlocks.MapBlockType
import engine.model.explosionss.ExplosionType
import engine.playerColors.PlayerColor

import flash.display.Bitmap
import flash.display.BitmapData
import flash.display.MovieClip
import flash.display.Sprite
import flash.geom.Point
import flash.geom.Rectangle
import flash.utils.ByteArray
import flash.utils.Dictionary

import greensock.loading.LoaderMax
import greensock.loading.display.ContentDisplay

import loading.BombersContentLoader
import loading.LoadedContentType
import loading.LoadedObject

public class ImageService {


    private function get whatIsLoaded():Dictionary {
        return BombersContentLoader.whatIsLoaded
    }

    private function get loadedStuff():Dictionary {
        return BombersContentLoader.loadedGraphics
    }

    public function ImageService() {
    }


    public function loadedObject(id:String):LoadedObject {
        var res:LoadedObject = loadedStuff[id]
        if (res == null) {
            throw Context.Exception("Error in file ImageService.as: Object " + id + " was not found")
        }
        if (!res.loaded) {
            throw Context.Exception("Error in file ImageService.as: Object " + id + " is not yet loaded")
        }
        return res
    }

    public function isLoaded(id:String):Boolean {
        if (id.indexOf(".") == -1) { //not an id
            return whatIsLoaded[id] != null
        }
        var res:LoadedObject = loadedStuff[id]
        if (res == null) {
            throw Context.Exception("Error in file ImageService.as: Object " + id + " was not found")
        }
        return res.loaded
    }

    public function healthBar(lifePercent:Number, full_width:Number = -1):BitmapData {
        var side:BitmapData,center:BitmapData;
        var width:Number = full_width == -1 ? Consts.HEALTH_BAR_WIDTH : full_width
        var b:BitmapData = new BitmapData(width, Consts.HEALTH_BAR_HEIGHT, true, 0);
        if (lifePercent > 0.9) {
            side = loadedObject("common.healthBar.green_side").content.bitmapData
            center = loadedObject("common.healthBar.green_center").content.bitmapData
        } else if (lifePercent > 0.4) {
            side = loadedObject("common.healthBar.yellow_side").content.bitmapData
            center = loadedObject("common.healthBar.yellow_center").content.bitmapData
        } else {
            side = loadedObject("common.healthBar.red_side").content.bitmapData
            center = loadedObject("common.healthBar.red_center").content.bitmapData
        }
        var length:int = int(lifePercent * width);
        b.copyPixels(side, new Rectangle(0, 0, 1, 5), new Point(0, 0));
        for (var i:int = 1; i < length - 1; i++) {
            b.copyPixels(center, new Rectangle(0, 0, 1, 5), new Point(i, 0));
        }
        b.copyPixels(side, new Rectangle(0, 0, 1, 5), new Point(length - 1, 0));
        return b;
    }

    public function bomberSkin(bomberType:BomberType):BasicSkin {
        if (_bomberSkins[bomberType.value] != null)
            return _bomberSkins[bomberType.value]
        return makeSkin(bomberType);
    }

    private function bomberSkinElement(id:String):Bitmap {
        return loadedObject(id).content as Bitmap
    }

    //todo:add variety support
    public function mapBlock(blockType:MapBlockType, locationType:LocationType, gold:Boolean = false):Sprite {
        if (!blockType.draws)
            throw Context.Exception("Error in file ImageService.as: no image for not drawn block " + blockType.key)
        var lo:LoadedObject;
        var res:Sprite;
		if (gold)
			lo = loadedObject(locationType.stringId + ".map.goldBox");
		else{
	        if (blockType.graphicsName == MapBlockType.DEFAULT_GRAPHICS_NAME) {
	            var name:String = blockType.nameAs != null ? (locationType.stringId + ".map." + blockType.nameAs + "1") : (locationType.stringId + ".map." + blockType.key.toLowerCase() + "1");
	            lo = loadedObject(name);
	        } else {
	            lo = loadedObject(blockType.graphicsName)
	        }
		}
        if (lo.contentType == LoadedContentType.IMAGE) {
            res = new Sprite()
            var bData:BitmapData = lo.content.bitmapData as BitmapData
            res.graphics.beginBitmapFill(bData);
            res.graphics.drawRect(0, 0, bData.width, bData.height);
            res.graphics.endFill();
            res.x = (Consts.BLOCK_SIZE - bData.width)/2;
            res.y = (Consts.BLOCK_SIZE - bData.height)/2;
        } else {
            var c:Class = lo.swfClass(blockType.swfClassName)
            res = new c()
        }
        return res;
    }

    public function bomb(type:BombType, color:PlayerColor):BitmapData {
        var b:BitmapData = new BitmapData(Consts.BLOCK_SIZE, Consts.BLOCK_SIZE, true, 0);
        var bImage:BitmapData = loadedObject("common.DO." + type.stringId).content.bitmapData;
        b.copyPixels(bImage, new Rectangle(0, 0, Consts.BLOCK_SIZE, Consts.BLOCK_SIZE), new Point(0, 0));
        if (type.needGlow) {
            b.copyPixels(color.bombGlow, new Rectangle(0, 0, Consts.BLOCK_SIZE, Consts.BLOCK_SIZE), new Point(0, 0), null, null, true);
            b.copyPixels(color.bombGlow, new Rectangle(0, 0, Consts.BLOCK_SIZE, Consts.BLOCK_SIZE), new Point(0, 0), null, null, true);
        }
        return b;
    }

    public function explosion(explType:ExplosionType, explPointType:ExplosionPointType):BitmapData {
        switch (explType) {
            case ExplosionType.REGULAR:
            case ExplosionType.ATOM:
            case ExplosionType.DYNAMITE:
                return loadedObject("common.explosions." + explPointType.value.toLowerCase()).content.bitmapData as BitmapData
        }
        return null;
    }

    public function dynObject(type:IDynObjectType,_postfix:String = null):Sprite {
        var res:Sprite;
        var postfix:String = _postfix ? ("." + _postfix) : "";
        var lo:LoadedObject = loadedObject("common.DO." + type.stringId + postfix);
        if (lo.contentType == LoadedContentType.IMAGE) {
            res = new Sprite()
            res.graphics.beginBitmapFill(lo.content.bitmapData as BitmapData);
            res.graphics.drawRect(0, 0, Consts.BLOCK_SIZE, Consts.BLOCK_SIZE);
            res.graphics.endFill();
        } else {
            var c:Class = lo.swfClass(type.swfClassName)
            res = new c()
        }

        return res;
    }

    public function explosionPrint(explType:ExplosionType):BitmapData {
        return loadedObject("common.explosions.print").content.bitmapData as BitmapData
    }

    public function dieExplosion(index:int):BitmapData {
        if (index < 0 || index > 2)
            throw Context.Exception("Error in file ImageService.as: wrong die explosion index");
        return loadedObject("common.explosions.die" + index).content.bitmapData as BitmapData
    }

    /*
     * if locType != null id is constructed this way: locId.bo.id
     * */
    public function bigObjectSWF(id:String, locType:LocationType = null):MovieClip {
        //real code
//        if (locType != null)
//            return loadedObject(locType.stringId + ".bo." + id).content.bitmapData as BitmapData
//        return loadedObject(id).content.bitmapData as BitmapData
        return BombersContentLoader.boSwf
    }

    public function graphic(id:String):BitmapData {
        var ldo:LoadedObject = loadedStuff[id] as LoadedObject
        if (ldo)
            return ldo.content.bitmapData as BitmapData
        return null
    }

    public function smoke():BitmapData {
        return loadedObject("common.explosions.smoke").content.bitmapData as BitmapData
    }

    public function mapBackground(locationType:LocationType):BitmapData {
        var lo:LoadedObject = loadedObject(locationType.stringId + ".map.background");
        if (lo)
            return lo.content.bitmapData as BitmapData
        return loadedObject("l00.map.background").content.bitmapData as BitmapData
    }

    public function playerPointer():BitmapData {
        return loadedObject("common.other.playerPointer").content.bitmapData as BitmapData
    }

    public function asContentDisplay(id:String):ContentDisplay {
        return LoaderMax.getContent(id)
    }

    [Embed(source="BomberSkins.xml",mimeType="application/octet-stream")]
    private const bomberSkinsC:Class;
    private var _bomberSkinsXml:XML;
    private var _bomberSkins:Object = new Object()

    private function get bomberSkinsXml():XML {
        if (_bomberSkinsXml == null) {
            var file:ByteArray = new bomberSkinsC();
            var str:String = file.readUTFBytes(file.length);
            _bomberSkinsXml = new XML(str);
        }
        return _bomberSkinsXml;
    }

    private function makeSkin(b:BomberType):BasicSkin {
        var skinXml:XMLList = bomberSkinsXml.child(b.stringId);
        var colorsObject:Object = new Object();
        var skinElements:Object = new Object();

        for each (var skinColor:XML in skinXml.colors.SkinColor) {
            var pColor:String = skinColor.@val;
            colorsObject[pColor] = {color:uint(skinColor.color.@val),blendMode:skinColor.blendMode.@val,opacity:Number(skinColor.opacity.@val)}
        }
        skinElements.left = new SkinElement(bomberSkinElement(b.stringId + ".left"), bomberSkinElement(b.stringId + ".left_mask"))
        skinElements.right = new SkinElement(bomberSkinElement(b.stringId + ".right"), bomberSkinElement(b.stringId + ".right_mask"))
        skinElements.up = new SkinElement(bomberSkinElement(b.stringId + ".up"), bomberSkinElement(b.stringId + ".up_mask"))
        skinElements.down = new SkinElement(bomberSkinElement(b.stringId + ".down"), bomberSkinElement(b.stringId + ".down_mask"))
        skinElements.none = new SkinElement(bomberSkinElement(b.stringId + ".down"), bomberSkinElement(b.stringId + ".down_mask"))

        return new BasicSkin(b.name, skinElements, colorsObject);
    }

    public function creatureSWF(graphicsId:String):MovieClip {
        var lo:LoadedObject = loadedObject(graphicsId)
        var arr:Array = graphicsId.split(".")
        var cName:String = arr[arr.length - 1];
        var c:Class = lo.swfClass(cName)

        var m:MovieClip = new c()
        return m
    }

    public function weaponTip(explType:ExplosionType):BitmapData {
        var lo:LoadedObject = loadedObject("common.other." + explType.value + "_tip");
        return lo.content.bitmapData as BitmapData;
    }
}
}