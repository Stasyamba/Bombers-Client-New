/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers {
import components.common.items.ItemProfileObject
import components.common.items.ItemType

import engine.EngineContext
import engine.bombers.interfaces.IPlayerBomber
import engine.bombers.mapInfo.InputDirection
import engine.bombss.BombType
import engine.explosionss.interfaces.IExplosion
import engine.games.IGame
import engine.maps.mapObjects.DynObjectType
import engine.playerColors.PlayerColor
import engine.profiles.GameProfile
import engine.utils.Direction
import engine.weapons.WeaponBuilder
import engine.weapons.WeaponType
import engine.weapons.interfaces.IActivatableWeapon
import engine.weapons.interfaces.IDeactivatableWeapon
import engine.weapons.interfaces.IWeapon

public class QuestPlayerBomber extends BomberBase implements IPlayerBomber {

    private var _direction:InputDirection;

    private var lastViewDir:Direction = Direction.NONE;

    private var _gameProfile:GameProfile
    /*
     * use BombersBuilder instead
     * */
    protected var _weaponBuilder:WeaponBuilder;
    protected var _currentWeapon:IWeapon
//    protected var _weapons:Array = new Array()
    private var _spectatorMode:Boolean = false

    public function QuestPlayerBomber(game:IGame, slot:int, gameProfile:GameProfile, color:PlayerColor, direction:InputDirection, weaponBuilder:WeaponBuilder) {
        super(game, slot, gameProfile.currentBomberType.getEngineType(), gameProfile.nick, color, gameProfile.aursTurnedOn);
        _weaponBuilder = weaponBuilder
        this._gameProfile = gameProfile
//        for (var i:int = 0; i < _gameProfile.gotItems.length; i++) {
//            var ipo:ItemProfileObject = _gameProfile.gotItems[i];
//            if (Context.Model.itemsCategoryManager.getItemCategory(ipo.itemType) == ItemCategory.WEAPON) {
//                _weapons[ipo.itemType.value] = weaponBuilder.fromItemType(ipo.itemType, ipo.itemCount)
//            }
//        }

//        if (gameProfile.selectedWeaponLeftHand != null)
//            _currentWeapon = _weapons[gameProfile.selectedWeaponLeftHand.itemType.value]
        _direction = direction;

//        EngineContext.currentWeaponChanged.add(onCurrentWeaponChanged)
        EngineContext.weaponUnitSpent.add(onWeaponUnitSpent)
        EngineContext.playerDied.addOnce(function():void {
            _spectatorMode = true;
        })
    }

    private function onWeaponUnitSpent(type:WeaponType):void {
//        for (var i:int = 0; i < Context.Model.currentSettings.gameProfile.gotItems.length; i++) {
//            var obj:ItemProfileObject = Context.Model.currentSettings.gameProfile.gotItems[i];
//            if (obj.itemType.value == type.value) {
//                obj.itemCount--;
//                break
//            }
//        }
        Context.Model.dispatchCustomEvent(ContextEvent.GP_CURRENT_LEFT_WEAPON_IS_CHANGED)
//        Context.Model.dispatchCustomEvent(ContextEvent.GP_GOTITEMS_IS_CHANGED)
//        Context.Model.dispatchCustomEvent(ContextEvent.GP_PACKITEMS_IS_CHANGED)
        Context.Model.dispatchCustomEvent(ContextEvent.GPAGE_UPDATE_GAME_WEAPONS);
    }

//    private function onCurrentWeaponChanged():void {
//        if (_gameProfile.selectedWeaponLeftHand != null)
//            _currentWeapon = _weapons[_gameProfile.selectedWeaponLeftHand.itemType.value]
//        else
//            _currentWeapon = NullWeapon.instance
//    }

    public function performMotion(moveAmount:Number):void {

        if (_direction.direction == Direction.NONE || isDead)
            return;
        var x:int = _coords.getRealX();
        var y:int = _coords.getRealY();

        switch (_direction.direction) {
            case Direction.LEFT:
                _coords.stepLeft(moveAmount, _spectatorMode);
                checkViewHorDirectionChanged(x);
                break;
            case Direction.RIGHT:
                _coords.stepRight(moveAmount, _spectatorMode);
                checkViewHorDirectionChanged(x);
                break;
            case Direction.UP:
                _coords.stepUp(moveAmount, _spectatorMode);
                checkViewVertDirectionChanged(x);
                break;
            case Direction.DOWN:
                _coords.stepDown(moveAmount, _spectatorMode);
                checkViewVertDirectionChanged(x);
                break;
        }
        if (x != _coords.getRealX() || y != _coords.getRealY()) {
            EngineContext.playerCoordinatesChanged.dispatch(_coords.getRealX(), _coords.getRealY());
        } else if (lastViewDir != Direction.NONE) {
            lastViewDir = Direction.NONE;
            EngineContext.playerViewDirectionChanged.dispatch(_coords.getRealX(), _coords.getRealY(), Direction.NONE);
        }
    }

    private function checkViewHorDirectionChanged(oldX:int):void {
        if (_coords.getRealX() != oldX && lastViewDir != _direction.direction) {
            lastViewDir = _direction.direction;
            EngineContext.playerViewDirectionChanged.dispatch(_coords.getRealX(), _coords.getRealY(), _direction.direction);
        }
    }

    private function checkViewVertDirectionChanged(oldY:int):void {
        if (_coords.getRealY() != oldY && lastViewDir != _direction.direction) {
            lastViewDir = _direction.direction;
            EngineContext.playerViewDirectionChanged.dispatch(_coords.getRealX(), _coords.getRealY(), _direction.direction);
        }
    }

    private function viewDirectionChanged():Boolean {
        return (Direction.isHorizontal(_direction.direction) && _coords.yDef == 0) ||
                (Direction.isVertical(_direction.direction) && _coords.xDef == 0) ||
                (_direction.direction == Direction.NONE && lastViewDir != Direction.NONE );
    }

    private function updateInputDirection():void {
        var flag:Boolean = viewDirectionChanged();
        if (flag)
            lastViewDir = _direction.direction;
        EngineContext.playerInputDirectionChanged.dispatch(_coords.getRealX(), _coords.getRealY(), _direction.direction, flag);
    }


    public function addDirection(m:Direction):void {
        var dirBefore:Direction = _direction.direction;
        _direction.addDirection(m);

        if (dirBefore != _direction.direction) {
            updateInputDirection()
        }

    }

    public function removeDirection(m:Direction):void {
        var dirBefore:Direction = _direction.direction;
        _direction.removeDirection(m);

        if (dirBefore != _direction.direction) {
            updateInputDirection();
        }
    }

    public override function move(elapsedMilliSecs:int):void {
        performMotion(elapsedMilliSecs * speed / 1000)
    }

    public function setBomb(bombType:BombType):void {
        trace(">>> " + _map.getBlock(coords.elemX, coords.elemY).canSetBomb() + " " + bombCount)
        if (_map.getBlock(coords.elemX, coords.elemY).canSetBomb() && bombCount > 0 && !isDead) {
            trace("tried to set when left " + bombCount)
            EngineContext.qActivateWeapon.dispatch(slot, coords.elemX, coords.elemY, WeaponType.byValue(bombType.value));
        }
    }

    public override function explode(expl:IExplosion):void {
        hit(expl.damage)
    }

    public function hit(dmg:int):void {
        if (dmg <= 0) //smoke expl
            return
        hitWithoutImmortal(dmg)
        if (!isDead)
            super.makeImmortalFor(immortalTime);
    }


    public function hitWithoutImmortal(dmg:int):void {
        if (dmg <= 0)
            return
        life - dmg < 0 ? life = 0 : life -= dmg;

        EngineContext.playerDamaged.dispatch(dmg, isDead)
        if (isDead) {
            EngineContext.playerDied.dispatch();
        }
    }

    public override function kill():void {
        EngineContext.playerDied.dispatch();
        EngineContext.playerDamaged.dispatch(_life, true);
        life = 0;
    }

    public function tryActivateWeapon():void {
        if (isDead) return;
        if (currentWeapon is IActivatableWeapon) {
            if (IActivatableWeapon(currentWeapon).canActivate(_coords.elemX, _coords.elemY, this))
                activateWeapon(_coords.elemX, _coords.elemY, currentWeapon.type)
        }
    }

    public function get currentWeapon():IWeapon {
        return _currentWeapon;
    }

    public function activateWeapon(x:int, y:int, type:WeaponType):void {
        //regular bomb special case
        if (type.value == this.bomberType.baseBomb.value) {
            EngineContext.qAddObject.dispatch(slot, x, y, DynObjectType.byValue(type.value))
            takeBomb()
        } else {
            if (currentWeapon.type == type) {
                var aw:IActivatableWeapon = currentWeapon as IActivatableWeapon
                if (aw != null) {
                    aw.qActivate(x, y, this);
                    EngineContext.weaponUnitSpent.dispatch(type)
                    Context.Model.currentSettings.gameProfile.useQuestLeftWeapon()
                }
            }else{
                Context.Exception("������ � �����: QuestPlayerBomber.as: tried to activate weapon that doesn't exist")
            }
        }
    }

    public function deactivateWeapon(type:WeaponType):void {
        var w:IDeactivatableWeapon = _weaponBuilder.fromWeaponType(type, 1) as IDeactivatableWeapon
        if (w == null){
           throw Context.Exception("������ � ����� QuestPlayerBomber.as: tried to deactivate unsupported weapon " + type.key)
        }
        w.qDeactivateStatic(this);
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
        if (currentWeapon.type == wt){
            (currentWeapon as IActivatableWeapon).decCharges()
        }
    }


    public override function addWeaponBonus(wt:WeaponType):void {
        _currentWeapon = _weaponBuilder.fromWeaponType(wt, 1)
        Context.Model.currentSettings.gameProfile.setQuestWeapon(new ItemProfileObject(ItemType.byValue(wt.value), 1))
    }

    override public function get direction():Direction {
        return _direction.direction
    }
}
}