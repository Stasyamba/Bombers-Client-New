/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.profiles {
import components.common.bombers.BomberType

import engine.playerColors.PlayerColor

public class PlayerGameProfile {
    public var slot:int
    public var bomberType:BomberType
    public var x:int
    public var y:int
    public var auras:Array
    public var color:PlayerColor

    public function PlayerGameProfile(slot:int, bomberType:BomberType, x:int, y:int, auras:Array, color:PlayerColor) {
        this.slot = slot
        this.bomberType = bomberType
        this.x = x
        this.y = y
        this.auras = auras
        this.color = color
    }
}
}
