/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.games.quest {
import components.common.resources.ResourcePrice;
import components.common.resources.ResourceType;
import components.common.worlds.locations.LocationType;

import engine.EngineContext;
import engine.bombers.CreatureBase;
import engine.bombers.PlayersBuilder;
import engine.bombers.QuestPlayerBomber;
import engine.bombers.interfaces.IBomber;
import engine.explosionss.ExplosionPoint;
import engine.explosionss.ExplosionsBuilder;
import engine.explosionss.interfaces.IExplosion;
import engine.games.*;
import engine.games.quest.goals.CollectedDOObject;
import engine.games.quest.goals.DefeatedMonsterObject;
import engine.games.quest.goals.DestroyedMapBlockObject;
import engine.games.quest.goals.IGoal;
import engine.games.quest.medals.Medal;
import engine.games.quest.monsters.Monster;
import engine.games.quest.monsters.MonsterType;
import engine.games.quest.monsters.walking.IWalkingStrategy;
import engine.maps.builders.DynObjectBuilder;
import engine.maps.builders.MapBlockBuilder;
import engine.maps.builders.MapBlockStateBuilder;
import engine.maps.interfaces.IDynObject;
import engine.maps.interfaces.IDynObjectType;
import engine.maps.interfaces.IMapBlock;
import engine.maps.mapBlocks.MapBlockType;
import engine.model.managers.quest.MonstersManager;
import engine.model.managers.quest.QuestDOManager;
import engine.model.managers.quest.QuestExplosionsManager;
import engine.model.managers.quest.QuestMapManager;
import engine.model.managers.quest.QuestPlayerManager;
import engine.playerColors.PlayerColor;
import engine.profiles.GameProfile;
import engine.profiles.PlayerGameProfile;
import engine.weapons.WeaponBuilder;
import engine.weapons.WeaponType;
import engine.weapons.interfaces.IActivatableWeapon;

import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

import greensock.TweenMax;

import mx.collections.ArrayList;

public class QuestGame extends GameBase implements IQuestGame {

    private var _gameStats:GameStats = new GameStats();

    private var _gameId:String
    private var _questObject:EngineQuestObject

    private var _monstersManager:MonstersManager

    private var _bronzeGoal:IGoal
    private var _silverGoal:IGoal
    private var _goldGoal:IGoal

    private var _commonGoal:IGoal
    private var _hasCommonGoal:Boolean;
    private var _currentMedals:Array = new Array();

    private var _time:int = 0
    private var _timeTimer:Timer

    private var _timeOutTween:TweenMax;
    private var _medalTimes:Object = new Object();

    public function QuestGame(gameId:String, quest:EngineQuestObject) {
        super(LocationType.byValue(quest.locationId))
        _gameId = gameId
        _questObject = quest

        mapBlockStateBuilder = new MapBlockStateBuilder();
        dynObjectBuilder = new DynObjectBuilder();
        mapBlockBuilder = new MapBlockBuilder(mapBlockStateBuilder, dynObjectBuilder)

        _mapManager = new QuestMapManager(mapBlockBuilder);

        explosionsBuilder = new ExplosionsBuilder(mapManager);
        dynObjectBuilder.setExplosionsBuilder(explosionsBuilder)

        _playerManager = new QuestPlayerManager();
        _monstersManager = new MonstersManager(_playerManager);

        _explosionsManager = new QuestExplosionsManager(explosionsBuilder, mapManager, playerManager, monstersManager);
        _dynObjectManager = new QuestDOManager(playerManager, monstersManager, mapManager);
        weaponBuilder = new WeaponBuilder(_mapManager)
        playersBuilder = new PlayersBuilder(weaponBuilder)

        //game events
        Context.gameModel.questStarted.addOnce(function():void {

            EngineContext.frameEntered.add(playerManager.movePlayer);
            EngineContext.frameEntered.add(monstersManager.moveMonsters);
            EngineContext.frameEntered.add(explosionsManager.checkExplosions);
            EngineContext.frameEntered.add(dynObjectManager.checkObjectsActivated);
            EngineContext.frameEntered.add(monstersManager.checkMonstersHitPlayer);
            EngineContext.frameEntered.add((playerManager as QuestPlayerManager).checkPlayerMetActiveBlock);

            EngineContext.qActivateWeapon.add(onWeaponUsed);

            EngineContext.qAddObject.add(addObject)
            EngineContext.qPlayerActivateObject.add(onPlayerActivateObject);
            EngineContext.qMonsterActivateObject.add(onMonsterActivateObject);

            EngineContext.qMonsterDied.add(onMonsterDied);

            EngineContext.explosionGroupAdded.add(onExplosionsAdded)
            EngineContext.explosionsRemoved.add(onExplosionsRemoved)


            EngineContext.qNeedToAddMonster.add(onNeedToAddMonster)

            //goals
            EngineContext.frameEntered.add(checkFinishOnGoals);

            Context.gameModel.questCompleted.addOnce(onQuestCompleted)

            EngineContext.playerDied.add(onPlayerDied)
            EngineContext.qTimeOut.add(onTimeOut)
            Context.gameModel.questFailed.addOnce(onQuestFailed)

            Context.gameModel.questEnded.addOnce(onEndedGE)
            Context.gameModel.leftQuest.addOnce(onEndedLG)

            if (questObject.timeLimit > 0) {
                _timeOutTween = TweenMax.delayedCall(questObject.timeLimit, EngineContext.qTimeOut.dispatch)
            }

            _timeTimer = new Timer(1000, questObject.timeLimit)
            _timeTimer.addEventListener(TimerEvent.TIMER, onTimeTimer)
            _timeTimer.start()
        })

    }

    private function onTimeTimer(e:Event):void {
        _time++;
    }

    private function onTimeOut():void {
        if (!Context.gameModel.isPlayingNow) return;
        Context.gameModel.isPlayingNow = false
        if (_questObject.finishOnGoal)
            Context.gameModel.questFailed.dispatch(QuestFailReason.TIME)
        else {
            if (_currentMedals.length > 0)
                Context.gameModel.questCompleted.dispatch(_currentMedals)
            else
                Context.gameModel.questFailed.dispatch(QuestFailReason.TIME)
        }
    }

    protected function onExplosionsRemoved(expls:ArrayList):void {
        for each (var e:IExplosion in expls.source)
            e.forEachPoint(function (point:ExplosionPoint):void {
                var b:IMapBlock = mapManager.map.getBlock(point.x, point.y);
                b.stopExplosion();
            })
    }

    private function onQuestFailed(qfr:QuestFailReason):void {
        //Alert.show(qfr.text);
        Context.gameModel.questCompleted.removeAll()
        Context.gameModel.questFailed.removeAll()
        TweenMax.delayedCall(2, Context.gameModel.fadeOutGameView.dispatch)
        TweenMax.delayedCall(4, function():void {
            Context.gameModel.questEnded.dispatch(false, [])
        })

    }

    private function onPlayerDied():void {
        if (!Context.gameModel.isPlayingNow) return;
        Context.gameModel.isPlayingNow = false;

        if (_questObject.finishOnGoal)
            Context.gameModel.questFailed.dispatch(QuestFailReason.DEATH)
        else {
            if (_currentMedals.length > 0)
                Context.gameModel.questCompleted.dispatch(_currentMedals)
            else
                Context.gameModel.questFailed.dispatch(QuestFailReason.TIME)
        }
    }


    private function onEndedGE(p1:*, p2:*):void {
        destroy()
        Context.gameModel.leftQuest.remove(onEndedLG)
    }

    private function destroy():void {
        EngineContext.frameEntered.remove(checkFinishOnGoals);
        EngineContext.frameEntered.remove(playerManager.movePlayer);
        EngineContext.frameEntered.remove(monstersManager.moveMonsters);
        EngineContext.frameEntered.remove(explosionsManager.checkExplosions);
        EngineContext.frameEntered.remove(dynObjectManager.checkObjectsActivated);
        EngineContext.frameEntered.remove(monstersManager.checkMonstersHitPlayer);
        EngineContext.frameEntered.remove((playerManager as QuestPlayerManager).checkPlayerMetActiveBlock);

        if (_timeOutTween != null) {
            _timeOutTween.kill()
            _timeOutTween = null
        }

        if (_timeTimer != null) {
            _timeTimer.stop()
            _timeTimer.removeEventListener(TimerEvent.TIMER, onTimeTimer)
            _timeTimer = null
        }
    }

    private function onEndedLG():void {
        destroy()
        Context.gameModel.questEnded.remove(onEndedGE)
    }

    private function onMonsterDied(m:Monster):void {
        gameStats.defeatedMonsters.addItem(new DefeatedMonsterObject(m.slot, m.monsterType))
    }

    public function addObject(slot:int, x:int, y:int, type:IDynObjectType, params:Object = null):void {
        var b:IMapBlock = mapManager.map.getBlock(x, y);
        var player:IBomber = getPlayer(slot) as IBomber

        var object:IDynObject = dynObjectBuilder.make(0, type, b, player, params);
        b.setObject(object)

        if (type.waitToAdd > 0)
            TweenMax.delayedCall(type.waitToAdd, function():void {
                dynObjectManager.addObject(object);
            })
        else
            dynObjectManager.addObject(object);
    }

    private function onPlayerActivateObject(id:int, x:int, y:int, objType:IDynObjectType, params:Object = null):void {
        var bomber:IBomber = getPlayer(id) as IBomber;
        dynObjectManager.activateObject(x, y, bomber, params);
        gameStats.collectedObjects.addItem(new CollectedDOObject(objType, x, y))
    }

    private function onMonsterActivateObject(id:int, x:int, y:int, objType:IDynObjectType, params:Object = null):void {
        //now it does nothing
        throw Context.Exception("Error in file QuestGame.as: for now monsters aren't allowed to activate objects")
    }

    private function onQuestCompleted(medals:Array):void {
        //Alert.show("task accomplished with medal " + medal.string);
        Context.gameModel.questCompleted.removeAll()
        Context.gameModel.questFailed.removeAll()
        TweenMax.delayedCall(2, Context.gameModel.fadeOutGameView.dispatch)
        TweenMax.delayedCall(4, function():void {
            Context.gameModel.questEnded.dispatch(true, medals);
        })
    }

    private function checkFinishOnGoals(p0:int):Boolean {
        if (!Context.gameModel.isPlayingNow) return false;

        if (_hasCommonGoal) {
            if (_commonGoal.check(this)) {
                Context.gameModel.isPlayingNow = false
                var arr:Array = checkMedalGoals();
                for each (var m:Medal in arr) {
                    if (m != null) {
                        if (!hasMedal(m))
                            _medalTimes[m.value] = _time;
                    }
                }
                Context.gameModel.questCompleted.dispatch(arr)
                return true;
            }
        } else {
            var arr:Array = checkMedalGoals();
            for each (var m:Medal in arr) {
                if (m != null) {
                    if (_questObject.finishOnGoal) {
                        _medalTimes[m.value] = _time;
                        Context.gameModel.isPlayingNow = false
                        Context.gameModel.questCompleted.dispatch([m])
                        return true;
                    } else {
                        if (!hasMedal(m)) {
                            _currentMedals.push(m)
                            _medalTimes[m.value] = _time;
                        }
                    }
                }
            }

        }
        return false
    }

    private function hasMedal(m:Medal):Boolean {
        for (var i:int = 0; i < _currentMedals.length; i++) {
            var medal:Medal = _currentMedals[i];
            if (m == medal)
                return true
        }
        return false
    }

    private function checkMedalGoals():Array {
        var medals:Array = new Array()

        if (_bronzeGoal.check(this))
            medals.push(Medal.BRONZE)
        if (_silverGoal.check(this))
            medals.push(Medal.SILVER)
        if (_goldGoal.check(this))
            medals.push(Medal.GOLD)
        return medals
    }

    private function onWeaponUsed(slot:int, x:int, y:int, type:WeaponType):void {

        var b:QuestPlayerBomber = getPlayer(slot) as QuestPlayerBomber;
        if (b != null) {
            b.activateWeapon(x, y, type);
        } else {
            var w:IActivatableWeapon = _weaponsUsed[type.value]
            if (w != null) {
                w.qActivateStatic(x, y, b)
                return
            }
            w = weaponBuilder.fromWeaponType(type, 0) as IActivatableWeapon
            if (w == null)
                throw Context.Exception("Error in file QuestGame.as: wrong weapon type " + type.key + ". IActivatable weapon expected")
            w.qActivateStatic(x, y, b)
            _weaponsUsed[type.value] = w
        }
    }

    public function addGoal(medal:Medal, goal:IGoal):void {
        if (goal == null)
            throw Context.Exception("Error in file QuestGame.as: goal == null")
        trace(medal, Medal.BRONZE, Medal.SILVER, Medal.GOLD)
        if (medal == null) {
            _commonGoal = goal
            _hasCommonGoal = true;
        } else {
            switch (medal) {
                case Medal.BRONZE:
                    _bronzeGoal = goal
                    break
                case Medal.SILVER:
                    _silverGoal = goal
                    break
                case Medal.GOLD:
                    _goldGoal = goal
                    break
                default:
                    throw Context.Exception("Error in file QuestGame.as:no such medal: " + medal.value)
            }
        }
    }

    public function addPlayer(x:int, y:int, color:PlayerColor):void {
        var gp:GameProfile = Context.Model.currentSettings.gameProfile
        playerManager.setPlayer(playersBuilder.makeQuestPlayer(this, gp, new PlayerGameProfile(1, gp.currentBomberType, x, y, gp.aursTurnedOn, color), color));
    }

    private function onNeedToAddMonster(monsterType:MonsterType, x:int, y:int, ws:IWalkingStrategy):void {
        addMonster(x, y, monsterType, ws)
    }


    public function addMonster(x:int, y:int, monsterType:MonsterType, walkingStrategy:IWalkingStrategy, slot:int = -1):void {
        var monster:Monster = playersBuilder.makeMonster(this, x, y, slot > 0 ? slot : monstersManager.getNewSlot(), monsterType, walkingStrategy)
        monster.putOnMap(mapManager.map, monster.startX, monster.startY)
        monstersManager.addMonster(monster)
        EngineContext.qMonsterAdded.dispatch(monster)
    }


    public function applyMapXml(map:XML):void {
        mapManager.make(map);
        playerManager.me.putOnMap(mapManager.map, mapManager.map.spawns[0].x, mapManager.map.spawns[0].y);
        monstersManager.forEachAliveMonster(function(monster:Monster, slot:int):void {
            monster.putOnMap(mapManager.map, monster.startX, monster.startY)
        })
        mapManager.map.blockDestroyed.add(function(x:int, y:int, type:MapBlockType):void {
            gameStats.destroyedBlocks.addItem(new DestroyedMapBlockObject(type, x, y));
        })
        _ready = true;
    }

    public function getPlayer(slot:int):CreatureBase {
        if (slot == playerManager.mySlot)
            return playerManager.me as CreatureBase;
        return monstersManager.getMonsterBySlot(slot);
    }

    public function get monstersManager():MonstersManager {
        return _monstersManager
    }

    public function get questObject():EngineQuestObject {
        return _questObject
    }

    public function get type():GameType {
        return GameType.QUEST;
    }

    public function get gameStats():GameStats {
        return _gameStats;
    }

    public function get location():LocationType {
        return _location
    }

    public function get gameId():String {
        return _gameId
    }

    public function get timePassed():int {
        return _time
    }

    public function get bestMedalTime():int {
        if(_medalTimes[Medal.GOLD.value])
            return _medalTimes[Medal.GOLD.value]
        if(_medalTimes[Medal.SILVER.value])
            return _medalTimes[Medal.SILVER.value]
        if(_medalTimes[Medal.BRONZE.value])
            return _medalTimes[Medal.BRONZE.value]
        return int.MAX_VALUE;
    }

    public function resourceCollected(rt:ResourceType, count:int, player:IBomber):void {
        if (player == playerManager.me && rt == ResourceType.GOLD) {
            _gameStats.goldCollected += count;
        }
    }
}
}









