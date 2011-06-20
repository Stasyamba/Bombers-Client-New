/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.bonuses {
import engine.maps.interfaces.IDynObjectType

import loading.LoaderUtils

public class BonusType implements IDynObjectType {

    public static const WEAPON:BonusType = new BonusType(100,"WEAPON");

    public static const ADD_BOMB:BonusType = new BonusType(101, "ADD_BOMB");
    public static const ADD_BOMB_POWER:BonusType = new BonusType(102, "ADD_BOMB_POWER");
    public static const ADD_SPEED:BonusType = new BonusType(103, "ADD_SPEED");
    public static const HEAL:BonusType = new BonusType(104, "HEAL");

    public static const EXPERIENCE:BonusType = new BonusType(105, "EXPERIENCE")
    public static const RESOURCE:BonusType = new BonusType(106, "RESOURCE")


    private var _value:int;
    private var _key:String;

    public static function byValue(value:int):BonusType {
        var r:BonusType = [WEAPON,ADD_BOMB, ADD_BOMB_POWER,ADD_SPEED,HEAL,RESOURCE,EXPERIENCE].filter(function (bt:BonusType):Boolean{
            return bt.value == value
        })[0]
        if(r) return r;
        throw new ArgumentError("wrong bonus type value")
    }

    public function BonusType(value:int, key:String) {
        _value = value;
        _key = key;
    }

    public function get value():int {
        return _value;
    }

    public function get key():String {
        return _key;
    }

    public function get waitToAdd():Number {
        return 0
    }

    public function get stringId():String {
        return LoaderUtils.stringId(value)
    }
}
}