/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.bombers {
import engine.utils.Direction

public class MoveTickObject {
    public var x:Number
    public var y:Number
    public var time:Number
    public var dir:Direction

    public function MoveTickObject(x:Number, y:Number, time:Number, dir:Direction) {
        this.x = x
        this.y = y
        this.time = time
        this.dir = dir
    }
}
}
