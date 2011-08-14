/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps {
import engine.maps.bigObjects.ActivatedBigObject
import engine.maps.bigObjects.BigObjectActivator
import engine.maps.bigObjects.BigObjectBase
import engine.maps.bigObjects.BigObjectLayer
import engine.maps.bigObjects.SimpleBigObject
import engine.maps.bigObjects.SpecialSimpleBigObject
import engine.maps.builders.MapBlockBuilder
import engine.maps.interfaces.IMapBlock
import engine.maps.mapBlocks.MapBlock
import engine.maps.mapBlocks.MapBlockType
import engine.model.explosionss.ExplosionType
import engine.shadows.ShadowObject
import engine.shadows.ShadowShape

import mx.controls.Alert

public class Map extends MapBase implements IMap {

    //blockBuilder is injected via mapBuilder
    public function Map(xml:XML, blockBuilder:MapBlockBuilder) {
        this.blockBuilder = blockBuilder;
        fill(xml);
    }

    public function fill(xml:XML):void {

        _width = xml.size.@width;
        _height = xml.size.@height;

        _blocks = new Vector.<IMapBlock>(_width * _height, true);

        var y:int = 0;
        for each (var rowXml:XML in xml.rows.Row) {
            var rowStr:String = rowXml.@val;
            for (var x:int = 0; x < rowStr.length; x++) {
                try {
                    _blocks[index(x, y)] = blockBuilder.make(x, y, MapBlockType.fromChar(rowStr.charCodeAt(x)));
                    _blocks[index(x, y)].destroyed.add(function(x:int, y:int, type:MapBlockType):void {
                        _blockDestroyed.dispatch(x, y, type);
                    })
                } catch(er:ArgumentError) {
                    Alert.show("String contains bad symbol " + rowStr.charCodeAt(x));
                }
            }
            y++;
        }

        var bcId:int = 0;
        for each (var obj:XML in xml.objects.object) {
            switch (String(obj.@type)) {
                case "bonusContainer":
                    var b:MapBlock = getBlock(obj.@x, obj.@y) as MapBlock;
                    b.setGold();
//                    var bo:SimpleBigObject = SimpleBigObject.goldBox(bcId, obj.@x, obj.@y, this, blockBuilder.mapBlockStateBuilder, blockBuilder.dynObjectBuilder);
//                    bcId++;
//                    addBO(bo)
                    break;
                case "200":

//                    var sbo:SimpleBigObject;
//                    if (obj.@destroysBy.toString() != "")
//                        sbo = SpecialSimpleBigObject.asBox(bcId, obj.@x, obj.@y, obj.@graphicsId, int(obj.@life), this, blockBuilder.mapBlockStateBuilder, blockBuilder.dynObjectBuilder);
//                    else
//                        sbo = SimpleBigObject.asBox(bcId, obj.@x, obj.@y, obj.@graphicsId, int(obj.@life), this, blockBuilder.mapBlockStateBuilder, blockBuilder.dynObjectBuilder)
//                    bcId++;
//                    addBO(sbo)
                    break;
            }
        }
        //bigObjects
        for each (var bObj:XML in xml.bigObjects.BigObject) {
            var bbo:BigObjectBase;
            switch (String(bObj.@t)) {
                case "activator":
                    bbo = new BigObjectActivator(bObj, this, blockBuilder.mapBlockStateBuilder, blockBuilder.dynObjectBuilder)
                    break
                case "activated":
                    bbo = new ActivatedBigObject(bObj, this, blockBuilder.mapBlockStateBuilder, blockBuilder.dynObjectBuilder)
                    break
                case "simple":
                    bbo = new SimpleBigObject(bObj, this, blockBuilder.mapBlockStateBuilder, blockBuilder.dynObjectBuilder, bObj.@life)
                    break
                case "special_simple":
                    bbo = new SpecialSimpleBigObject(bObj, this, blockBuilder.mapBlockStateBuilder, blockBuilder.dynObjectBuilder, bObj.@life, ExplosionType.byValue(bObj.@explType))
                    break
            }
            addBO(bbo)
        }
        //resolve activators links
        for each (bObj in xml.bigObjects.BigObject) {
            var bbbo:BigObjectBase = getBO(bObj.@id)
            if (bbbo is BigObjectActivator) {
                var target:ActivatedBigObject = getBO(bObj.@target) as ActivatedBigObject
                if (target == null) {
                    throw Context.Exception("Error in file Map.as: couldn't find target with id = " + bObj.@target)
                }
                (bbbo as BigObjectActivator).setTarget(target)
            }
        }
        for each (var spawn:XML in xml.spawns.Spawn) {
            _spawns.push({x:spawn.@x,y:spawn.@y})
        }

        //shadows
        for each (var s:XML in xml.shadows.Shadow) {
            _shadows.push(new ShadowObject(s.@x, s.@y, s.@width, s.@height, ShadowShape.fromString(s.@shape)))
        }
    }

    public function addBO(bo:BigObjectBase):void {
        _bigObjects[bo.id] = bo
        switch (bo.layer) {
            case BigObjectLayer.DECORATION:
                decorations.push(bo)
                break
            case BigObjectLayer.HIGHER:
                higherBigObjects.push(bo);
                break
            case BigObjectLayer.LOWER:
                lowerBigObjects.push(bo);
                break
            default:
                throw Context.Exception("Error in file Map.as: impossible case")
        }
    }


    public function setDieWall(x:int, y:int):void {
        for each (var sbo:BigObjectBase in _bigObjects) {
            if(sbo is SimpleBigObject && sbo.x == x && sbo.y == y){
                (sbo as SimpleBigObject).destroy();
            }
        }
        getBlock(x, y).setDieWall();
    }
}
}