/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.maps.builders {
import components.common.items.ItemType
import components.common.resources.ResourceType

import engine.bombers.interfaces.IBomber
import engine.bombss.AtomBomb
import engine.bombss.BombType
import engine.bombss.BoxBomb
import engine.bombss.DynamiteBomb
import engine.bombss.RegularBomb
import engine.bombss.SmokeBomb
import engine.explosionss.ExplosionsBuilder
import engine.maps.interfaces.IDynObject
import engine.maps.interfaces.IDynObjectType
import engine.maps.interfaces.IMapBlock
import engine.maps.mapObjects.DynObjectType
import engine.maps.mapObjects.NullDynObject
import engine.maps.mapObjects.action.GatePass
import engine.maps.mapObjects.action.GatePassType
import engine.maps.mapObjects.bonuses.BonusAddBomb
import engine.maps.mapObjects.bonuses.BonusAddBombPower
import engine.maps.mapObjects.bonuses.BonusAddSpeed
import engine.maps.mapObjects.bonuses.BonusHeal
import engine.maps.mapObjects.bonuses.BonusItem
import engine.maps.mapObjects.bonuses.BonusResource
import engine.maps.mapObjects.bonuses.BonusType
import engine.maps.mapObjects.mines.MineType
import engine.maps.mapObjects.mines.RegularMine
import engine.maps.mapObjects.special.SpecialObject
import engine.maps.mapObjects.special.SpecialObjectType

public class DynObjectBuilder {

    private var explosionsBuilder:ExplosionsBuilder

    public function make(id:int, objType:IDynObjectType, block:IMapBlock, owner:IBomber = null, params:Object = null):IDynObject {

        if (objType is SpecialObjectType) {
            return new SpecialObject(id, block, objType as SpecialObjectType)
        }
        switch (objType) {
            case DynObjectType.NULL:
                return NullDynObject.getInstance();
            //bombs
            case BombType.REGULAR:
                return new RegularBomb(id, explosionsBuilder, block, owner)
            case BombType.ATOM:
                return new AtomBomb(id, explosionsBuilder, block, owner)
            case BombType.BOX:
                return new BoxBomb(id, explosionsBuilder, block, owner)
            case BombType.DYNAMITE:
                return new DynamiteBomb(id, explosionsBuilder, block, owner)
            case BombType.SMOKE:
                return new SmokeBomb(id, explosionsBuilder, block, owner)
            //bonuses
            case BonusType.ADD_BOMB:
                return new BonusAddBomb(id, block)
            case BonusType.ADD_BOMB_POWER:
                return new BonusAddBombPower(id, block)
            case BonusType.ADD_SPEED:
                return new BonusAddSpeed(id, block);
            case BonusType.HEAL:
                return new BonusHeal(id, block);
            case BonusType.ITEM:
                return new BonusItem(id, block, ItemType.byValue(int(params["wt"])), int(params["count"]));
            case BonusType.RESOURCE:
                return new BonusResource(id, block, ResourceType.byServerValue(int(params["rt"])), int(params["count"]));
            //mines
            case MineType.REGULAR:
                return new RegularMine(id, block, owner);
            //gates
            case GatePassType.GATE_PASS:
                return new GatePass(id, block, params["orientation"] != "horizontal", params["active"] == "true", int(params["period"]) / 1000);
        }
        throw Context.Exception("Error in file DynObjectBuilder.as: NotImplemented: " + objType.key);
    }

    public function setExplosionsBuilder(explosionsBuilder:ExplosionsBuilder):void {
        this.explosionsBuilder = explosionsBuilder
    }

    public static function params(obj:XML):Object {
        var res:Object = new Object()

        if (obj.@wt) {
            res["wt"] = obj.@wt
        }
        if (obj.@count) {
            res["count"] = obj.@count
        }
        return res
    }
}
}