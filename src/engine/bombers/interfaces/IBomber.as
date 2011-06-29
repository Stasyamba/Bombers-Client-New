/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers.interfaces {
import engine.bombers.BomberType
import engine.explosionss.interfaces.IExplosion
import engine.games.quest.monsters.ICreatureType
import engine.maps.IMap
import engine.model.signals.StateAddedSignal
import engine.model.signals.StateRemovedSignal
import engine.playerColors.PlayerColor
import engine.weapons.WeaponType

import org.osflash.signals.Signal

public interface IBomber {

    function get slot():int;

    function get userName():String;

    function putOnMap(map:IMap, x:int, y:int):void;

    function get coords():IMapCoords;

    function move(elapsedMilliSeconds:int):void;

    /**
     *
     * @param expl
     * @return is player dead after explosion
     */
    function explode(expl:IExplosion):void;

    function get becameImmortal():Signal;

    function get lostImmortal():Signal;

    function get isImmortal():Boolean;

    function get color():PlayerColor;

    function get isDead():Boolean;

    function kill():void;

    function get stateAdded():StateAddedSignal

    function get stateRemoved():StateRemovedSignal;

    //skills

    function get life():int;

    function set life(life:int):void;

    function get startLife():int

    function get lifeAuraBonus():int

    function get hasLifeAuraBonus():Boolean


    function get speed():Number

    function get baseSpeed():Number

    function get speedAuraBonus():Number

    function get hasSpeedAuraBonus():Boolean


    function get baseBlockChance():Number

    function get baseCritChance():Number


    function get bombCount():int

    function get baseBombCount():int

    function get bombCountAuraBonus():int

    function get hasBombCountAuraBonus():Boolean


    function get bombPower():int

    function get baseBombPower():int

    function get bombPowerAuraBonus():int

    function get hasBombPowerAuraBonus():Boolean


    function get immortalTime():int

    function incSpeed():void

    function incBombCount():void

    function incBombPower():void

    function takeBomb():void;

    function returnBomb():void;

    function get lifeChanged():Signal;

    function hasAura(aura:WeaponType):Boolean

    function setSpeed(i:int):void

    function resetSpeed():void

    function getTotalBlockChance(bt:BomberType):Number

    function get type():ICreatureType

    function addWeaponBonus(_weapon:WeaponType):void
}
}