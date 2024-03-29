/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps {
import engine.games.quest.monsters.MonsterType
import engine.games.quest.spawns.MonsterSpawn
import engine.maps.bigObjects.ActivatedBigObject
import engine.maps.bigObjects.BigObjectActivator
import engine.maps.bigObjects.BigObjectBase
import engine.maps.bigObjects.BigObjectLayer
import engine.maps.bigObjects.SimpleBigObject
import engine.maps.bigObjects.SpecialSimpleBigObject
import engine.maps.builders.MapBlockBuilder
import engine.maps.interfaces.IMapBlock
import engine.maps.mapBlocks.MapBlockType
import engine.model.explosionss.ExplosionType
import engine.shadows.ShadowObject
import engine.shadows.ShadowShape

import mx.controls.Alert

public class QuestMap extends MapBase implements IMap{


    private var _monsterSpawns:Array = new Array()


    //blockBuilder is injected via mapBuilder
    public function QuestMap(xml:XML, blockBuilder:MapBlockBuilder) {
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
                    _blocks[index(x, y)] = blockBuilder.make(x, y, MapBlockType.fromChar(rowStr.charCodeAt(x)),true);
                    _blocks[index(x, y)].destroyed.add(function(x:int, y:int, type:MapBlockType):void {
                        _blockDestroyed.dispatch(x, y, type);
                    })
                } catch(er:ArgumentError) {
                    Alert.show("String contains bad symbol " + rowStr.charCodeAt(x));
                }
            }
            y++;
        }

        //bigObjects
        for each (var bObj:XML in xml.bigObjects.BigObject) {
            var bo:BigObjectBase;
            switch (String(bObj.@t)) {
                case "activator":
                    bo = new BigObjectActivator(bObj, this, blockBuilder.mapBlockStateBuilder, blockBuilder.dynObjectBuilder)
                    break
                case "activated":
                    bo = new ActivatedBigObject(bObj, this, blockBuilder.mapBlockStateBuilder, blockBuilder.dynObjectBuilder)
                    break
                case "simple":
                    bo = new SimpleBigObject(bObj, this, blockBuilder.mapBlockStateBuilder, blockBuilder.dynObjectBuilder, bObj.@life)
                    break
                case "special_simple":
                    bo = new SpecialSimpleBigObject(bObj, this, blockBuilder.mapBlockStateBuilder, blockBuilder.dynObjectBuilder, bObj.@life,ExplosionType.byValue(bObj.@explType))
                    break
            }
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
                    throw Context.Exception("Error in file QuestMap.as: impossible case")
            }
        }
        //resolve activators links
        for each (bObj in xml.bigObjects.BigObject) {
            var bo:BigObjectBase = getBO(bObj.@id)
            if (bo is BigObjectActivator) {
                var target:ActivatedBigObject = getBO(bObj.@target) as ActivatedBigObject
                if (target == null) {
                    throw Context.Exception("Error in file QuestMap.as: couldn't find target with id = " + bObj.@target)
                }
                (bo as BigObjectActivator).setTarget(target)
            }
        }
        for each (var spawn:XML in xml.spawns.Spawn) {
            _spawns.push({x:spawn.@x,y:spawn.@y})
        }
        for each (var mSpawn:XML in xml.spawns.MonsterSpawn) {
            _monsterSpawns.push(new MonsterSpawn(mSpawn.@x, mSpawn.@y, MonsterType.byId(mSpawn.@monsterId), mSpawn.@freq,mSpawn.ws[0], mSpawn.@start, mSpawn.@stop, mSpawn.@maxCount))
        }
        //shadows
        for each (var s:XML in xml.shadows.Shadow) {
            _shadows.push(new ShadowObject(s.@x, s.@y, s.@width, s.@height, ShadowShape.fromString(s.@shape)))
        }

    }

    //getters

    public function get monsterSpawns():Array {
        return _monsterSpawns
    }

    public function setDieWall(x:int, y:int):void {
        getBlock(x,y).setDieWall();
    }
}

}
