/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.bigObjects {
import engine.EngineContext
import engine.maps.IMap
import engine.maps.builders.DynObjectBuilder
import engine.maps.builders.MapBlockStateBuilder
import engine.maps.interfaces.IMapBlock
import engine.maps.mapBlocks.MapBlockType
import engine.maps.mapBlocks.mapBlockStates.BlockUnderBigObject
import engine.maps.mapObjects.DynObjectType
import engine.model.explosionss.ExplosionType

import flash.utils.ByteArray

import greensock.TweenMax

import org.osflash.signals.Signal

public class SimpleBigObject extends BigObjectBase {

    protected var _life:int
    protected var _startLife:int

    protected var _isExplodingNow:Boolean;
    protected var _explosionStopped:Signal = new Signal();
    protected var _explosionStarted:Signal = new Signal();
    protected var _destroyed:Signal = new Signal();

    [Embed(source="../../data/xml/asBox.xml", mimeType="application/octet-stream")]
    public static const asBoxXmlClass:Class;
    private static var _asBoxStr:String

    public function SimpleBigObject(xml:XML, map:IMap, mapBlockStateBuilder:MapBlockStateBuilder, mapObjectBuilder:DynObjectBuilder, life:int) {
        super(xml, map, mapBlockStateBuilder, mapObjectBuilder)
        _life = life
        _startLife = life

        EngineContext.specialObjectExploded.add(onExploded)
    }

    private function onExploded(id:int, x:int,y:int, lifeLeft:int):void {
        if(id == _id){
            explode(ExplosionType.REGULAR, life - lifeLeft);
		}
    }

    public function get life():int {
        return _life;
    }

    public function get isDestroyed():Boolean {
        return life <= 0;
    }

    public function explode(expl:ExplosionType, damage:int):void {
        if (isDestroyed) return;
        if (!_isExplodingNow) {
            if (damage >= life)
                destroy()
            else {
                _life -= damage;
                startExplosion();
                TweenMax.delayedCall(3, function():void {
                    stopExplosion();
                })
            }
        }
    }

    protected function stopExplosion():void {
        _isExplodingNow = false;
        explosionStopped.dispatch()
    }

    protected function startExplosion():void {
        _isExplodingNow = true;
        explosionStarted.dispatch()
    }

    public function destroy():void {
        _life = 0;
        for each (var block:IMapBlock in _blocks) {
            if (block.type == MapBlockType.UNDER_BIG_OBJECT) {
                var oldState:BlockUnderBigObject = block.state as BlockUnderBigObject;
                block.setState(_mapBlockStateBuilder.make(oldState.typeAfterObjectDestroyed));
                if (oldState.hiddenObject)
                    block.setObject(oldState.hiddenObject);
                else {
                    //todo: won't work with id system
//                    if (oldState.objectAfterObjectDestroyed != DynObjectType.NULL)
//                        EngineContext.objectAdded.dispatch(-1, block.x, block.y, oldState.objectAfterObjectDestroyed)
                }
            }
        }
        destroyed.dispatch();
    }

    public function get explosionStopped():Signal {
        return _explosionStopped;
    }

    public function get explosionStarted():Signal {
        return _explosionStarted;
    }

    public function get destroyed():Signal {
        return _destroyed;
    }

    public function get startLife():int {
        return _startLife
    }

    public static function goldBox(id:int, x:int, y:int, map:IMap, mapBlockStateBuilder:MapBlockStateBuilder, dynObjectBuilder:DynObjectBuilder):SimpleBigObject {
        var xml:XML = getAsBoxXml();
        xml.@id = id
        xml.@x = x;
        xml.@y = y;
        xml.@graphicsId = "l00.bo.goldBox";
        return new SimpleBigObject(xml, map, mapBlockStateBuilder, dynObjectBuilder, int(xml.@life))
    }

    public static function asBox(id:int, x:int, y:int, graphicsId:String, life:int, map:IMap, mapBlockStateBuilder:MapBlockStateBuilder, dynObjectBuilder:DynObjectBuilder):SimpleBigObject {
        var xml:XML = getAsBoxXml();
        xml.@id = id
        xml.@x = x;
        xml.@y = y;
        xml.@graphicsId = graphicsId
        return new SimpleBigObject(xml, map, mapBlockStateBuilder, dynObjectBuilder, life)
    }

    public static function getAsBoxXml():XML {
        if (!_asBoxStr) {
            var file:ByteArray = new asBoxXmlClass();
            _asBoxStr = file.readUTFBytes(file.length);
        }
        return new XML(_asBoxStr);
    }
}
}
