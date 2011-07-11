/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers {
import components.common.items.ItemProfileObject
import components.common.items.categories.ItemCategory

import engine.EngineContext
import engine.bombers.interfaces.IMapCoords
import engine.bombers.interfaces.IPlayerBomber
import engine.bombers.mapInfo.InputDirection
import engine.bombers.mapInfo.MapCoords
import engine.bombss.BombType
import engine.explosionss.interfaces.IExplosion
import engine.games.IGame
import engine.playerColors.PlayerColor
import engine.profiles.GameProfile
import engine.utils.Direction
import engine.weapons.NullWeapon
import engine.weapons.WeaponBuilder
import engine.weapons.WeaponType
import engine.weapons.interfaces.IActivatableWeapon
import engine.weapons.interfaces.IDeactivatableWeapon
import engine.weapons.interfaces.IWeapon

public class PlayerBomber extends BomberBase implements IPlayerBomber {

    private var _prevDir:Direction = Direction.NONE
    private var _serverDir:Direction = Direction.NONE;
    private var _direction:InputDirection;

    private var _standStill:Boolean = true

    private var _gameProfile:GameProfile
    /*
     * use BombersBuilder instead
     * */
    protected var _weaponBuilder:WeaponBuilder;
    protected var _currentWeapon:IWeapon
    protected var _weapons:Array = new Array()
    private var _spectatorMode:Boolean = false


    private var _lastX:Number = -1
    private var _lastY:Number = -1
    private var _sendTime:int = 0
    private var _waitingToSend:Boolean = false
    private var _waitingToACK:Boolean = false

    //Array of MoveTickObject

    public function PlayerBomber(game:IGame, slot:int, gameProfile:GameProfile, color:PlayerColor, direction:InputDirection, weaponBuilder:WeaponBuilder) {
        super(game, slot, gameProfile.currentBomberType.getEngineType(), gameProfile.nick, color, Context.imageService.bomberSkin(gameProfile.currentBomberType.getEngineType()), gameProfile.aursTurnedOn);

        _weaponBuilder = weaponBuilder
        this._gameProfile = gameProfile
        for (var i:int = 0; i < _gameProfile.gotItems.length; i++) {
            var ipo:ItemProfileObject = _gameProfile.gotItems[i];
            if (Context.Model.itemsCategoryManager.getItemCategory(ipo.itemType) == ItemCategory.WEAPON) {
                _weapons[ipo.itemType.value] = weaponBuilder.fromItemType(ipo.itemType, ipo.itemCount)
            }
        }
        if (gameProfile.selectedWeaponLeftHand != null)
            _currentWeapon = _weapons[gameProfile.selectedWeaponLeftHand.itemType.value]
        _direction = direction;
        _serverDir = Direction.NONE

        EngineContext.moveTick.add(onMoveTick)
        EngineContext.currentWeaponChanged.add(onCurrentWeaponChanged)
        EngineContext.weaponUnitSpent.add(onWeaponUnitSpent)
        EngineContext.someoneDamaged.add(onDamaged);
        EngineContext.someoneDied.add(onDied);
    }

    public function sendDirection(miliSecs:int):void {
        if (!Context.gameModel.isPlayingNow || isDead)
            return
        if (_sendTime + miliSecs > 25 * 100 / speed && _waitingToSend) {
            Context.gameServer.sendPlayerDirectionChanged(coords.getRealX(), coords.getRealY(), _standStill ? Direction.NONE : _serverDir, false)
            _sendTime = 0
            _waitingToSend = false
            _waitingToACK = !_standStill
        } else if (_sendTime + miliSecs > 500) {
            Context.gameServer.sendPlayerDirectionChanged(coords.getRealX(), coords.getRealY(), _standStill ? Direction.NONE : _serverDir, false)
            _sendTime = 0
        } else
            _sendTime += miliSecs
    }

    private function onMoveTick(obj:Object):void {
//        if (!Context.gameModel.isPlayingNow || isDead)
//            return
//        var tickObject:MoveTickObject = obj[slot]
//        if (tickObject == null)
//            return
//
//        EngineContext.greenBaloon.dispatch(tickObject.x, tickObject.y, tickObject.dir)
//        _coords.setExplicit(tickObject.x, tickObject.y)
//        EngineContext.playerCoordinatesChanged.dispatch(_coords.getRealX(), _coords.getRealY());
//
//        if (!_waitingToSend && !_standStill && _serverDir != tickObject.dir) {
//            _serverDir = tickObject.dir
//            updateInputDirection()
//        }
    }

    private function getDiffTo(tickObject:MoveTickObject):Number {
        if (_coords.getRealX() != tickObject.x)
            return _coords.getRealX() - tickObject.x
        return _coords.getRealY() - tickObject.y
    }


    private function onWeaponUnitSpent(type:WeaponType):void {
        for (var i:int = 0; i < Context.Model.currentSettings.gameProfile.gotItems.length; i++) {
            var obj:ItemProfileObject = Context.Model.currentSettings.gameProfile.gotItems[i];
            if (obj.itemType.value == type.value) {
                obj.itemCount--;
                break
            }
        }
        Context.Model.dispatchCustomEvent(ContextEvent.GP_CURRENT_LEFT_WEAPON_IS_CHANGED)
        Context.Model.dispatchCustomEvent(ContextEvent.GP_GOTITEMS_IS_CHANGED)
        Context.Model.dispatchCustomEvent(ContextEvent.GP_PACKITEMS_IS_CHANGED)
        Context.Model.dispatchCustomEvent(ContextEvent.GPAGE_UPDATE_GAME_WEAPONS);
    }

    private function onCurrentWeaponChanged():void {
        if (_gameProfile.selectedWeaponLeftHand != null)
            _currentWeapon = _weapons[_gameProfile.selectedWeaponLeftHand.itemType.value]
        else
            _currentWeapon = NullWeapon.instance
    }

    private function goTo(dir:Direction, moveAmount:Number, coords:IMapCoords = null):void {
        var c:IMapCoords = coords == null ? _coords : coords
        switch (dir) {
            case Direction.LEFT:
                c.stepLeft(moveAmount, _spectatorMode);
                break;
            case Direction.RIGHT:
                c.stepRight(moveAmount, _spectatorMode);
                break;
            case Direction.UP:
                c.stepUp(moveAmount, _spectatorMode);
                break;
            case Direction.DOWN:
                c.stepDown(moveAmount, _spectatorMode);
                break;
        }
    }

    public function performMotion(moveAmount:Number):void {
        var dir:Direction = _serverDir
        if (_serverDir == Direction.NONE && !_spectatorMode) {
            return
        }
        _lastX = _coords.getRealX();
        _lastY = _coords.getRealY();

        goTo(dir, moveAmount)

        if (_lastX != _coords.getRealX() || _lastY != _coords.getRealY()) {
            EngineContext.playerCoordinatesChanged.dispatch(_coords.getRealX(), _coords.getRealY());
            if (_standStill) {
                _waitingToSend = true
                _standStill = false
            }
        } else {
            if (!_standStill) {
                _waitingToSend = true
                _standStill = true
            }
        }
    }

    private function getDirToTarget(_moveToTarget:MoveTickObject):Direction {
        if (_moveToTarget.x > _coords.getRealX())
            return Direction.RIGHT
        if (_moveToTarget.x < coords.getRealX())
            return Direction.LEFT
        if (_moveToTarget.y > coords.getRealY())
            return Direction.DOWN
        if (_moveToTarget.y < coords.getRealY())
            return Direction.UP
        return Direction.NONE
    }

    private function updateInputDirection():void {
        EngineContext.playerInputDirectionChanged.dispatch(_coords.getRealX(), _coords.getRealY(), _serverDir, false)
    }

    public function addDirection(m:Direction):void {
        _prevDir = _serverDir;
        _direction.addDirection(m);

        checkNewDir()
    }

    public function removeDirection(m:Direction):void {
        _prevDir = _serverDir;
        _direction.removeDirection(m);

        checkNewDir()
    }

    private function checkNewDir():void {
        var p:int = Context.gameServer.averagePing

        if (_prevDir != _direction.direction) {
            _serverDir = _direction.direction
            _standStill = false
            _waitingToSend = true
            updateInputDirection()
        }
    }

    private function willTurnGood(ccc:MapCoords):Boolean {
        if (ccc.elemX == _coords.elemX && ccc.elemY == _coords.elemY)
            return  ((ccc.xDef * _coords.xDef > 0) || (ccc.yDef * _coords.yDef > 0))
        if (ccc.elemX == _coords.elemX - 1)
            return ccc.xDef > 0 && _coords.xDef < 0
        if (ccc.elemX == _coords.elemX + 1)
            return ccc.xDef < 0 && _coords.xDef > 0
        if (ccc.elemY == _coords.elemY - 1)
            return ccc.yDef > 0 && _coords.yDef < 0
        if (ccc.elemY == _coords.elemY + 1)
            return ccc.yDef < 0 && _coords.yDef > 0
        return false
    }

    public override function move(elapsedMilliSecs:int):void {
        performMotion(elapsedMilliSecs * speed / 1000)
    }

    public function setBomb(bombType:BombType):void {
        trace(">>> " + _map.getBlock(coords.elemX, coords.elemY).canSetBomb() + " " + bombCount)
        if (_map.getBlock(coords.elemX, coords.elemY).canSetBomb() && bombCount > 0 && !isDead) {
            trace("tried to set when left " + bombCount)
            EngineContext.triedToActivateWeapon.dispatch(slot, coords.getRealX(), coords.getRealY(), WeaponType.byValue(bombType.value));
        }
    }

    public override function explode(expl:IExplosion):void {

    }

    protected function onDamaged(id:int, health_left:int):void {
        if (slot == id) {
            life = health_left;
            makeImmortalFor(immortalTime);
        }
    }

    private function onDied(id:int):void {
        if (id == slot) {
            kill();
            _spectatorMode = true;
        }
    }

    public override function kill():void {
        life = 0;
    }

    public function hit(dmg:int):void {
    }

    public function hitWithoutImmortal(damage:int):void {
    }

    public function tryActivateWeapon():void {
        if (isDead) return;
        if (currentWeapon is IActivatableWeapon) {
            if (IActivatableWeapon(currentWeapon).canActivate(_coords.elemX, _coords.elemY, this))
                EngineContext.triedToActivateWeapon.dispatch(slot, _coords.getRealX(), _coords.getRealY(), currentWeapon.type);
        }

    }

    public function get currentWeapon():IWeapon {
        return _currentWeapon;
    }

    public function activateWeapon(x:int, y:int, type:WeaponType):void {
        if (_weapons[type.value] is IActivatableWeapon) {
            (_weapons[type.value] as IActivatableWeapon).activate(x, y, this);
            EngineContext.weaponUnitSpent.dispatch(type)
        }
    }

    public function deactivateWeapon(type:WeaponType):void {
        if (_weapons[type.value] is IDeactivatableWeapon) {
            (_weapons[type.value] as IDeactivatableWeapon).deactivate(this);
        }
    }

    override public function set life(life:int):void {
        super.life = life
        Context.Model.dispatchCustomEvent(ContextEvent.GPAGE_MY_PARAMETERS_IS_CHANGED)

    }

    override public function incSpeed():void {
        super.incSpeed()
        Context.Model.dispatchCustomEvent(ContextEvent.GPAGE_MY_PARAMETERS_IS_CHANGED)

    }

    override public function incBombCount():void {
        super.incBombCount()
        Context.Model.dispatchCustomEvent(ContextEvent.GPAGE_MY_PARAMETERS_IS_CHANGED)

    }

    override public function incBombPower():void {
        super.incBombPower()
        Context.Model.dispatchCustomEvent(ContextEvent.GPAGE_MY_PARAMETERS_IS_CHANGED)

    }

    public function decWeapon(wt:WeaponType):void {
        if (_weapons[wt.value] is IActivatableWeapon) {
            (_weapons[wt.value] as IActivatableWeapon).decCharges()
        }
    }

    override public function get direction():Direction {
        return _serverDir
    }
}
}


