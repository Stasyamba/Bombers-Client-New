/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.explosionss {
import engine.bombers.interfaces.IBomber
import engine.maps.IMap
import engine.model.explosionss.ExplosionType

import mx.collections.ArrayList

public class ExplosionBase {

    public function ExplosionBase(map:IMap, centerX:int, centerY:int, owner:IBomber) {
        _owner = owner
        this.map = map
        _centerX = centerX
        _centerY = centerY
    }

    protected var _owner:IBomber

    protected var map:IMap;
    public var timeToLive:int;
    protected var _centerX:int;
    protected var _centerY:int;
    private var _points:ArrayList = new ArrayList();

    public function addPoint(point:ExplosionPoint):void {
        _points.addItem(point);
    }

    public function getPoint(x:int, y:int):ExplosionPoint {
        for each (var explPoint:ExplosionPoint in _points.source) {
            if (explPoint.x == x && explPoint.y == y)
                return explPoint;
        }
        return null
    }

    public function expireBy(elapsedMilliSecs:int):void {
        timeToLive -= elapsedMilliSecs;
    }

    public function expired():Boolean {
        return timeToLive <= 0;
    }

    public function forEachPoint(todo:Function):void {
        for each (var point:ExplosionPoint in _points.source) {
            todo(point);
        }
    }

    public function get centerX():int {
        return _centerX;
    }

    public function get centerY():int {
        return _centerY;
    }
}
}