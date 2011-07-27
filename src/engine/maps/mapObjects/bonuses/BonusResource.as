/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.maps.mapObjects.bonuses {
import components.common.resources.ResourceObject
import components.common.resources.ResourceType

import engine.bombers.interfaces.IBomber
import engine.maps.interfaces.ICollectableDynObject
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock

public class BonusResource extends BonusBase implements ICollectableDynObject {

    private var _rtype:ResourceType;
    private var _count:int;

    public function BonusResource(block:IMapBlock, rt:ResourceType, count:int) {
        super(block)
        _rtype = rt
        _count = count;
    }

    public override function activateOn(player:IBomber, params:Object = null):void {
        Context.game.resourceCollected(_rtype, _count ,player)
    }

    public function get type():IDynObjectType {
        return BonusType.RESOURCE;
    }

    public function get count():int {
        return _count
    }

    public function get rtype():ResourceType {
        return _rtype
    }
}
}
