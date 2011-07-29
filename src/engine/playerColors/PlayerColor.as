/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.playerColors {
import engine.data.common.bombs.Bombs;

import flash.display.BitmapData;

public class PlayerColor {

    private var _key:String;
    private var _bombGlow:BitmapData;
    private var _color:uint;
    private var _colorId:int;
    private var _id:int;

    public static const BLUE:PlayerColor = new PlayerColor(1001, 1, "blue", Bombs.BLUE_GLOW, 0x1145c7);
    public static const ORANGE:PlayerColor = new PlayerColor(1002, 2, "orange", Bombs.ORANGE_GLOW, 0xff6600);
    public static const PINK:PlayerColor = new PlayerColor(1003, 3, "pink", Bombs.PINK_GLOW, 0xFF00FF);
    public static const RED:PlayerColor = new PlayerColor(1000, 4, "red", Bombs.RED_GLOW, 0xFF0000);
    public static const GREEN:PlayerColor = new PlayerColor(1004, 5, "green", Bombs.RED_GLOW, 0x22940d);
    public static const BLACK:PlayerColor = new PlayerColor(1005, 6, "black", Bombs.RED_GLOW, 0x000000);


    public function PlayerColor(id:int, colorId:int, key:String, bombGlow:BitmapData, color:uint) {
        _id = id;
        _key = key
        _bombGlow = bombGlow
        _color = color
        _colorId = colorId
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

    public function get colorId():int {
        return _colorId
    }

    public function get id():int {
        return _id
    }

    public static function byColorId(value:int):PlayerColor {
        switch (value) {
            case BLUE.colorId:
                return BLUE;
            case ORANGE.colorId:
                return ORANGE;
            case PINK.colorId:
                return PINK;
            case RED.colorId:
                return RED;
            case GREEN.colorId:
                return GREEN;
            case BLACK.colorId:
                return BLACK;
        }
        throw Context.Exception("Error in PlayerColor: no color with value " + value);
    }

    public static function byId(value:int):PlayerColor {
        switch (value) {
            case BLUE.id:
                return BLUE;
            case ORANGE.id:
                return ORANGE;
            case PINK.id:
                return PINK;
            case RED.id:
                return RED;
            case GREEN.id:
                return GREEN;
            case BLACK.id:
                return BLACK;
        }
        return RED;
    }

	
	public static function haveId(id: int): Boolean
	{
		var res: Boolean = false;
		
		switch(id)
		{
			case BLUE.id:
			case ORANGE.id:
			case PINK.id:
			case RED.id:
			case GREEN.id:
			case BLACK.id:
				res = true;
				break;
		}
		
		return res;
	}
}
}