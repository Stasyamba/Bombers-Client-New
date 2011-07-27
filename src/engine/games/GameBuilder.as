/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.games {
import components.common.worlds.locations.LocationType

import engine.data.quests.Quests
import engine.games.quest.QuestGame
import engine.games.quest.EngineQuestObject
import engine.games.quest.medals.Medal
import engine.games.quest.monsters.MonsterType
import engine.games.quest.monsters.walking.WalkingStrategy
import engine.games.regular.RegularGame
import engine.maps.builders.DynObjectBuilder
import engine.maps.interfaces.IMapBlock
import engine.maps.mapBlocks.MapBlockType
import engine.maps.mapObjects.DynObjectType
import engine.maps.mapObjects.NullDynObject
import engine.playerColors.PlayerColor
import engine.profiles.PlayerGameProfile

public class GameBuilder {
    public function GameBuilder() {
    }

    private function getColor(slot:int):PlayerColor {
        switch (slot) {
            case 3:
                return PlayerColor.BLUE;
            case 2:
                return PlayerColor.ORANGE;
            case 1:
                return PlayerColor.PINK;
            case 0:
                return PlayerColor.RED;

        }
        throw Context.Exception("Error in file GameBuilder.as: No more colors")
    }

    public function makeRegular(mapId:int, location:LocationType, playerProfiles:Array, bonuses:Array):IGame {
        var game:RegularGame = new RegularGame(location);
        for each (var prof:PlayerGameProfile in playerProfiles) {
            game.addPlayer(prof, prof.color)
        }

        game.applyMap(String(mapId), playerProfiles, bonuses)
        return game;
    }

    public function makeQuest(quest:EngineQuestObject, gameId:String):IGame {
        var xml:XML = Quests.questXml(quest.id)
        var game:QuestGame = new QuestGame(gameId, quest);

        var plSpawn:XML = xml.map.Map.spawns.Spawn[0]
        game.addPlayer(plSpawn.x, plSpawn.y, getColor(0))

        for each (var m:XML in xml.monsters.Monster) {
            game.addMonster(m.@x, m.@y, MonsterType.byId(m.@monsterId), WalkingStrategy.xml(m.ws[0]), m.@slot != null ? m.@slot : -1)
        }

        game.applyMapXml(xml.map.Map[0])

        for each (var obj:XML in xml.map.Map.objects.Object) {
            game.addObject(-1, obj.@x, obj.@y, DynObjectType.byValue(int(obj.@id)),DynObjectBuilder.params(obj))
        }

        for each (var rand:XML in xml.map.Map.objects.Random) {
            var count:int = int(rand.@count)
            var id:int = int(rand.@id)
            for (var i:int = 0; i < count; i++) {
                var b:IMapBlock;
                switch (String(rand.@hide)) {
                    case "box":
                        b = game.mapManager.map.getRandomBlock(function(b:IMapBlock):Boolean {
                            return b.type == MapBlockType.BOX && b.hiddenObject == NullDynObject.getInstance()
                        })
                        break;
                    case "free":
                        b = game.mapManager.map.getRandomBlock(function(b:IMapBlock):Boolean {
                            return b.type == MapBlockType.FREE && b.object == NullDynObject.getInstance() && game.playerManager.me.coords.block() != b
                        })
                }
                game.addObject(-1, b.x, b.y, DynObjectType.byValue(id))
            }
        }
        if (quest.hasCommonGoal)
            game.addGoal(null,quest.commonGoal)
        game.addGoal(Medal.BRONZE, quest.bronzeMedal.goal);
        game.addGoal(Medal.SILVER, quest.silverMedal.goal);
        game.addGoal(Medal.GOLD, quest.goldMedal.goal);


        return game;
    }
}
}