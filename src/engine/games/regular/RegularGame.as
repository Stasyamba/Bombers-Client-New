/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.games.regular {
import components.common.resources.ResourcePrice
import components.common.resources.ResourceType
import components.common.worlds.locations.LocationType

import engine.EngineContext
import engine.bombers.PlayerBomber
import engine.bombers.PlayersBuilder
import engine.bombers.interfaces.IBomber
import engine.bombers.interfaces.IEnemyBomber
import engine.bombers.interfaces.IPlayerBomber
import engine.data.common.maps.Maps
import engine.explosionss.ExplosionsBuilder
import engine.games.*
import engine.games.quest.GameStats
import engine.maps.Map
import engine.maps.bigObjects.SimpleBigObject
import engine.maps.bigObjects.SpecialSimpleBigObject
import engine.maps.builders.DynObjectBuilder
import engine.maps.builders.MapBlockBuilder
import engine.maps.builders.MapBlockStateBuilder
import engine.maps.interfaces.IDynObject
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock
import engine.maps.mapObjects.DynObjectType
import engine.maps.mapObjects.action.GatePassType
import engine.maps.mapObjects.bonuses.BonusType
import engine.model.explosionss.ExplosionType
import engine.model.managers.interfaces.IEnemiesManager
import engine.model.managers.quest.MonstersManager
import engine.model.managers.regular.DynObjectManager
import engine.model.managers.regular.EnemiesManager
import engine.model.managers.regular.ExplosionsManager
import engine.model.managers.regular.MapManager
import engine.model.managers.regular.PlayerManager
import engine.playerColors.PlayerColor
import engine.profiles.PlayerGameProfile
import engine.utils.Direction
import engine.weapons.WeaponBuilder
import engine.weapons.WeaponType
import engine.weapons.interfaces.IActivatableWeapon
import engine.weapons.interfaces.IDeactivatableWeapon

import greensock.TweenMax

public class RegularGame extends GameBase implements IMultiPlayerGame {

    protected var _enemiesManager:IEnemiesManager;
    private var _gameStats:GameStats = new GameStats();

    public function RegularGame(location:LocationType) {
        super(location)
        mapBlockStateBuilder = new MapBlockStateBuilder();
        dynObjectBuilder = new DynObjectBuilder();
        mapBlockBuilder = new MapBlockBuilder(mapBlockStateBuilder, dynObjectBuilder)

        _mapManager = new MapManager(mapBlockBuilder);

        explosionsBuilder = new ExplosionsBuilder(mapManager);
        dynObjectBuilder.setExplosionsBuilder(explosionsBuilder)

        _playerManager = new PlayerManager();
        _enemiesManager = new EnemiesManager();

        _explosionsManager = new ExplosionsManager(explosionsBuilder, mapManager, playerManager);
        _dynObjectManager = new DynObjectManager(playerManager, mapManager)
        weaponBuilder = new WeaponBuilder(_mapManager)
        playersBuilder = new PlayersBuilder(weaponBuilder);
        //game events
        Context.gameModel.gameStarted.addOnce(function():void {

            //EngineContext.playerInputDirectionChanged.add(onPlayerInputDirectionChanged);
            EngineContext.frameEntered.add((playerManager.me as PlayerBomber).sendDirection)

            EngineContext.frameEntered.add(playerManager.movePlayer);
            EngineContext.frameEntered.add(enemiesManager.moveEnemies);
            EngineContext.frameEntered.add(explosionsManager.checkExplosions);
            EngineContext.frameEntered.add(dynObjectManager.checkObjectsActivated);

            EngineContext.triedToActivateWeapon.add(onTryToActivateWeapon);
            EngineContext.weaponActivated.add(onWeaponActivated);
            EngineContext.weaponDeactivated.add(onWeaponDeactivated);

            EngineContext.explosionGroupAdded.add(onExplosionsAdded)

            EngineContext.playerDamaged.add(onPlayerDamaged)

            EngineContext.objectAdded.add(addObject)
            EngineContext.triedToActivateObject.add(tryToActivateObject)
            EngineContext.objectActivated.add(onObjectActivated);

            EngineContext.deathWallAppeared.add(onDeathWallAppeared)

            Context.gameModel.gameEnded.addOnce(onEndedGE)
            Context.gameModel.leftGame.addOnce(onEndedLG)
        })

    }

    private function onEndedGE():void {
        destroy()
        Context.gameModel.leftGame.remove(onEndedLG)
    }

    private function onEndedLG():void {
        destroy()
        Context.gameModel.gameEnded.remove(onEndedGE)
    }

    private function destroy():void {
        EngineContext.frameEntered.remove((playerManager.me as PlayerBomber).sendDirection);
        EngineContext.frameEntered.remove(playerManager.movePlayer);
        EngineContext.frameEntered.remove(enemiesManager.moveEnemies);
        EngineContext.frameEntered.remove(explosionsManager.checkExplosions);
        EngineContext.frameEntered.remove(dynObjectManager.checkObjectsActivated);
    }

    private function onWeaponDeactivated(slot:int, type:WeaponType):void {
        var b:IBomber = getPlayer(slot);
        if (playerManager.isItMe(b)) {
            playerManager.me.deactivateWeapon(type);
        } else {
            deactivateWeapon(b, type)
        }
    }

    private function deactivateWeapon(b:IBomber, type:WeaponType):void {
        var w:IDeactivatableWeapon = _weaponsUsed[type.value]
        if (w != null) {
            w.deactivateStatic(b)
            return
        }
        w = weaponBuilder.fromWeaponType(type, 0) as IDeactivatableWeapon
        if (w == null)
            throw Context.Exception("Error in file RegularGame.as:wrong weapon type " + type.key + ". IDeactivatable weapon expected")
        w.deactivateStatic(b)
        _weaponsUsed[type.value] = w
    }

    private function onWeaponActivated(slot:int, x:int, y:int, wtype:WeaponType):void {
        var b:IBomber = getPlayer(slot);
        if (playerManager.isItMe(b)) {
            playerManager.me.activateWeapon(x, y, wtype);
        } else {
            activateWeapon(b, wtype, x, y)
        }
    }

    private function activateWeapon(b:IBomber, type:WeaponType, x:int, y:int):void {
        var w:IActivatableWeapon = _weaponsUsed[type.value]
        if (w != null) {
            w.activateStatic(x, y, b)
            return
        }
        w = weaponBuilder.fromWeaponType(type, 0) as IActivatableWeapon
        if (w == null)
            throw Context.Exception("Error in file RegularGame.as: wrong weapon type " + type.key + ". IDeactivatable weapon expected")
        w.activateStatic(x, y, b)
        _weaponsUsed[type.value] = w
    }

    private function onTryToActivateWeapon(slot:int, x:Number, y:Number, type:WeaponType):void {
        Context.gameServer.sendActivateWeapon(x, y, type)
    }

    public function addPlayer(profile:PlayerGameProfile, color:PlayerColor):void {
        if (profile.slot == Context.gameModel.myLobbyProfile().slot) {
            var player:IPlayerBomber = playersBuilder.makePlayer(this, Context.Model.currentSettings.gameProfile, profile, color);
            playerManager.setPlayer(player);
        } else {
            var enemy:IEnemyBomber = playersBuilder.makeEnemy(this, Context.gameModel.lobbyProfiles[profile.slot], profile, color);
            enemiesManager.addEnemy(enemy);
        }
    }


    public function hasPlayer(slot:int):Boolean {
        return playerManager.mySlot == slot || enemiesManager.hasEnemy(slot);
    }

    public function applyMap(mapId:String, playerProfiles:Array, bonuses:Array):void {
        var xml:XML = Maps.getXmlById(mapId);
        if (xml == null) {
            Context.gameModel.mapLoaded.addOnce(function (lXml:XML):void {
                onMapLoaded(lXml, playerProfiles, bonuses);
            })
        } else {
            onMapLoaded(xml, playerProfiles, bonuses)
        }
    }

    private function onMapLoaded(xml:XML, playerProfiles:Array, bonuses:Array):void {
        mapManager.make(xml);
        for each (var item:PlayerGameProfile in playerProfiles) {
            var bomber:IBomber = getPlayer(item.slot);
            if (bomber != null)
                bomber.putOnMap(mapManager.map, item.x, item.y);
        }
        for each (var bObj:Object in bonuses) {
            if (int(bObj.type) == 300) //goldBoxes
                continue;
            if (int(bObj.type) == 200) {
                var sbo:SimpleBigObject;
                if (int(bObj.p0 != -1))
                    sbo = SpecialSimpleBigObject.asBox(bObj.id, bObj.x, bObj.y, String(bObj.p2), int(bObj.p1), mapManager.map, mapBlockStateBuilder, dynObjectBuilder);
                else
                    sbo = SimpleBigObject.asBox(bObj.id, bObj.x, bObj.y, String(bObj.p2), int(bObj.p1), mapManager.map, mapBlockStateBuilder, dynObjectBuilder);
                Map(mapManager.map).addBO(sbo);
                continue;
            }
            switch (DynObjectType.byValue(int(bObj.type))) {
                case BonusType.ITEM:
                    addObject(bObj.id, -1, bObj.x, bObj.y, BonusType.ITEM, {wt:bObj.p0,count:bObj.p1})
                    break;
                case BonusType.RESOURCE:
                    addObject(bObj.id, -1, bObj.x, bObj.y, BonusType.RESOURCE, {rt:bObj.p0,count:bObj.p1})
                    break;
                case GatePassType.GATE_PASS:
                    addObject(bObj.id, -1, bObj.x, bObj.y, GatePassType.GATE_PASS, {active:String(bObj.p0), orientation:String(bObj.p1),period:0})
                    break;
                default:
                    addObject(bObj.id, -1, bObj.x, bObj.y, DynObjectType.byValue(bObj.type))
            }
        }
        _ready = true;
    }

    private function onDeathWallAppeared(x:int, y:int):void {
        mapManager.setDieWall(x, y);
        if (playerManager.checkPlayerMetDieWall(x, y)) {
            playerManager.killMe();
        }
    }

    public function get numberOfPlayers():int {
        return enemiesManager.enemiesCount + 1;
    }


    private function onPlayerInputDirectionChanged(x:Number, y:Number, dir:Direction, viewDirChanged:Boolean):void {
        Context.gameServer.sendPlayerDirectionChanged(x, y, dir, viewDirChanged)
    }


    private function onObjectActivated(id:int, slot:int, x:int, y:int, objType:IDynObjectType, destList:Array, params:Object):void {
        var bomber:IBomber = getPlayer(slot);
        dynObjectManager.activateObjectById(id, bomber, params);
        for each (var point:Object in destList) {
            if (point.isS)
                (dynObjectManager as DynObjectManager).explodeBlock(point.x, point.y, ExplosionType.byValue(objType.key), params != null ? params.damage : 0)
            else
                dynObjectManager.activateObjectById(point.id, bomber);
        }
    }

    private function tryToActivateObject(object:IDynObject):void {
        Context.gameServer.sendActivateDynamicObject(object);
    }

    public function addObject(id:int, slot:int, x:int, y:int, objType:IDynObjectType, params:Object = null):void {
        var b:IMapBlock = mapManager.map.getBlock(x, y);
        var player:IBomber = getPlayer(slot)  //can be null

        var object:IDynObject = dynObjectBuilder.make(id, objType, b, player, params);
        b.setObject(object);

        object.grabCorrespondingWeapon()

        if (objType.waitToAdd > 0)
            TweenMax.delayedCall(objType.waitToAdd, function():void {
                dynObjectManager.addObject(object);
            })
        else
            dynObjectManager.addObject(object);
    }

    private function onPlayerDamaged(damage:int, isDead:Boolean):void {
        Context.gameServer.sendPlayerDamaged(damage, isDead);
    }

    //--------------getters and setters-----------------------
    public function get type():GameType {
        return GameType.REGULAR;
    }

    public function get location():LocationType {
        return _location
    }

    public function get enemiesManager():IEnemiesManager {
        return _enemiesManager;
    }

    public function getPlayer(slot:int):IBomber {
        if (slot == playerManager.mySlot)
            return playerManager.me;
        return enemiesManager.getEnemyBySlot(slot);
    }

    public function get monstersManager():MonstersManager {
        //todo:shit
        return new MonstersManager(_playerManager)
    }

    public function resourceCollected(rt:ResourceType, count:int, player:IBomber):void {
        if (player == playerManager.me && rt == ResourceType.GOLD) {
            _gameStats.goldCollected += count;

            /* add gold to profile and change value in top panel */
            Context.Model.currentSettings.gameProfile.resources.add(new ResourcePrice(count, 0, 0, 0));
            Context.Model.dispatchCustomEvent(ContextEvent.GP_RESOURCE_CHANGED);
        }
    }

    public function get gameStats():GameStats {
        return _gameStats
    }
}
}