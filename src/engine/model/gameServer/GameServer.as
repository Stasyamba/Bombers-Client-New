/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.gameServer {

import api.vkontakte.VkontakteGlobals;

import com.smartfoxserver.v2.SmartFox;
import com.smartfoxserver.v2.core.SFSEvent;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.requests.ExtensionRequest;
import com.smartfoxserver.v2.requests.JoinRoomRequest;
import com.smartfoxserver.v2.requests.LeaveRoomRequest;
import com.smartfoxserver.v2.requests.LoginRequest;
import com.smartfoxserver.v2.requests.PublicMessageRequest;

import components.common.base.CommonConstans;
import components.common.base.access.rules.levelrule.AccessLevelRule;
import components.common.base.expirance.ExperianceObject;
import components.common.base.market.ItemMarketObject;
import components.common.bombers.BomberType;
import components.common.friendslent.FriendObject;
import components.common.items.ItemObject;
import components.common.items.ItemType;
import components.common.profiles.ISocialProfile;
import components.common.quests.QuestBestPlayer;
import components.common.quests.QuestObject;
import components.common.quests.medals.MedalType;
import components.common.quests.regard.RegardObject;
import components.common.quests.regard.RegardType;
import components.common.resources.ResourcePrice;
import components.common.resources.ResourceType;
import components.common.tutorial.TutorialPartType;
import components.common.worlds.locations.LocationType;

import engine.EngineContext;
import engine.bombers.MoveTickObject;
import engine.maps.interfaces.IDynObject;
import engine.maps.interfaces.IDynObjectType;
import engine.maps.mapObjects.DynObjectType;
import engine.model.signals.InGameMessageReceivedSignal;
import engine.model.signals.ProfileLoadedSignal;
import engine.model.signals.manage.GameServerConnectedSignal;
import engine.model.signals.manage.LoggedInSignal;
import engine.playerColors.PlayerColor;
import engine.profiles.GameProfile;
import engine.profiles.LobbyProfile;
import engine.profiles.PlayerGameProfile;
import engine.utils.Direction;
import engine.weapons.WeaponType;

import flash.events.TimerEvent;
import flash.utils.Timer;

import greensock.TweenMax;

import loading.ServerQuestObject;

import mx.controls.Alert;
import mx.utils.ObjectUtil;

import org.osflash.signals.Signal;

public class GameServer extends SmartFox {

    //output
    private static const VIEW_DIRECTION_CHANGED:String = "view_direction_changed";
    //input
    private static const MOVE_TICK:String = "M"
    private static const GAME_STARTED:String = "game.lobby.gameStarted";
    private static const THREE_SECONDS_TO_START:String = "game.lobby.3SecondsToStart";
    private static const DYNAMIC_OBJECT_ADDED:String = 'game.DOAdd';
    private static const ACTIVATE_DYNAMIC_OBJECT:String = "game.actDO"
    private static const DYNAMIC_OBJECT_ACTIVATED:String = "game.DOAct";
    private static const MULTI_DYNAMIC_OBJECT_ACTIVATED:String = "game.MultiDOAct";

    private static const DEATH_WALL_APPEARED:String = "game.deathWallAppeared";

    private static const PLAYER_DIED:String = "game.playerDied";
    private static const GAME_ENDED:String = "game.gameEnded";

    //bidirectional
    private static const INPUT_DIRECTION_CHANGED:String = "game.IDC";
    private static const ENEMY_DIRECTION_FORECAST:String = "Mm"
    private static const PLAYER_DAMAGED:String = "game.playerDamaged";
    private static const DAMAGE_PLAYER:String = "game.damagePlayer"
    private static const ACTIVATE_WEAPON:String = "game.AW";
    private static const WEAPON_ACTIVATED:String = "game.WA";
    private static const WEAPON_DEACTIVATED:String = "game.WDA";
    private static const PING:String = "ping";
    private static const PONG:String = "pong";
    private static const PI:String = "PI";
    private static const PO:String = "PO";
    //interface
    private static const INT_GAME_PROFILE_LOADED:String = "interface.gameProfileLoaded";
    private static const INT_SET_PHOTO:String = "interface.setPhoto";
    private static const INT_BUY_RESOURCES:String = "interface.buyResources"
    private static const INT_BUY_RESOURCES_RESULT:String = "interface.buyResources.result"
    private static const INT_BUY_ITEM:String = "interface.buyItem";
    private static const INT_BUY_ITEM_RESULT:String = "interface.buyItem.result";
    private static const INT_GAME_NAME_RESULT:String = "interface.gameManager.findGameName.result"
    private static const INT_GAME_NAME:String = "interface.gameManager.findGameName"
    private static const INT_FAST_JOIN:String = "interface.gameManager.fastJoin"
    private static const INT_FAST_JOIN_RESULT:String = "interface.gameManager.fastJoin.result"
    private static const INT_CREATE_QUEST:String = "interface.gameManager.createGame"
    private static const INT_CREATE_GAME:String = "interface.gameManager.createGame"
    private static const INT_CREATE_GAME_RESULT:String = "interface.gameManager.createGame.result"


    private static const INT_QUEST_START:String = "interface.missions.start";
    private static const INT_QUEST_START_RESULT:String = "interface.missions.start.result";
    private static const INT_QUEST_SUBMIT:String = "interface.missions.submitResult";
    private static const INT_QUEST_SUBMIT_RESULT:String = "interface.missions.submitResult.result";

    private static const INT_COLLECT_COLLECTION:String = "interface.collectCollection";
    private static const INT_COLLECT_COLLECTION_RESULT:String = "interface.collectCollection.result";

    private static const INT_SET_TUTORIAL_PART:String = "interface.setTrainingStatus";
    private static const INT_SET_TUTORIAL_PART_RESULT:String = "interface.setTrainingStatus.result";

    private static const INT_SET_NICK:String = "interface.setNick";


    private static const LOBBY_PROFILES:String = "game.lobby.playersProfiles"
    private static const LOBBY_READY:String = "game.lobby.readyChanged"

    private static const ADMIN_RELOAD_MAPS:String = "admin.reloadMapManager";
    private static const ADMIN_RELOAD_PRICE:String = "admin.reloadPricelistManager";


    private static const LOBBY_LOCATION:String = "game.lobby.location"

    private static const SET_KEY_VALUE_PAIR:String = "interface.setCustomParameter";

	/* statistics */
	public static const STATS_LOGIN_SOURCE:String = "stat.setLoginSource"; // stat.setLoginSource.f.source\
	public static const STATS_LOGIN_SOURCE_TYPE_DEFAULT:int = 0;
	public static const STATS_LOGIN_SOURCE_TYPE_ENERGY:int = 1;
	public static const STATS_LOGIN_SOURCE_TYPE_VICTORY:int = 2;
	public static const STATS_LOGIN_SOURCE_TYPE_INVITE:int = 3;
	public static const STATS_LOGIN_SOURCE_TYPE_WALL:int = 4;
	public static const STATS_LOGIN_SOURCE_TYPE_AD1:int = 5;
	public static const STATS_LOGIN_SOURCE_TYPE_AD2:int = 6;
	public static const STATS_LOGIN_SOURCE_TYPE_AD3:int = 7;
	public static const STATS_LOGIN_SOURCE_TYPE_AD4:int = 8;
	
	
	public static const STATS_SHOP_OPENED:String = "stat.addShopOpened";
	public static const STATS_POSTS_ADDED:String = "stat.addPostsPosted"; //stat.addPostsPosted.f.postType = 0-2
	public static const STATS_POSTS_ADDED_TYPE_ENERGY: int = 0;
	public static const STATS_POSTS_ADDED_TYPE_VICTORY: int = 1;
	public static const STATS_POSTS_ADDED_TYPE_INVITE: int = 2;

	
    public var ip:String;
    public var port:int;
    public var zone:String;
    public var defaultRoom:String;
    public var gameRoom:Room;

    public var connected:GameServerConnectedSignal = new GameServerConnectedSignal();
    public var disconnected:Signal = new Signal()
    public var loggedIn:LoggedInSignal = new LoggedInSignal();
    public var loginError:Signal = new Signal()

    public var profileLoaded:ProfileLoadedSignal = new ProfileLoadedSignal();


    public var inGameMessageReceived:InGameMessageReceivedSignal = new InGameMessageReceivedSignal();
    public var newGameNameObtained:Signal = new Signal(String)

    private var startPingFlag:Boolean = true
    private var tenSecondsTimer:Timer = new Timer(10000);
    private var namesOrder:Array

    private var _averagePing:int = 0
    private var _lastPingId:int = 0
    private var _startedAt:int = 0
    private var _measureMode:Boolean = false
    private const within:Number = 2


    public function GameServer() {
        super(true)

        addEventListener(SFSEvent.CONNECTION, onConnected);
        addEventListener(SFSEvent.CONNECTION_LOST, onDisconnected)

        addEventListener(SFSEvent.LOGIN, onLoggedIn);
        addEventListener(SFSEvent.LOGIN_ERROR, onLoginError);
        addEventListener(SFSEvent.ROOM_JOIN, onRoomJoin);
        addEventListener(SFSEvent.ROOM_JOIN_ERROR, onRoomJoinError);

        //addEventListener(SFSEvent.USER_ENTER_ROOM, onUserEnteredRoom);
        addEventListener(SFSEvent.USER_EXIT_ROOM, onUserExitedRoom);

        //addEventListener(SFSEvent.USER_VARIABLES_UPDATE, onUserVariablesUpdated);
        addEventListener(SFSEvent.EXTENSION_RESPONSE, onExtensionResponse);

        addEventListener(SFSEvent.PUBLIC_MESSAGE, onPublicMessageRecieved);

        useDefaultLocalServerConfig()
    }


    private function IsRoomCurrentGame(room:Room):Boolean {
        return gameRoom != null && room.id == gameRoom.id
    }

    public function useDefaultLocalServerConfig():void {
        if (Context.Model.isDevelopment)
            ip = "46.182.31.151"
        else
            ip = 'cs1.vensella.ru';
        port = 9933;
        zone = 'bombers';
        defaultRoom = 'defRoom';
    }

    public function connectWall():void {
        ip = 'cs1.vensella.ru';
        port = 9933;
        zone = 'bombersWall';
        defaultRoom = 'wallRoom';
        connect(ip, port)
    }

    public function connectDefault():void {
        connect(ip, port);
    }

    public function login(withName:String, pass:String):void {
        send(new LoginRequest(withName, pass, zone));
    }

    public function joinDefaultRoom():void {
        send(new JoinRoomRequest(defaultRoom));
    }

    public function sendSetPhotoRequest(photo:String):void {
        var params:ISFSObject = new SFSObject();
        params.putUtfString("interface.setPhoto.fields.photoUrl", photo);
        send(new ExtensionRequest(INT_SET_PHOTO, params, null));
    }

    public function leaveCurrentGame():void {
        send(new LeaveRoomRequest(gameRoom));
        gameRoom = null;

    }

    public function fastJoinRequest(locationId:int = -1):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("interface.gameManager.fastJoin.fields.locationId", locationId);
        params.putUtfString("interface.gameManager.fastJoin.fields.gameName", "");
        params.putUtfString("interface.gameManager.fastJoin.fields.password", "");
        send(new ExtensionRequest(INT_FAST_JOIN, params, null));
    }

    public function newGameNameRequest():void {
        send(new ExtensionRequest(INT_GAME_NAME, null, null))
    }

    public function createQuestRequest(questId:String, locId:int):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("interface.gameManager.createSingleGame.fields.locationId", locId);
        params.putUtfString("interface.gameManager.createSingleGame.fields.questId", questId);
        send(new ExtensionRequest(INT_CREATE_QUEST, params, null))
    }

    public function createNewGameRequest(name:String, pass:String, locationId:int):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("interface.gameManager.createGame.fields.locationId", locationId);
        params.putUtfString("interface.gameManager.createGame.fields.gameName", name);
        params.putUtfString("interface.gameManager.createGame.fields.password", pass);
        send(new ExtensionRequest(INT_CREATE_GAME, params, null))
    }

    public function concreteJoinRequest(name:String, pass:String):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("interface.gameManager.fastJoin.fields.locationId", -1);
        params.putUtfString("interface.gameManager.fastJoin.fields.gameName", name);
        params.putUtfString("interface.gameManager.fastJoin.fields.password", pass);
        send(new ExtensionRequest(INT_FAST_JOIN, params, null));
    }

    public function sendInGameMessage(message:String):void {
        send(new PublicMessageRequest(message, null, gameRoom));
    }

    public function setReadyRequest(value:Boolean):void {
        if (gameRoom == null)
            return;
        var params:ISFSObject = new SFSObject();
        params.putBool("game.lobby.userReady.fields.isReady", value);
        send(new ExtensionRequest("game.lobby.userReady", params, gameRoom));
    }

    public function sendPlayerDirectionChanged(x:Number, y:Number, dir:Direction, viewDirectionChanged:Boolean):void {

        var params:ISFSObject = new SFSObject();
        params.putInt("x", x * 1000);
        params.putInt("y", y * 1000);
        params.putInt("dir", dir.value);

        send(new ExtensionRequest(INPUT_DIRECTION_CHANGED, params, gameRoom));
    }

    public function notifyPlayerViewDirectionChanged(x:Number, y:Number, dir:Direction):void {

        var params:ISFSObject = new SFSObject();
        params.putDouble("x", x);
        params.putDouble("y", y);
        params.putInt("dir", dir.value);

        send(new ExtensionRequest(VIEW_DIRECTION_CHANGED, params, gameRoom));
    }

    public function sendPlayerDamaged(damage:int, isDead:Boolean):void {
//        var params:ISFSObject = new SFSObject();
//        params.putInt("game.damagePlayer.fields.damage", damage);
//        params.putBool("game.damagePlayer.fields.isDead", isDead);
//
//        send(new ExtensionRequest(DAMAGE_PLAYER, params, gameRoom));
    }

    public function sendActivateDynamicObject(object:IDynObject):void {
//        var params:ISFSObject = new SFSObject();
//        params.putInt("game.actDO.f.x", object.x);
//        params.putInt("game.actDO.f.y", object.y);
//
//        send(new ExtensionRequest(ACTIVATE_DYNAMIC_OBJECT, params, gameRoom));
    }

    public function sendActivateWeapon(x:Number, y:Number, weaponType:WeaponType):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("game.AW.f.t", weaponType.value);
        params.putInt("x", x * 1000);
        params.putInt("x", y * 1000);

        send(new ExtensionRequest(ACTIVATE_WEAPON, params, gameRoom));
    }

    public function sendChangeBomberRequest(type:BomberType):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("interface.setBomber.fields.bomberId", type.value);
        send(new ExtensionRequest("interface.setBomber", params, null));
    }

    public function sendBuyResourcesRequest(rp:ResourcePrice):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("interface.buyResources.fields.resourceType0", rp.gold.value)
        params.putInt("interface.buyResources.fields.resourceType1", rp.crystals.value)
        params.putInt("interface.buyResources.fields.resourceType2", rp.adamant.value)
        params.putInt("interface.buyResources.fields.resourceType3", rp.antimatter.value)
        params.putInt("interface.buyResources.fields.resourceType4", 0)

        //nterface.buyItem.fields.resourceType - 1-золтот, 2 - крист

        send(new ExtensionRequest(INT_BUY_RESOURCES, params, null))
    }

    public function sendBuyEnergyRequest(count:int):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("interface.buyResources.fields.resourceType0", 0)
        params.putInt("interface.buyResources.fields.resourceType1", 0)
        params.putInt("interface.buyResources.fields.resourceType2", 0)
        params.putInt("interface.buyResources.fields.resourceType3", 0)
        params.putInt("interface.buyResources.fields.resourceType4", count)

        send(new ExtensionRequest(INT_BUY_RESOURCES, params, null))
    }

    public function sendBuyItemRequest(it:ItemType, rt:ResourceType):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("interface.buyItem.fields.itemId", it.value)

        switch (rt) {
            case ResourceType.GOLD:
                params.putInt("interface.buyItem.fields.resourceType", 1);
                break;
            case ResourceType.CRYSTALS:
                params.putInt("interface.buyItem.fields.resourceType", 2);
                break;
        }

        send(new ExtensionRequest(INT_BUY_ITEM, params, null))
    }

    public function sendDropItemRequest(itemType:ItemType):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("interface.dropItem.fields.itemId", itemType.value)

        send(new ExtensionRequest("interface.dropItem", params, null))
    }

    public function sendSaveNickRequest(name:String):void {
        var params:ISFSObject = new SFSObject();
        params.putUtfString("interface.setNick.fields.nick", name);
        send(new ExtensionRequest("interface.setNick", params, null));
    }

    public function sendStartQuest(missionId:String):void {
        var params:ISFSObject = new SFSObject();
        params.putUtfString("interface.missions.start.f.missionId", missionId);

        send(new ExtensionRequest(INT_QUEST_START, params, null));
    }

    public function sendStartQuestSubmit(missionId:String, token:int, isBronze:Boolean, isSilver:Boolean, isGold:Boolean, bestTime:int):void {
        var params:ISFSObject = new SFSObject();
        params.putUtfString("interface.missions.submitResult.f.missionId", missionId);
        params.putInt("interface.missions.submitResult.f.token", token);

        params.putBool("interface.missions.submitResult.f.isBronze", isBronze);
        params.putBool("interface.missions.submitResult.f.isSilver", isSilver);
        params.putBool("interface.missions.submitResult.f.isGold", isGold);

        params.putInt("interface.missions.submitResult.f.result", bestTime);

        send(new ExtensionRequest(INT_QUEST_SUBMIT, params, null));
    }

    public function sendCollectCollection(resultItemId:int):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("interface.collectCollection.f.collectionId", resultItemId);

        send(new ExtensionRequest(INT_COLLECT_COLLECTION, params, null));
    }

    public function sendSetTutorialPart(tutorialPart:TutorialPartType):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("interface.setTrainingStatus.f.status", tutorialPart.value);

        send(new ExtensionRequest(INT_SET_TUTORIAL_PART, params, null));
    }

    public function sendSetNick(nick:String):void {
        var params:ISFSObject = new SFSObject();
        params.putUtfString("interface.setNick.fields.nick", nick);

        send(new ExtensionRequest(INT_SET_NICK, params, null));
    }

    public function setKeyValuePair(key:int, value:*):void {
        var params:ISFSObject = new SFSObject();
        params.putInt("interface.setCustomParameter.f.key", key);

        var isAcceptableValue:Boolean = true;

        if (value is int) {
            params.putInt("interface.setCustomParameter.f.intValue", value);

        } else if (value is String) {
            params.putInt("interface.setCustomParameter.f.stringValue", value);
        } else {
            isAcceptableValue = false;
        }

        if (isAcceptableValue) {
            send(new ExtensionRequest(SET_KEY_VALUE_PAIR, params, null));
        } else {
            Alert.show("Error: Bad value | GameServer.as");
        }
    }


    public function wall_sendSubmitPrice(posterId:String):void {
        var params:ISFSObject = new SFSObject();
        params.putUtfString("PostCreatorId", posterId);

        send(new ExtensionRequest("bombersWall.submitPrize", params, null));
    }
	
	
	/* statistics */
	
	public function statLoginSource(source:int = STATS_LOGIN_SOURCE_TYPE_DEFAULT):void {
		var params:ISFSObject = new SFSObject();
		params.putInt("stat.setLoginSource.f.source", source);
		
		send(new ExtensionRequest(STATS_LOGIN_SOURCE, params, null));
	}
	
	public function statPostAdded(source:int):void {
		var params:ISFSObject = new SFSObject();
		params.putInt("stat.addPostsPosted.f.postType", source);
		
		send(new ExtensionRequest(STATS_POSTS_ADDED, params, null));
	}
	
	public function statShopOpened():void {
		var params:ISFSObject = new SFSObject();
		
		send(new ExtensionRequest(STATS_SHOP_OPENED, params, null));
	}
	
	
	
	

    public function measurePing():void {
        tenSecondsTimer.stop()
        _averagePing = 0
        _lastPingId = int(Math.random() * 10000 + 1)
        _startedAt = _lastPingId
        _measureMode = true
        var period:Number = within / 10
        ping(0)
        var p:Number = 0
        for (var i:int = 1; i < 10; i++) {
            TweenMax.delayedCall(p += period, ping, [0])
        }
        TweenMax.delayedCall(within + 1, stopMeasure)
    }

    private function stopMeasure():void {
        _measureMode = false
        tenSecondsTimer.start()
    }

    public function ping(e:*):void {
        var pingId:int = _measureMode ? _lastPingId++ : 0;
        var params:ISFSObject = new SFSObject();
        params.putInt("id", pingId);
        params.putDouble("time", int(new Date().getTime()))
        send(new ExtensionRequest(PING, params, null));
    }

    private function onPONG(responseParams:ISFSObject):void {
        var id:int = responseParams.getInt("id")
        var time:int = responseParams.getInt("time")
        if (_measureMode) {
            if (id > 0)
                _averagePing += int((int(new Date().getTime()) - time) / 10)
        } else {
            _averagePing = int((_averagePing * 4 + (int(new Date().getTime()) - time)) / 5)
        }
        // EngineContext.pingChanged.dispatch(_averagePing)
    }

    private function startPing():void {
        tenSecondsTimer.addEventListener(TimerEvent.TIMER, ping)
        tenSecondsTimer.start()
    }

    public function adminReloadMaps():void {
        var params:ISFSObject = new SFSObject();
        send(new ExtensionRequest(ADMIN_RELOAD_MAPS, params, null));
    }

    public function adminReloadPrice():void {
        var params:ISFSObject = new SFSObject();
        send(new ExtensionRequest(ADMIN_RELOAD_PRICE, params, null));
    }

    //----------------------Handlers---------------------------

    private function onConnected(event:SFSEvent):void {
        if (event.params.success) {
            trace("connected successfully");
            connected.dispatch();
        } else {
            Context.Model.dispatchCustomEvent(ContextEvent.NEED_TO_SHOW_CANT_CONNECT_WINDOW)
        }
    }

    private function onDisconnected(e:SFSEvent):void {
        disconnected.dispatch()
    }

    private function onRoomJoin(event:SFSEvent):void {
        var room:Room = event.params.room;
        if (startPingFlag) {
            startPing()
            startPingFlag = false
        }
        trace("Room joined successfully: " + room);

        if (room.isGame) {
            gameRoom = room;
            Context.gameModel.joinedToGameRoom.dispatch()
        }
        else
            Context.gameModel.joinedToRoom.dispatch(room.id, room.name, room.userList)
    }

    private function onRoomJoinError(event:SFSEvent):void {
        trace("Join Room failure: " + event.params.errorMessage)
    }

    private function onLoggedIn(event:SFSEvent):void {
        trace("logined successfully as: " + mySelf.name);
        loggedIn.dispatch(mySelf.name);
    }

    private function onLoginError(event:SFSEvent):void {
        trace("login failure: " + event.params.errorMessage)
        loginError.dispatch()
    }

    private function onUserExitedRoom(event:SFSEvent):void {
        var room:Room = event.params.room;
        trace(event.params.user.name + " left room " + room.name);
        if (!IsRoomCurrentGame(room)) {
            return
        }
        var lp:LobbyProfile = Context.gameModel.getLobbyProfileById(event.params.user.name)
        Context.gameModel.someoneLeftGame.dispatch(lp);
    }

    private function onPublicMessageRecieved(event:SFSEvent):void {
        if (event.params.room == gameRoom) {
            if (Context.gameModel.lobbyProfiles != null)
                if (Context.gameModel.getLobbyProfileById(event.params.sender.name) != null)
                    inGameMessageReceived.dispatch(Context.gameModel.getLobbyProfileById(event.params.sender.name), event.params.message);
        }
    }

    private function onExtensionResponse(event:SFSEvent):void {
        var responseParams:ISFSObject = event.params.params as SFSObject;
        switch (event.params.cmd) {
            case PONG:
                onPONG(responseParams)
                break
            case PI:
                onPI(responseParams)
                break;
            case MOVE_TICK:
                onMOVE_TICK(responseParams)
                break;
            case ENEMY_DIRECTION_FORECAST:
//                var name:String = responseParams.getUtfString("U")
//                var slot:int = Context.gameModel.getLobbyProfileById(name).slot
//                var dir:Direction = Direction.byValue(responseParams.getInt("I"))
                //EngineContext.enemyDirectionForecast.dispatch(slot, dir)
                break;
//            case INPUT_DIRECTION_CHANGED:
//                //special case, message is broadcasted
//                var slot:int = responseParams.getInt("slot");
//                if (Context.gameModel.isMySlot(slot))
//                    return
//                EngineContext.enemyInputDirectionChanged.dispatch(
//                        slot,
//                        responseParams.getDouble("x"),
//                        responseParams.getDouble("y"),
//                        Direction.byValue(responseParams.getInt("dir")));
//                break;
            case THREE_SECONDS_TO_START:
                onTHREE_SECONDS_TO_START(responseParams)
                break;
            case GAME_STARTED:
                Context.gameModel.gameStarted.dispatch();
                break;
            case DYNAMIC_OBJECT_ADDED:
                onDYNAMIC_OBJECT_ADDED(responseParams)
                break
            case DYNAMIC_OBJECT_ACTIVATED:
                onDYNAMIC_OBJECT_ACTIVATED(responseParams)
                break;
            case MULTI_DYNAMIC_OBJECT_ACTIVATED:
                onMULTI_DYNAMIC_OBJECT_ACTIVATED(responseParams)
                break;
            case WEAPON_ACTIVATED:
                onWEAPON_ACTIVATED(responseParams)

                break;
            case WEAPON_DEACTIVATED:
                onWEAPON_DEACTIVATED(responseParams)
                break;
            case PLAYER_DAMAGED:
                slot = Context.gameModel.getLobbyProfileById(responseParams.getUtfString("UserId")).slot
                EngineContext.someoneDamaged.dispatch(slot, responseParams.getInt("HealthLeft"));
                trace("damaged enemy " + responseParams.getInt("HealthLeft"))
                break;
            case PLAYER_DIED:
                var slot:int;
                var lp:LobbyProfile = Context.gameModel.getLobbyProfileById(responseParams.getUtfString("UserId"));
                if (lp == null) {
                    lp = Context.gameModel.getLastLobbyProfileById(responseParams.getUtfString("UserId"));
                }
                if (lp != null) {
                    slot = lp.slot
                    EngineContext.someoneDied.dispatch(slot);
                }
                break;

            case DEATH_WALL_APPEARED:
                EngineContext.deathWallAppeared.dispatch(
                        responseParams.getInt("x"),
                        responseParams.getInt("y"))
                break;

            case GAME_ENDED:

                var arr:ISFSArray = responseParams.getSFSArray("expProfiles");
                if (arr.size() == 0)
                    Alert.show("No Results!");

                for (var i:int = 0; i < arr.size(); i++) {
                    var objP:ISFSObject = arr.getSFSObject(i);
                    var slot:int = Context.gameModel.getLastLobbyProfileById(objP.getUtfString("Id")).slot
                    updLobbyExperience(slot, objP.getInt("Rank"), objP.getInt("Experience"))
                }

                TweenMax.delayedCall(3.0, function ():void {
                    Context.gameModel.gameEnded.dispatch()
                });

				/* regenerate all weapons */
				Context.Model.currentSettings.gameProfile.regenerateWeapons();
				
                break;

            case INT_GAME_PROFILE_LOADED:


                try {

                    Context.Model.currentTutorialPart = TutorialPartType.byValue(responseParams.getInt("TrainingStatus"));


//					Context.Model.currentTutorialPart = TutorialPartType.PART5;

                    /* it must be after dayly boust futher */
                    if (Context.Model.currentTutorialPart == TutorialPartType.DONE) {
                        //Context.Model.dispatchCustomEvent(ContextEvent.INVITE_ALL_FRIENDS_SHOW);
						
						/* testing */
						Context.Model.dispatchCustomEvent(ContextEvent.NEED_TO_SHOW_BE_COOLER_WINDOW);
                    }


                    var missionsRecords:ISFSArray = responseParams.getSFSArray("MissionRecords");

                    for (var i:int = 0; i < missionsRecords.size(); i++) {
                        var champ:ISFSObject = missionsRecords.getSFSObject(i);

                        /* parse medalists */

                        var mt:MedalType = MedalType.BRONZE_MEDAL;

                        switch (champ.getInt("MedalType")) {
                            case 4:
                                mt = MedalType.GOLD_MEDAL;
                                break;
                            case 2:
                                mt = MedalType.SILVER_MEDAL;
                                break;
                            case 1:
                                mt = MedalType.BRONZE_MEDAL;
                                break;
                        }

                        var ch:QuestBestPlayer = new QuestBestPlayer(
                                champ.getUtfString("Id"),
                                champ.getUtfString("Login"),
                                champ.getUtfString("PhotoUrl"),
                                mt,
                                champ.getInt("Time"));

                        Context.Model.questManager.addMedalist(ch.clone());
                    }


                    var plist:ISFSObject = responseParams.getSFSObject("Pricelist")

                    Context.resourceMarket.GOLD_VOICES = plist.getInt("GoldCost")
                    Context.resourceMarket.CRYSTAL_VOICES = plist.getInt("CrystalCost")
                    Context.resourceMarket.ADAMANTIUM_VOICES = plist.getInt("AdamantiumCost")
                    Context.resourceMarket.ANTIMATTER_VOICES = plist.getInt("AntimatterCost")
                    var enArr:ISFSArray = plist.getSFSArray("EnergyCost");

                    /* parse missions */
                    /* Context.resourceMarket.ANTIMATTER_VOICES = plist.getInt("AntimatterCost") */


                    for (var i:int = 0; i < enArr.size(); i++) {
                        var it:ISFSObject = enArr.getSFSObject(i);
                        Context.resourceMarket.ENERGY_VOICES[it.getInt("Count")] = it.getInt("Price");
                    }

                    //itemCost
                    var itemsArr:ISFSArray = plist.getSFSArray("Items");
                    var prices:Array = new Array();
                    var bomberPrices:Array = new Array();

					var goldDeltaPrices:Array = new Array();
					var crystallsDeltaPrices:Array = new Array();
					var itemMaximums:Array = new Array();
					
                    for (var i:int = 0; i < itemsArr.size(); i++) {
                        var obj:ISFSObject = itemsArr.getSFSObject(i);
                        var id:int = obj.getInt("Id")
                        var rp:ResourcePrice = new ResourcePrice(obj.getInt("Gold"), obj.getInt("Crystal"), obj.getInt("Adamantium"), obj.getInt("Antimatter"))
                        var stack:int = obj.getInt("Stack")
                        var so:Boolean = obj.getBool("SpecialOffer")
                        var imo:ItemMarketObject = new ItemMarketObject(rp, stack, so)

						var goldDelta: int = obj.getInt("GoldDelta");
						var crystallsDelta: int = obj.getInt("CrystalDelta");
						var itemMax:int = obj.getInt("MaxStack");
						
                        var lev:int = obj.getInt("Level");


                        if (PlayerColor.haveId(id)) {
                            /* is color */

                            if (rp.gold.value > CommonConstans.BIG_PRICE_VALUE) rp.setResourceValue(ResourceType.GOLD, 0);
                            if (rp.crystals.value > CommonConstans.BIG_PRICE_VALUE) rp.setResourceValue(ResourceType.CRYSTALS, 0);
                            if (rp.adamant.value > CommonConstans.BIG_PRICE_VALUE) rp.setResourceValue(ResourceType.ADAMANT, 0);
                            if (rp.antimatter.value > CommonConstans.BIG_PRICE_VALUE) rp.setResourceValue(ResourceType.ANTIMATTER, 0);

                            Context.Model.bomberColorManager.setColorParameters(PlayerColor.byId(id), rp);
                        } else if (BomberType.haveId(id)) {
                            /* is bomber */
                            bomberPrices[id] = imo;
                        } else {
                            /* is item */

                            prices[id] = imo;
							
							goldDeltaPrices[id] = goldDelta;
							crystallsDeltaPrices[id] = crystallsDelta;
							itemMaximums[id] = itemMax;
							
							/* put deltas and maximum value */
							
							
                            /* parse level rule */

                            var io:ItemObject = Context.Model.itemsManager.getItem(ItemType.byValue(id));
                            if (io != null) {
                                io.addRule(new AccessLevelRule(lev));
                            }
                        }

                    }

					Context.Model.marketManager.setItemCrystallsDelta(crystallsDeltaPrices);
					Context.Model.marketManager.setItemGoldDelta(goldDeltaPrices);
					Context.Model.marketManager.setItemMaximum(itemMaximums);
					
                    Context.Model.marketManager.setItemPrices(prices);
                    Context.Model.marketManager.setBomberPrices(bomberPrices);
                    //levels

                    var debugRewards:String = "";
                    var levelsArr:ISFSArray = plist.getSFSArray("Levels");

                    for (var i:int = 0; i < levelsArr.size(); i++) {
                        var lo:ISFSObject = levelsArr.getSFSObject(i);

                        var lev:int = lo.getInt("Level");
                        var exp:int = lo.getInt("Exp");

                        var reward:ISFSObject = lo.getSFSObject("Reward");
                        var rewardsArray:Array = new Array();

                        if (reward != null) {
                            var rGold:int = reward.getInt("R0");
                            if (rGold != 0) {
                                rewardsArray.push(new RegardObject(RegardType.RESOURCE_GOLD, rGold));
                            }

                            var rCrystalls:int = reward.getInt("R1");
                            if (rCrystalls != 0) {
                                rewardsArray.push(new RegardObject(RegardType.RESOURCE_CRYSTALS, rCrystalls));
                            }

                            var rAdamant:int = reward.getInt("R2");
                            if (rAdamant != 0) {
                                rewardsArray.push(new RegardObject(RegardType.RESOURCE_ADAMANT, rAdamant));
                            }

                            var rAntimatter:int = reward.getInt("R3");
                            if (rAntimatter != 0) {
                                rewardsArray.push(new RegardObject(RegardType.RESOURCE_ANTIMATTER, rAntimatter));
                            }

                            var rEnergy:int = reward.getInt("R4");
                            if (rEnergy != 0) {
                                rewardsArray.push(new RegardObject(RegardType.RESOURCE_ENERGY, rEnergy));
                            }

                            var rExp:int = reward.getInt("Exp");
                            if (rExp != 0) {
                                rewardsArray.push(new RegardObject(RegardType.RESOURCE_EXP, rExp));
                            }

                            itemsArr = reward.getSFSArray("Items");

                            for (var j:int = 0; j < itemsArr.size(); j++) {
                                obj = itemsArr.getSFSObject(j);
                                rewardsArray.push(new RegardObject(RegardType.RESOURCE_ITEM, obj.getInt("C"), obj.getInt("Id")));
                            }

                        }

                        Context.Model.experianceManager.levelExperiencePair.push(new ExperianceObject(lev, exp, rewardsArray.concat()))
                    }

                    //quests

                    var questsArr:ISFSArray = plist.getSFSArray("Missions");
                    var sqoArray:Array = new Array();

                    for (var i:int = 0; i < questsArr.size(); i++) {
                        var sqo:ISFSObject = questsArr.getSFSObject(i);

                        var qid:String = sqo.getUtfString("Id");

                        var eCost:int = sqo.getInt("E");
                        var rewards:Array = ["Gold","Silver","Bronze"];
                        var sqoRewards:Array = new Array();
                        for each (var s:String in rewards) {
                            var reward:ISFSObject = sqo.getSFSObject(s);
                            var rewardsArray:Array = new Array();

                            var rGold:int = reward.getInt("R0");
                            if (rGold != 0) {
                                rewardsArray.push(new RegardObject(RegardType.RESOURCE_GOLD, rGold));
                            }

                            var rCrystalls:int = reward.getInt("R1");
                            if (rCrystalls != 0) {
                                rewardsArray.push(new RegardObject(RegardType.RESOURCE_CRYSTALS, rCrystalls));
                            }

                            var rAdamant:int = reward.getInt("R2");
                            if (rAdamant != 0) {
                                rewardsArray.push(new RegardObject(RegardType.RESOURCE_ADAMANT, rAdamant));
                            }

                            var rAntimatter:int = reward.getInt("R3");
                            if (rAntimatter != 0) {
                                rewardsArray.push(new RegardObject(RegardType.RESOURCE_ANTIMATTER, rAntimatter));
                            }

                            var rEnergy:int = reward.getInt("R4");
                            if (rEnergy != 0) {
                                rewardsArray.push(new RegardObject(RegardType.RESOURCE_ENERGY, rEnergy));
                            }

                            var rExp:int = reward.getInt("Exp");
                            if (rExp != 0) {
                                rewardsArray.push(new RegardObject(RegardType.RESOURCE_EXP, rExp));
                            }

                            itemsArr = reward.getSFSArray("Items");

                            for (var j:int = 0; j < itemsArr.size(); j++) {
                                obj = itemsArr.getSFSObject(j);
                                rewardsArray.push(new RegardObject(RegardType.RESOURCE_ITEM, obj.getInt("C"), obj.getInt("Id")));
                            }
                            sqoRewards.push(rewardsArray)
                        }
                        sqoArray.push(new ServerQuestObject(qid, eCost, sqoRewards));
                    }
                    Context.gameModel.serverQuests = sqoArray;
                    Context.gameModel.fillServerQuestData();


                    /* fill with best players */
                    var medlists:Array = Context.Model.questManager.getAllMedalists();

                    for each(var qo:QuestObject in Context.Model.questManager.getAllQuests()) {
                        for each(var bp:QuestBestPlayer in medlists) {
                            if (qo.id == bp.questId) {
                                qo.setBestPlayer(bp.clone());
                                break;
                            }
                        }
                    }

                    //Context.Model.dispatchCustomEvent(ContextEvent.DEVELOP_DEBUG_STRING_SHOW, ObjectUtil.toString({champs: Context.Model.questManager.getAllQuests()}));


                    //Context.Model.dispatchCustomEvent(ContextEvent.DEVELOP_DEBUG_STRING_SHOW, ObjectUtil.toString({champs: Context.Model.questManager.getAllMedalists()}));

                    //Context.Model.dispatchCustomEvent(ContextEvent.DEVELOP_DEBUG_STRING_SHOW, ObjectUtil.toString({champs: Context.Model.questManager.getAllMedalists()}));

                    /*for each(var eo: ExperianceObject in Context.Model.experianceManager.levelExperiencePair)
                     {
                     debugRewards += "Level: "+eo.level.toString()+"\n\n";
                     debugRewards += ObjectUtil.toString({rw: eo.rewards});
                     debugRewards += "\n\n--------------------------------\n\n";
                     }
                     Context.Model.dispatchCustomEvent(ContextEvent.DEVELOP_DEBUG_STRING_SHOW, debugRewards);*/


                    //gp
                    var gp:GameProfile = GameProfile.fromISFSObject(responseParams);
                    profileLoaded.dispatch(gp);

                    Context.Model.dispatchCustomEvent(ContextEvent.GP_EXPERIENCE_CHANGED);


//                    Context.Model.dispatchCustomEvent(ContextEvent.NEED_TO_SHOW_MAIN_PREALODER, false);

                    switch (Context.Model.currentTutorialPart) {
                        case TutorialPartType.PART1:
                            Context.Model.dispatchCustomEvent(ContextEvent.TUTORIAL_OPEN_PART1);
                            break;
                        case TutorialPartType.PART2:
                            Context.Model.dispatchCustomEvent(ContextEvent.TUTORIAL_OPEN_PART2);
                            break;
                        case TutorialPartType.PART3:
                            Context.Model.dispatchCustomEvent(ContextEvent.TUTORIAL_OPEN_PART3);
                            break;
                        case TutorialPartType.PART4:
                            Context.Model.dispatchCustomEvent(ContextEvent.NEW_LEVEL_SHOW);
                            break;
                        case TutorialPartType.PART5:
                            Context.Model.dispatchCustomEvent(ContextEvent.TUTORIAL_OPEN_PART5);
                            break;
                    }


                    /* locations */
                    Context.Model.dispatchCustomEvent(ContextEvent.WORLD_LOCATIONS_FILL_COLORS);

                    /* immitation */
                    Context.Model.dispatchCustomEvent(ContextEvent.IM_HITS_LOADED, [ItemType.DINAMIT_BOMB, ItemType.HEALTH_PACK_POISON, ItemType.MINA_BOMB]);

                    /* immitation */
                    var friendsLent:Array = new Array();

                    for each(var p:ISocialProfile in Context.Model.currentSettings.apiResult.friends) {
                        var fgp:GameProfile = new GameProfile();
                        fgp.photoURL = p.photoURL;
                        fgp.id = p.id;

                        var fo:FriendObject = new FriendObject(fgp, false, false, true, p);
                        friendsLent.push(fo);
                    }

                    Context.Model.dispatchCustomEvent(ContextEvent.FRIENDS_PANEL_FRIENDS_IS_LOADED, friendsLent);
					
					statLoginSource(Context.Model.statsSourceLocation);
					
					//Context.gameServer.adminReloadMaps();
                }
                catch(errObject:Error) {
                    Alert.show(errObject.message);
                }

                break;
            case INT_BUY_RESOURCES_RESULT:

                var status:Boolean = responseParams.getBool("interface.buyResources.result.fields.status")
                if (!status) {
                    Context.Model.dispatchCustomEvent(ContextEvent.RS_BUY_FAILED)
                    return;
                } else {
                    //Alert.show("Got event");

                    var en:int = responseParams.getInt("interface.buyResources.result.fields.resourceType4");

                    var rp:ResourcePrice = new ResourcePrice(
                            responseParams.getInt("interface.buyResources.result.fields.resourceType0"),
                            responseParams.getInt("interface.buyResources.result.fields.resourceType1"),
                            responseParams.getInt("interface.buyResources.result.fields.resourceType2"),
                            responseParams.getInt("interface.buyResources.result.fields.resourceType3")
                    )

                    Context.Model.currentSettings.gameProfile.resources = rp.clone();

                    //Alert.show(rp.toString());

                    Context.Model.currentSettings.gameProfile.energy = en;
                    Context.Model.dispatchCustomEvent(ContextEvent.GP_ENERGY_IS_CHANGED);
                    Context.Model.dispatchCustomEvent(ContextEvent.GP_RESOURCE_CHANGED);

                }
                break;

            case INT_BUY_ITEM_RESULT:

                status = responseParams.getBool("interface.buyItem.result.fields.status");

                if (!status) {
                    Context.Model.dispatchCustomEvent(ContextEvent.IM_ITEMBUY_FAIL);
                    return;
                }

                var iType:ItemType = ItemType.byValue(responseParams.getInt("interface.buyItem.result.fields.itemId"));
                var count:int = responseParams.getInt("interface.buyItem.result.fields.count");

                rp = new ResourcePrice(
                        responseParams.getInt("interface.buyItem.result.fields.resourceType0"),
                        responseParams.getInt("interface.buyItem.result.fields.resourceType1"),
                        responseParams.getInt("interface.buyItem.result.fields.resourceType2"),
                        responseParams.getInt("interface.buyItem.result.fields.resourceType3")
                );

                if (PlayerColor.haveId(iType.value)) {
                    /* is color */
                    var pc:PlayerColor = PlayerColor.byId(iType.value);

                    if (!Context.Model.currentSettings.gameProfile.haveColor(pc)) {
                        Context.Model.currentSettings.gameProfile.openedBomberColors.push(pc);
                        Context.Model.dispatchCustomEvent(ContextEvent.COLOR_SET_REFRESH);
                    }
                } else if (BomberType.haveId(iType.value)) {
                    /* is bomber */

                    Context.Model.currentSettings.gameProfile.bombersOpened.push(BomberType.byValue(iType.value));
                    Context.Model.dispatchCustomEvent(ContextEvent.GP_OPEN_BOBMERS_REFRESH, BomberType.byValue(iType.value));

                } else {
					
					/* is weapon */
					
					//Alert.show(count.toString());
					
                    Context.Model.currentSettings.gameProfile.addItem(iType, count);
					
					if (Context.Model.itemCollectionsManager.getCollection(iType) == null) 
					{	
						/* only weapons, not collection part */
						
						Context.Model.currentSettings.gameProfile.addItemGameRenegerated(iType, 1);
						Context.Model.currentSettings.gameProfile.regenerateWeapons();
						
						Context.Model.dispatchCustomEvent(ContextEvent.IM_WEAPON_CONTENT_REFRESH, iType);
					}
					
					
                }

                Context.Model.currentSettings.gameProfile.resources.setFrom(rp);


                Context.Model.dispatchCustomEvent(ContextEvent.GP_RESOURCE_CHANGED);
                Context.Model.dispatchCustomEvent(ContextEvent.GP_GOTITEMS_IS_CHANGED);
                Context.Model.dispatchCustomEvent(ContextEvent.GP_PACKITEMS_IS_CHANGED);
                Context.Model.dispatchCustomEvent(ContextEvent.GP_CURRENT_LEFT_WEAPON_IS_CHANGED);
                Context.Model.dispatchCustomEvent(ContextEvent.IM_ITEMBUY_SUCCESS, iType);

                break;

            case INT_GAME_NAME_RESULT:
                newGameNameObtained.dispatch(responseParams.getUtfString("interface.gameManager.findGameName.result.fields.gameName"))
                break;
            case INT_FAST_JOIN_RESULT:
                Context.gameModel.fastJoinFailed.dispatch()
                break;
            case INT_CREATE_GAME_RESULT:
                Context.gameModel.createGameFailed.dispatch()
                break;
            case LOBBY_PROFILES:
                var arr:ISFSArray = responseParams.getSFSArray("profiles");
                var newLPs:Array = getLobbyProfilesFromSFSArray(arr)
                var lp:LobbyProfile = getNewLobbyProfile(newLPs)

                /*Context.Model.dispatchCustomEvent(ContextEvent.DEVELOP_DEBUG_STRING_SHOW, ObjectUtil.toString(
                 {
                 profiles: arr.getDump()
                 }
                 ));*/

                Context.gameModel.lobbyProfiles = newLPs
                Context.gameModel.someoneJoinedToGame.dispatch(lp);
                break;
            case LOBBY_LOCATION:
                Context.gameModel.currentLocation = LocationType.byValue(responseParams.getInt("LocationId"))
                break
            case LOBBY_READY:
                var ready:Boolean = responseParams.getBool("IsReady")
                var name:String = responseParams.getUtfString("Id");
                var lp:LobbyProfile = Context.gameModel.getLobbyProfileById(name)
                if (lp != null)
                    lp.isReady = ready;
                Context.gameModel.playerReadyChanged.dispatch();


                if (name == Context.Model.currentSettings.gameProfile.id) {
                    Context.Model.currentSettings.gameProfile.energy = responseParams.getInt("NewEnergy");
                    Context.Model.dispatchCustomEvent(ContextEvent.GP_ENERGY_IS_CHANGED);
                }

				/* my profile */
				
				if(ready && name == Context.Model.currentSettings.gameProfile.id)
				{
					Context.Model.dispatchCustomEvent(ContextEvent.GP_PREGAME_BLOCK_READY_BUTTON);
				}
				
                break;

            case INT_QUEST_START_RESULT:

                Context.Model.questToken = responseParams.getInt("interface.missions.start.result.f.token");
                Context.Model.currentSettings.gameProfile.energy = responseParams.getInt("interface.missions.start.result.f.youNewEnergy");

                Context.Model.dispatchCustomEvent(ContextEvent.GP_ENERGY_IS_CHANGED);
                break;

            case INT_QUEST_SUBMIT_RESULT:

                var qo:QuestObject = Context.Model.questManager.getQuestObject(Context.Model.questIdLastOpened);
                var r:Array = new Array();

                if (responseParams.containsKey("interface.missions.submitResult.result.f.bronze")) {
                    r = r.concat(qo.getTask(MedalType.BRONZE_MEDAL).regards);
                }

                if (responseParams.containsKey("interface.missions.submitResult.result.f.silver")) {

                    r = r.concat(qo.getTask(MedalType.SILVER_MEDAL).regards);

                }

                if (responseParams.containsKey("interface.missions.submitResult.result.f.gold")) {
                    r = r.concat(qo.getTask(MedalType.GOLD_MEDAL).regards);
                }

                for each(var ro:RegardObject in r) {
                    switch (ro.type) {
                        /* resources */
                        case RegardType.RESOURCE_GOLD:
                            Context.Model.currentSettings.gameProfile.resources.add(new ResourcePrice(ro.amount, 0, 0, 0));
                            break;
                        case RegardType.RESOURCE_CRYSTALS:
                            Context.Model.currentSettings.gameProfile.resources.add(new ResourcePrice(0, ro.amount, 0, 0));
                            break;
                        case RegardType.RESOURCE_ADAMANT:
                            Context.Model.currentSettings.gameProfile.resources.add(new ResourcePrice(0, 0, ro.amount, 0));
                            break;
                        case RegardType.RESOURCE_ANTIMATTER:
                            Context.Model.currentSettings.gameProfile.resources.add(new ResourcePrice(0, 0, 0, ro.amount));
                            break;

                        case RegardType.RESOURCE_ITEM:
                            Context.Model.currentSettings.gameProfile.addItem(ItemType.byValue(ro.itemId), ro.amount);
                            break;
                    }
                }


                Context.Model.dispatchCustomEvent(ContextEvent.GP_RESOURCE_CHANGED);
                Context.Model.dispatchCustomEvent(ContextEvent.GP_GOTITEMS_IS_CHANGED);
                Context.Model.dispatchCustomEvent(ContextEvent.GP_PACKITEMS_IS_CHANGED);
                Context.Model.dispatchCustomEvent(ContextEvent.GP_CURRENT_LEFT_WEAPON_IS_CHANGED);

                break;

            case INT_COLLECT_COLLECTION_RESULT:

                var resultItem:ItemType = ItemType.byValue(responseParams.getInt("interface.collectCollection.result.f.collectionId"));
                Context.Model.currentSettings.gameProfile.addItem(resultItem, 1);

                for each(var itemType:ItemType in Context.Model.itemCollectionsManager.getCollectionByResultItem(resultItem).itemParts) {
                    Context.Model.currentSettings.gameProfile.removeItem(itemType, 1);
                }


                Context.Model.dispatchCustomEvent(ContextEvent.IM_HIDE_COLLECTION);
                Context.Model.dispatchCustomEvent(ContextEvent.GP_GOTITEMS_IS_CHANGED);
                Context.Model.dispatchCustomEvent(ContextEvent.GP_PACKITEMS_IS_CHANGED);
                Context.Model.dispatchCustomEvent(ContextEvent.GP_CURRENT_LEFT_WEAPON_IS_CHANGED);

                break;

            case INT_SET_TUTORIAL_PART_RESULT:

                /* не на всех шагах нужно выставлять опыт а только на одном */
                if (responseParams.containsKey("interface.setTrainingStatus.result.f.youNewExperience")) {
                    Context.Model.currentSettings.gameProfile.experience = responseParams.getInt("interface.setTrainingStatus.result.f.youNewExperience");
                    Context.Model.dispatchCustomEvent(ContextEvent.GP_EXPERIENCE_CHANGED);

                    /* get 2 level */
                    Context.Model.dispatchCustomEvent(
                            ContextEvent.NEW_LEVEL_SHOW,
                            Context.Model.experianceManager.getLevel(Context.Model.currentSettings.gameProfile.experience)
                    );
                }

                break;
        }
    }

    private function onPI(responseParams:ISFSObject):void {
        send(new ExtensionRequest(PO, responseParams, null));
    }


    private function getNewLobbyProfile(newLPs:Array):LobbyProfile {
        if (Context.gameModel.lobbyProfiles == null)
            return null
        for (var i:int = 0; i < newLPs.length; i++) {
            var lpOld:LobbyProfile = Context.gameModel.lobbyProfiles[i];
            var lpNew:LobbyProfile = newLPs[i];
            if (lpOld == null && lpNew != null)
                return lpNew
        }
        return null
    }

    public function getLobbyProfilesFromSFSArray(arr:ISFSArray):Array {
        var resultArray:Array = new Array();
        for (var i:int = 0; i < arr.size(); i++) {
            var item:ISFSObject = arr.getSFSObject(i);
            var id:String = item.getUtfString("Id");
            var exp:int = item.getInt("Experience");
            var nick:String = item.getUtfString("Nick");
            var photo:String = item.getUtfString("Photo");
            var ready:Boolean = item.getBool("IsReady");
            var slot:int = item.getInt("Slot");
            var params:ISFSArray = item.getSFSArray("CustomParameters");
            var cId:* = customParameter(params, CommonConstans.CUSTOM_PARAMETER_COLOR);
            var color:PlayerColor;

            if (cId != null) {
                color = PlayerColor.byId(int(cId));
            } else {
                color = PlayerColor.RED;
            }

            resultArray[slot] = new LobbyProfile(id, nick, photo, exp, slot, ready, color)
        }
        return resultArray
    }

    private function updLobbyExperience(slot:int, place:int, exp:int):void {
        var lp:LobbyProfile = (Context.gameModel.lastGameLobbyProfiles[slot] as LobbyProfile)
        lp.place = place
        lp.expEarned = exp - lp.experience
        lp.experience = exp
    }

    // EXTENSION
    // RESPONSES
    private function onMOVE_TICK(responseParams:ISFSObject):void {
        if (!Context.gameModel.isPlayingNow)
            return;
        var dirArr:ISFSArray = responseParams.getSFSArray("ID")
        var cxArr:ISFSArray = responseParams.getSFSArray("CX")
        var cyArr:ISFSArray = responseParams.getSFSArray("CY")
        var moveTickObject:Object = {}
        for (var i:int = 0; i < namesOrder.length; i++) {
            var name:String = namesOrder[i];
            var dirCode:int = dirArr.getInt(i)
            if (dirCode == -1) {
                continue
            }
            var dir:Direction = Direction.byValue(dirCode)
            var cx:Number = cxArr.getInt(i) / 1000
            var cy:Number = cyArr.getInt(i) / 1000
            var lp:LobbyProfile = Context.gameModel.getLobbyProfileById(name)
            if (lp != null) {
                var slot:int = lp.slot
                moveTickObject[slot] = new MoveTickObject(cx, cy, new Date().getTime(), dir)
                trace(ObjectUtil.toString(moveTickObject))
            }
        }
        EngineContext.moveTick.dispatch(moveTickObject)
    }

    private function onTHREE_SECONDS_TO_START(responseParams:ISFSObject):void {
        var playerGameData:Array = new Array();
        var sfsArr:ISFSArray = responseParams.getSFSArray("game.lobby.3SecondsToStart.fields.PlayerGameProfiles")
        namesOrder = new Array()
        for (var i:int = 0; i < sfsArr.size(); i++) {
            var obj:ISFSObject = sfsArr.getSFSObject(i)
            var x:int = obj.getInt("StartX")
            var y:int = obj.getInt("StartY")
            var name:String = obj.getUtfString("UserId")
            namesOrder.push(name)
            var lp:LobbyProfile = Context.gameModel.getLobbyProfileById(name)
            var auras:Array = new Array()
            var bType:BomberType = BomberType.byValue(obj.getInt("BomberId"))
            var a1:WeaponType = WeaponType.byValue(obj.getInt("AuraOne"))
            var a2:WeaponType = WeaponType.byValue(obj.getInt("AuraTwo"))
            var a3:WeaponType = WeaponType.byValue(obj.getInt("AuraThree"))
            if (a1 != WeaponType.NULL)
                auras.push(a1)
            if (a2 != WeaponType.NULL)
                auras.push(a2)
            if (a3 != WeaponType.NULL)
                auras.push(a3)
            playerGameData.push(new PlayerGameProfile(lp.slot, bType, x, y, auras, lp.color));
        }
        var mapId:int = responseParams.getInt("game.lobby.3SecondsToStart.fields.MapId");
        var bonuses:Array = new Array();
        var bonusArr:ISFSArray = responseParams.getSFSArray("game.lobby.3SecondsToStart.fields.mapObjects");
        for (var i:int = 0; i < bonusArr.size(); i++) {
            var obj:ISFSObject = bonusArr.getSFSObject(i);
            bonuses.push({
                id:obj.getInt("ID"),
                x:obj.getInt("X"),
                y:obj.getInt("Y"),
                type:obj.getInt("T"),
                p0:obj.containsKey("P0") ? obj.getData("P0").data : undefined,
                p1:obj.containsKey("P1") ? obj.getData("P1").data : undefined,
                p2:obj.containsKey("P2") ? obj.getData("P2").data : undefined

            })
        }

        Context.gameModel.threeSecondsToStart.dispatch(playerGameData, mapId, bonuses);
    }

    private function onDYNAMIC_OBJECT_ADDED(responseParams:ISFSObject):void {
        var slot:int = -1
        var ot:IDynObjectType = DynObjectType.byValue(responseParams.getInt("game.DOAdd.f.type"))
        var name:String = responseParams.getUtfString("game.DOAdd.f.userId")
        if (name != null && name != "")
            slot = Context.gameModel.getLobbyProfileById(name).slot
        EngineContext.objectAdded.dispatch(responseParams.getInt("game.DOAdd.f.id"),
                slot,
                responseParams.getInt("game.DOAdd.f.x"),
                responseParams.getInt("game.DOAdd.f.y"),
                ot, null)
    }

    private function onDYNAMIC_OBJECT_ACTIVATED(responseParams:ISFSObject):void {

        var type:int = responseParams.getInt("game.DOAct.f.type");
        var id:int = responseParams.getInt("game.DOAct.f.id");

        if (type == 200) {
            EngineContext.specialObjectExploded.dispatch(id, responseParams.getInt("game.DOAct.f.x"), responseParams.getInt("game.DOAct.f.y"), responseParams.getInt("game.DOAct.f.lifeLeft"));
            return;
        }
        var slot:int = -1
        if (responseParams.containsKey("game.DOAct.f.userId")) {
            slot = Context.gameModel.getLobbyProfileById(responseParams.getUtfString("game.DOAct.f.userId")).slot
        }
        var ot:IDynObjectType = DynObjectType.byValue(type)
        var destList:Array = []

        var sfsArr:ISFSArray = responseParams.getSFSArray("game.DOAct.f.s.destroyList");
        if (sfsArr) {
            for (var i:int = 0; i < sfsArr.size(); i++) {
                var i1:ISFSObject = sfsArr.getSFSObject(i);
                destList.push({x: i1.getInt("X"), y: i1.getInt("Y"),isS:i1.getBool("isS"),id:i1.getInt("ID")})
            }
        }
        var params:Object = {};
        params["power"] = responseParams.getInt("game.DOAct.f.s.power");
        params["lifetime"] = responseParams.getInt("game.DOAct.f.s.lifetime");
        params["active"] = responseParams.getBool("game.DOAct.f.isActive");

        EngineContext.objectActivated.dispatch(id,
                slot,
                responseParams.getInt("game.DOAct.f.x"),
                responseParams.getInt("game.DOAct.f.y"),
                ot, destList, params)
    }

    private function onMULTI_DYNAMIC_OBJECT_ACTIVATED(responseParams:ISFSObject):void {
        Context.game.explosionExchangeBuffer.length = 0;
        var dos:ISFSArray = responseParams.getSFSArray("DOs")
        for (var i:int = 0; i < dos.size(); i++) {
            var Do:ISFSObject = dos.getSFSObject(i);
            onDYNAMIC_OBJECT_ACTIVATED(Do);
        }
        if (Context.game != null && Context.game.explosionExchangeBuffer.length > 0)
            EngineContext.explosionGroupAdded.dispatch(Context.game.explosionExchangeBuffer)
    }

    private function onWEAPON_ACTIVATED(responseParams:ISFSObject):void {
        var slot:int = Context.gameModel.getLobbyProfileById(responseParams.getUtfString("game.WA.f.userId")).slot
        var wt:WeaponType = WeaponType.byValue(responseParams.getInt("game.WA.f.type"))
        var x:int = responseParams.getInt("game.WA.f.x")
        var y:int = responseParams.getInt("game.WA.f.y")
        EngineContext.weaponActivated.dispatch(slot, x, y, wt)
    }

    private function onWEAPON_DEACTIVATED(responseParams:ISFSObject):void {
        var slot:int = Context.gameModel.getLobbyProfileById(responseParams.getUtfString("game.WDA.f.userId")).slot
        var wt:WeaponType = WeaponType.byValue(responseParams.getInt("game.WDA.f.type"))
        EngineContext.weaponDeactivated.dispatch(slot, wt)
    }

    public function get averagePing():int {
        return _averagePing
    }

    public function customParameter(params:ISFSArray, code:int):* {
        for (var j:int = 0; j < params.size(); j++) {
            var pair:ISFSArray = params.getSFSArray(j);
            var c:int = pair.getInt(0);
            if (c == code) {
                return pair.getElementAt(1);
            }
        }
        return null
    }
}
}