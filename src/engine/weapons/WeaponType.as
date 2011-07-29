/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.weapons {
public class WeaponType {

    public static const NULL:WeaponType = new WeaponType(-1, "NULL");
    //bombs
    public static const REGULAR_BOMB_WEAPON:WeaponType = new WeaponType(00, "REGULAR_BOMB_WEAPON");
    public static const ATOM_BOMB_WEAPON:WeaponType = new WeaponType(01, "ATOM_BOMB_WEAPON");
    public static const BOX_BOMB_WEAPON:WeaponType = new WeaponType(02, "BOX_BOMB_WEAPON")
    public static const DYNAMITE_WEAPON:WeaponType = new WeaponType(03, "DYNAMITE_WEAPON");
    public static const SMOKE_BOMB_WEAPON:WeaponType = new WeaponType(04, "SMOKE_BOMB_WEAPON")
    //potions
    public static const HAMELEON:WeaponType = new WeaponType(21, "HAMELEON_WEAPON", true);
    public static const LITTLE_HEALTH_PACK_WEAPON:WeaponType = new WeaponType(22, "LITTLE_HEALTH_PACK_WEAPON", true)
    public static const MEDIUM_HEALTH_PACK_WEAPON:WeaponType = new WeaponType(23, "MEDIUM_HEALTH_PACK_WEAPON", true)
    //mines
    public static const REGULAR_MINE:WeaponType = new WeaponType(41, "REGULAR_MINE_WEAPON");
    //auras
    public static const ICE_AURA:WeaponType = new WeaponType(71, "ICE_AURA");
    public static const FIRE_AURA:WeaponType = new WeaponType(72, "FIRE_AURA");
    public static const SPEED_AURA:WeaponType = new WeaponType(73, "SPEED_AURA");
    public static const BOMB_COUNT_AURA:WeaponType = new WeaponType(74, "BOMB_COUNT_AURA");
    public static const BOMB_POWER_AURA:WeaponType = new WeaponType(75, "BOMB_POWER_AURA");
    public static const START_LIFE_AURA:WeaponType = new WeaponType(76, "START_LIFE_AURA");
    public static const ELECTRO_AURA:WeaponType = new WeaponType(77, "ELECTRO AURA");


    private var _value:int;
    private var _key:String;
    private var _decreaseOnActivate:Boolean


    public function WeaponType(value:int, key:String, decreaseOnActivate:Boolean = false) {
        _value = value;
        _key = key;
        _decreaseOnActivate = decreaseOnActivate
    }

    public function get value():int {
        return _value;
    }

    public function get key():String {
        return _key;
    }

    public function get decreaseOnActivate():Boolean {
        return _decreaseOnActivate
    }

    private static var all:Array = [REGULAR_BOMB_WEAPON,ATOM_BOMB_WEAPON,HAMELEON,BOX_BOMB_WEAPON,REGULAR_MINE,DYNAMITE_WEAPON,SMOKE_BOMB_WEAPON,LITTLE_HEALTH_PACK_WEAPON,MEDIUM_HEALTH_PACK_WEAPON];

    public static function byValue(value:int):WeaponType {
        var wt:WeaponType = all.filter(function (bt:WeaponType,a:*,b:*):Boolean {
            return bt.value == value
        })[0]
        if (wt) return wt;
        return NULL
    }

    public static function hasWeapon(value:int):Boolean {
        return byValue(value) != NULL;
    }
}
}