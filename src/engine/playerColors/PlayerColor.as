/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.playerColors {
import engine.data.common.bombs.Bombs

import flash.display.BitmapData

public class PlayerColor {

    private var _key:String;
    private var _bombGlow:BitmapData;
    private var _color:uint;
    private var _value:int;

    public static const BLUE:PlayerColor = new PlayerColor(1,"blue", Bombs.BLUE_GLOW, 0x1145c7);
    public static const ORANGE:PlayerColor = new PlayerColor(2,"orange", Bombs.ORANGE_GLOW, 0xff6600);
    public static const PINK:PlayerColor = new PlayerColor(3,"pink", Bombs.PINK_GLOW, 0xFF00FF);
    public static const RED:PlayerColor = new PlayerColor(4,"red", Bombs.RED_GLOW, 0xFF0000);


    public function PlayerColor(value:int, key:String, bombGlow:BitmapData, color:uint) {
        _key = key
        _bombGlow = bombGlow
        _color = color
        _value = value
    }

    public function get key():String {
        return _key;
    }

    public function get bombGlow():BitmapData {
        return _bombGlow;
    }

    public function get color():uint {
        return _color;
    }
}
}