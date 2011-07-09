/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.explosionss {
public class ExplosionType {

    public static const REGULAR:ExplosionType = new ExplosionType("REGULAR", 1000, true, false,5);
    public static const NULL:ExplosionType = new ExplosionType("NULL", 0, true, false,0);
    public static const COMPLEX:ExplosionType = new ExplosionType("COMPLEX", 0, true, false,0);
    public static const ATOM:ExplosionType = new ExplosionType("ATOM", 3000, true, true,10);
    public static const BOX:ExplosionType = new ExplosionType("BOX", 0, false, false,0);
    public static const DYNAMITE:ExplosionType = new ExplosionType("DYNAMITE", 2000, true, false,5);
    public static const SMOKE:ExplosionType = new ExplosionType("SMOKE", 0, false, false,0)


    public static function byValue(value:String):ExplosionType {
        switch (value) {
            case "REGULAR":return REGULAR;
            case "NULL":return NULL;
            case "ATOM":return ATOM;
            case "BOX":return BOX;
            case "DYNAMITE":return DYNAMITE;
            case "SMOKE":return SMOKE;
        }
        throw Context.Exception("Îרטבךא ג פאיכו ExplosionType.as: Invalid explosion type value");
    }

    private var _printsPrints:Boolean
    private var _timeToLive:int;
    private var _value:String;
    private var _printsEverywhere:Boolean;
    private var _damage:int

    public function ExplosionType(value:String, timeToLive:int, printsPrints:Boolean,printsEverywhere:Boolean, damage:int) {
        _printsPrints = printsPrints
        _timeToLive = timeToLive
        _value = value
        _printsEverywhere = printsEverywhere
        _damage = damage
    }

    public function get value():String {
        return _value;
    }

    public function get timeToLive():int {
        return _timeToLive;
    }

    public function get printsEverywhere():Boolean {
        return _printsEverywhere;
    }

    public function get printsPrints():Boolean {
        return _printsPrints
    }

    public function get damage():int {
        return _damage
    }
}
}