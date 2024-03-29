/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model {
import components.common.base.expirance.ExperianceObject;
import components.common.items.ItemProfileObject;
import components.common.items.categories.ItemCategory;
import components.common.quests.QuestBestPlayer;
import components.common.quests.QuestObject;
import components.common.quests.medals.MedalType;
import components.common.quests.regard.RegardObject;
import components.common.quests.regard.RegardType;
import components.common.quests.tasks.TaskObject;
import components.common.resources.ResourceObject;
import components.common.resources.ResourceType;
import components.common.worlds.locations.LocationType;

import engine.EngineContext;
import engine.data.quests.Quests;
import engine.games.GameBuilder;
import engine.games.GameType;
import engine.games.quest.EngineQuestObject;
import engine.games.quest.QuestFailReason;
import engine.games.quest.medals.MedalBase;
import engine.model.signals.GameEndedSignal;
import engine.model.signals.GameReadySignal;
import engine.model.signals.MapLoadedSignal;
import engine.model.signals.ReadyToPlayAgainSignal;
import engine.model.signals.manage.GameStartedSignal;
import engine.model.signals.manage.JoinedToGameSignal;
import engine.model.signals.manage.JoinedToRoomSignal;
import engine.model.signals.manage.LeftGameSignal;
import engine.model.signals.manage.PlayerReadyChangedSignal;
import engine.model.signals.manage.ReadyToCreateGameSignal;
import engine.model.signals.manage.SomeoneJoinedToGameSignal;
import engine.model.signals.manage.SomeoneLeftGameSignal;
import engine.model.signals.manage.ThreeSecondsToStartSignal;
import engine.profiles.GameProfile;
import engine.profiles.LobbyProfile;
import engine.profiles.PlayerGameProfile;

import flash.system.Security;

import greensock.TweenMax;
import greensock.loading.ImageLoader;
import greensock.loading.LoaderMax;
import greensock.loading.SWFLoader;
import greensock.loading.XMLLoader;

import loading.BombersContentLoader;
import loading.ServerQuestObject;

import mx.controls.Alert;
import mx.utils.ObjectUtil;

import org.osflash.signals.Signal;

public class GameModel {


    private var gameBuilder:GameBuilder = new GameBuilder();

    //---signals
    public var fastJoinFailed:Signal = new Signal();
    public var createGameFailed:Signal = new Signal()
    public var someoneJoinedToGame:SomeoneJoinedToGameSignal = new SomeoneJoinedToGameSignal();
    public var someoneLeftGame:SomeoneLeftGameSignal = new SomeoneLeftGameSignal();
    public var leftGame:LeftGameSignal = new LeftGameSignal();

    public var playerReadyChanged:PlayerReadyChangedSignal = new PlayerReadyChangedSignal();

    public var threeSecondsToStart:ThreeSecondsToStartSignal = new ThreeSecondsToStartSignal();
    public var mapLoaded:MapLoadedSignal = new MapLoadedSignal();
    public var gameReady:GameReadySignal = new GameReadySignal();

    public var gameStarted:GameStartedSignal = new GameStartedSignal();
    public var gameEnded:GameEndedSignal = new GameEndedSignal();
    public var readyToPlayAgain:ReadyToPlayAgainSignal = new ReadyToPlayAgainSignal();


    public var readyToCreateGame:ReadyToCreateGameSignal = new ReadyToCreateGameSignal();

    //quest
    public var questGameCreated:Signal = new Signal()
    public var createQuestFailed:Signal = new Signal()
    public var questCompleted:Signal = new Signal(Array)
    public var questFailed:Signal = new Signal(QuestFailReason)
    public var leftQuest:Signal = new Signal()
    public var questStarted:Signal = new Signal()
    public var questEnded:Signal = new Signal(Boolean, Array) //success,medals
    public var questReady:Signal = new Signal()


    //not used now
    public var joinedToRoom:JoinedToRoomSignal = new JoinedToRoomSignal();
    public var joinedToGameRoom:JoinedToGameSignal = new JoinedToGameSignal();


    public var fadeOutGameView:Signal = new Signal()

    // fields
    private var _currentLocation:LocationType
    private var _gameType:GameType;
    public var lobbyProfiles:Array
    public var lastGameLobbyProfiles:Array
    public var playerGameProfiles:Array
    public var createdByMe:Boolean

    public var gameName:String
    public var gamePass:String
    public var isPlayingNow:Boolean = false

    private var _quests:Array = new Array()
    private var _questId:String
    private var _gameId:String

    public var serverQuests:Array;

    function GameModel() {
    }

    //----------init-------------

    public function init():void {
        LoaderMax.activate([XMLLoader,SWFLoader,ImageLoader])
        Security.allowDomain("*")

        BombersContentLoader.questsLoaded.add(fillQuests)
        BombersContentLoader.loadBombers()
        BombersContentLoader.loadQuests()
        BombersContentLoader.loadMonsters()
        BombersContentLoader.loadBO()

        BombersContentLoader.readyToUseAppView.addOnce(function() {
            BombersContentLoader.loadGraphics()
            BombersContentLoader.loadSounds()

            Context.gameServer.connected.add(onGameServerConnected);
            Context.gameServer.loggedIn.add(onLoggedIn);
            Context.gameServer.connectDefault();
            Context.gameServer.profileLoaded.add(onProfileLoaded);
        })
    }

    private function getServerQuest(id:String):ServerQuestObject {
        for each (var sqo:ServerQuestObject in serverQuests) {
            if (sqo.id == id)
                return sqo;
        }
        return null
    }

    public function fillServerQuestData():void {
        for each (var qo:QuestObject in Context.Model.questManager.getAllQuests()) {
            var sqo:ServerQuestObject = getServerQuest(qo.id);
            if (sqo != null) {
                qo.energyCost = sqo.energyCost
                for (var i:int = 0; i < 3; i++) {
                    qo.tasks[i].regards = sqo.rewards[i];
                }
            }
        }
    }

    private function fillQuests():void {
        for each(var name:String in Quests.questsNames) {
            var xml:XML = Quests.questXml(name)
            var q:EngineQuestObject = new EngineQuestObject(xml);
            _quests.push(q)
        }
        var compare_quest:Function = function(q1:EngineQuestObject, q2:EngineQuestObject):int {
            if (q1.id < q2.id) return -1
            if (q1.id > q2.id) return 1
            return 0
        }
        _quests = _quests.sort(compare_quest)
        var _commonQuests:Array = _quests.map(
                function (item:EngineQuestObject, index:int, array:Array):QuestObject {
                    var tasks:Array;

                    tasks = [item.goldMedal,item.silverMedal,item.bronzeMedal].map(function (medal:MedalBase, index:int, array:Array):TaskObject {
                        var rewards:Array = medal.prizes.map(function (reward:*, index:int, array:Array):RegardObject {
                            if (reward is ResourceObject) {
                                var ro:ResourceObject = reward
                                switch (ro.type) {
                                    case ResourceType.ADAMANT:
                                        return new RegardObject(RegardType.RESOURCE_ADAMANT, ro.value)
                                    case ResourceType.ANTIMATTER:
                                        return new RegardObject(RegardType.RESOURCE_ANTIMATTER, ro.value)
                                    case ResourceType.GOLD:
                                        return new RegardObject(RegardType.RESOURCE_GOLD, ro.value)
                                    case ResourceType.CRYSTALS:
                                        return new RegardObject(RegardType.RESOURCE_CRYSTALS, ro.value)
                                    case ResourceType.ENERGY:
                                        return new RegardObject(RegardType.RESOURCE_ENERGY, ro.value)
                                }
                            } else if (reward is ExperianceObject)
                                return new RegardObject(RegardType.RESOURCE_EXP, (reward as ExperianceObject).experiance)
                            else if (reward is ItemProfileObject)
                                return new RegardObject(RegardType.RESOURCE_ITEM, 1, (reward as ItemProfileObject).itemCount)
                            throw Context.Exception("Error in file GameModel.as: Unknown reward")
                        })
                        return new TaskObject(index, medal.text, rewards, MedalType.byValue(index))
                    })

                    return new QuestObject(item.id, item.locationId, item.imageURL, item.name, item.energyCost, item.accessRules, tasks, item.description, item.previewImageURL, item.timeLimit)

                })
			
        Context.Model.questManager.addQuests(_commonQuests)
    }

    public function getQuestObject(id:String):EngineQuestObject {
        for each (var q:EngineQuestObject in _quests) {
            if (q.id == id)
                return q
        }
        throw Context.Exception("Error in file GameModel.as: no quest with id = " + id)
    }

    private function onGameServerConnected():void {
        Context.gameServer.login(Context.Model.currentSettings.socialProfile.id, Context.Model.currentSettings.flashVars.auth_key);
        Context.gameServer.disconnected.addOnce(onServerDisconnected)
    }

    //----------singleplayer-----------

    public function tryCreateQuest(questId:String, locationType:LocationType):void {
//        todo: uncomment
//        Context.gameServer.createQuestRequest(questId, locationType.value)
        questGameCreated.addOnce(onQuestCreated)
        createQuestFailed.addOnce(onCreateQuestFailed)
        createdByMe = true
        _gameType = GameType.QUEST
        _currentLocation = locationType

        //todo: imitation
        questGameCreated.dispatch(questId, 666)
    }

    private function createQuestGame(questId:String, gameId:String):void {

        Context.game = gameBuilder.makeQuest(getQuestObject(questId), gameId);
        threeSecondsToStart.dispatch(null, 0, null)
    }

    public function startCurrentQuest():void {

        questStarted.addOnce(function():void {
            isPlayingNow = true
            questEnded.addOnce(function(p1:*, p2:*):void {
                endQuest()
            })
        })

        threeSecondsToStart.addOnce(function(p0:*, p1:*, p2:*):void {
            questReady.dispatch()
            TweenMax.delayedCall(3, function():void {
                questStarted.dispatch();
            })
        })

        if (readyToCreateQuest()) {
            TweenMax.delayedCall(0.2, createQuestGame, [_questId, _gameId])
        } else {
            var taskSignal:Signal = new Signal()
            taskSignal.addOnce(function():void {
                createQuestGame(_questId, _gameId)
            })
            BombersContentLoader.addTask(taskSignal, [currentLocation.stringId,"common"])

        }
    }

    private function endQuest():void {
        _questId = null
        _gameId = null;
        isPlayingNow = false
        Context.Model.dispatchCustomEvent(ContextEvent.GPAGE_MY_PARAMETERS_IS_CHANGED);
        EngineContext.clear()
    }

    // quest handlers
    private function onQuestCreated(questId:String, gameId:String):void {
        createQuestFailed.removeAll()
        questGameCreated.removeAll()
        leftQuest.add(onLeftQuest)
        _questId = questId;
        _gameId = gameId;
    }

    private function onLeftQuest():void {
        endQuest()

        createQuestFailed.removeAll()
        questGameCreated.removeAll()
        leftQuest.removeAll()
        questCompleted.removeAll()
        questFailed.removeAll()
        threeSecondsToStart.removeAll()
        questReady.removeAll()
        questStarted.removeAll()
        questEnded.removeAll()
    }

    private function readyToCreateQuest():Boolean {
        return Context.imageService.isLoaded(currentLocation.stringId) && Context.imageService.isLoaded("common");
    }


    private function onCreateQuestFailed():void {
        questGameCreated.removeAll()
        createQuestFailed.removeAll()
        _gameType = null
        _currentLocation = null
    }

    public function leaveCurrentQuest():void {
        leftQuest.dispatch();
    }

    //----------multiplayer-----------

    public function leaveCurrentGame():void {
        Context.gameServer.leaveCurrentGame();
        leftGame.dispatch();
    }

    public function tryCreateRegularGame(name:String, pass:String, location:LocationType):void {
        Context.gameServer.createNewGameRequest(name, pass, location.value)
        someoneJoinedToGame.addOnce(onJoinedToGame)
        createGameFailed.addOnce(onFastJoinFailed)
        createdByMe = true;
        gameName = name
        gamePass = pass
        _gameType = GameType.REGULAR
        _currentLocation = location
    }

    public function fastJoin(locationId:int = -1):void {
        Context.gameServer.fastJoinRequest(locationId);
        someoneJoinedToGame.addOnce(onJoinedToGame)
        fastJoinFailed.addOnce(onFastJoinFailed)
        createdByMe = false;
        _gameType = GameType.REGULAR
        if (locationId >= 0) {
            _currentLocation = LocationType.byValue(locationId)
        }
    }

    public function joinConcreteGame(name:String, pass:String):void {
        Context.gameServer.concreteJoinRequest(name, pass);
        someoneJoinedToGame.addOnce(onJoinedToGame)
        fastJoinFailed.addOnce(onFastJoinFailed)
        createdByMe = false;
        gameName = name
        gamePass = pass
        _gameType = GameType.REGULAR

    }

    public function cancelConnectingToGame():void {
        _gameType = null
        onLeftGame()
    }

    public function setMeReady(ready:Boolean):void {
        Context.gameServer.setReadyRequest(ready);
    }


    //--------------------------------HANDLERS--------------------------------

    private function onServerDisconnected():void {
        onLeftGame()
        BombersContentLoader.stopAll()
    }

    private function onProfileLoaded(profile:GameProfile):void {
        Context.Model.currentSettings.gameProfile = profile
        Context.Model.currentSettings.gameProfileLoaded = true;

        if (profile.photoURL == "") {
            if (
                    profile.id != "test1" &&
                            profile.id != "test2" &&
                            profile.id != "test3" &&
                            profile.id != "test4" &&
                            profile.id != "test5") {
                Context.gameServer.sendSetPhotoRequest(Context.Model.currentSettings.socialProfile.photoURL)
            }

            Context.Model.currentSettings.gameProfile.photoURL = Context.Model.currentSettings.socialProfile.photoURL
        }

        Context.Model.dispatchCustomEvent(ContextEvent.GP_AURS_TURNED_ON_IS_CHANGED)
        Context.Model.dispatchCustomEvent(ContextEvent.GP_CURRENT_LEFT_WEAPON_IS_CHANGED)
        Context.Model.dispatchCustomEvent(ContextEvent.GP_ENERGY_IS_CHANGED)
        Context.Model.dispatchCustomEvent(ContextEvent.GP_GOTITEMS_IS_CHANGED)
        Context.Model.dispatchCustomEvent(ContextEvent.GP_PACKITEMS_IS_CHANGED)
        Context.Model.dispatchCustomEvent(ContextEvent.GP_RESOURCE_CHANGED)

        Context.Model.dispatchCustomEvent(ContextEvent.NEED_TO_SHOW_MAIN_PREALODER, false);
		
		/* init current color */
		Context.Model.dispatchCustomEvent(ContextEvent.GP_COLOR_CHANGED);
    }

    private function onLoggedIn(name:String):void {
        Context.gameServer.joinDefaultRoom();
        Context.gameServer.measurePing()
    }


    private function onJoinedToGame(p1:*):void {
        fastJoinFailed.removeAll()

        someoneLeftGame.add(onSomeoneLeftGame)
        leftGame.add(onLeftGame)
        threeSecondsToStart.add(onThreeSecondsToStart);
    }

    private function onFastJoinFailed():void {
        someoneJoinedToGame.removeAll()
        _currentLocation = null;
    }

    private function onLeftGame():void {
        isPlayingNow = false
        EngineContext.clear()

        fastJoinFailed.removeAll()
        createGameFailed.removeAll()
        createQuestFailed.removeAll()
        questGameCreated.removeAll()
        someoneJoinedToGame.removeAll()
        someoneLeftGame.removeAll()
        leftGame.removeAll()
        playerReadyChanged.removeAll()
        threeSecondsToStart.removeAll()
        mapLoaded.removeAll()
        gameReady.removeAll()
        gameStarted.removeAll()
        gameEnded.removeAll()
        readyToPlayAgain.removeAll()
    }

    private function onSomeoneLeftGame(lp:LobbyProfile):void {
        if(lp.id == Context.Model.currentSettings.gameProfile.id)
            leftGame.dispatch();
        lobbyProfiles[lp.slot] = null
    }

    private function onThreeSecondsToStart(data:Array, mapId:int, bonuses:Array):void {
        Context.gameServer.measurePing()
        gameStarted.addOnce(onGameStarted)

        this.playerGameProfiles = new Array()
        for (var i:int = 0; i < data.length; i++) {
            var playerGP:PlayerGameProfile = data[i];
            this.playerGameProfiles[playerGP.slot] = playerGP
        }
        Context.game = gameBuilder.makeRegular(mapId, currentLocation, playerGameProfiles, bonuses);
        if (Context.game.ready) {
            gameReady.dispatch();
        } else {
            mapLoaded.addOnce(function(xml:XML):void {
                gameReady.dispatch();
            })
        }
    }

    private function onGameStarted():void {
        isPlayingNow = true
        lastGameLobbyProfiles = lobbyProfiles.concat()
        for each (var lobbyProfile:LobbyProfile in lobbyProfiles) {
            if (lobbyProfile != null)
                lobbyProfile.isReady = false
        }
        gameEnded.addOnce(onGameEnded);
    }

    private function onGameEnded():void {
        isPlayingNow = false
        Context.Model.dispatchCustomEvent(ContextEvent.GPAGE_MY_PARAMETERS_IS_CHANGED);
        EngineContext.clear();
        readyToPlayAgain.addOnce(onReadyToPlayAgain)
    }

    private function onReadyToPlayAgain():void {
        Context.game = null;
    }

    public function getLobbyProfileById(id:String):LobbyProfile {
        for each (var lp:LobbyProfile in lobbyProfiles) {
            if (lp != null && lp.id == id)
                return lp
        }
        return null
    }

    public function getLastLobbyProfileById(id:String):LobbyProfile {
        for each (var lp:LobbyProfile in lastGameLobbyProfiles) {
            if (lp != null && lp.id == id)
                return lp
        }
        return null
    }

    public function myLobbyProfile():LobbyProfile {
        return getLobbyProfileById(Context.Model.currentSettings.gameProfile.id)
    }

    public function increaseWeaponIndex():void {
        var gp:GameProfile = Context.Model.currentSettings.gameProfile
        if (gp.selectedWeaponLeftHand == null) {
            var newW:ItemProfileObject = getNextWeapon(-1)
            if (newW != null)
                gp.setWeaponLeftHand(newW.itemType);
        } else {
            for (var i:int = 0; i < gp.gotItems.length; i++) {
                var obj:ItemProfileObject = gp.gotItems[i];
                if (obj.itemType == gp.selectedWeaponLeftHand.itemType) {
                    var newW:ItemProfileObject = getNextWeapon(i)
                    gp.setWeaponLeftHand(newW.itemType);
                    break
                }
            }
        }
        Context.Model.dispatchCustomEvent(ContextEvent.GPAGE_UPDATE_GAME_WEAPONS);
        EngineContext.currentWeaponChanged.dispatch()
    }

    private function getNextWeapon(from:int):ItemProfileObject {
        var gp:GameProfile = Context.Model.currentSettings.gameProfile;
        for (var i:int = from + 1; i < gp.gotItems.length; i++) {
            var obj:ItemProfileObject = gp.gotItems[i];
            if (obj != null && Context.Model.itemsCategoryManager.getItemCategory(obj.itemType) == ItemCategory.WEAPON) {
                return obj
            }
        }
        for (var i:int = 0; i <= from; i++) {
            var obj:ItemProfileObject = gp.gotItems[i];
            if (obj != null && Context.Model.itemsCategoryManager.getItemCategory(obj.itemType) == ItemCategory.WEAPON) {
                return obj
            }
        }
        return null
    }

// getters & setters
    public function get gameType():GameType {
        return _gameType;
    }


    public function isMySlot(slot:int):Boolean {
        return lobbyProfiles[slot].id == Context.Model.currentSettings.gameProfile.id
    }

    public function get currentLocation():LocationType {
        return _currentLocation
    }

    public function set currentLocation(currentLocation:LocationType):void {
        _currentLocation = currentLocation
    }
}
}