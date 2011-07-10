/*
 * Copyright (c) 2011. 
 * Pavkin Vladimir
 */

package engine.games.quest.monsters.walking {
import flash.geom.Point

public class WalkingStrategy {
    public function WalkingStrategy() {
    }

    public static function xml(xml:XML):IWalkingStrategy {
        switch (String(xml.@type)) {
            case "right_wall":
                return new AlongRightWallWS()
            case "ptp":
                var a:Array = new Array()
                for each (var point:XML in xml.Point) {
                    a.push(new Point(point.@x,point.@y))
                }
                return new PointToPointWS(a)
            case "random":
                return new RandomDirectionWS(xml.@maxSec)
            case "stand":
                return new StandStillWS()
        }
        throw Context.Exception("Îרטבךא ג פאיכו WalkingStrategy.as: no walking strategy with id = " + xml.@type)
    }
}
}
