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
import engine.maps.mapObjects.bonuses.BonusAddBomb
import engine.maps.mapObjects.bonuses.BonusAddBombPower
import engine.maps.mapObjects.bonuses.BonusAddSpeed
import engine.maps.mapObjects.bonuses.BonusHeal
import engine.maps.mapObjects.bonuses.BonusResource
import engine.maps.mapObjects.bonuses.BonusType
import engine.maps.mapObjects.bonuses.BonusItem
import engine.maps.mapObjects.mines.MineType
import engine.maps.mapObjects.mines.RegularMine
import engine.maps.mapObjects.special.SpecialObject
import engine.maps.mapObjects.special.SpecialObjectType
import engine.weapons.WeaponType

public class DynObjectBuilder {

    private var explosionsBuilder:ExplosionsBuilder

    public function make(objType:IDynObjectType, block:IMapBlock, owner:IBomber = null,params:Object = null):IDynObject {

        if (objType is SpecialObjectType) {
            return new SpecialObject(block, objType as SpecialObjectType)
        }
        switch (objType) {
            case DynObjectType.NULL:
                return NullDynObject.getInstance();
            //bombs
            case BombType.REGULAR:
                return new RegularBomb(explosionsBuilder, block, owner)
            case BombType.ATOM:
                return new AtomBomb(explosionsBuilder, block, owner)
            case BombType.BOX:
                return new BoxBomb(explosionsBuilder, block, owner)
            case BombType.DYNAMITE:
                return new DynamiteBomb(explosionsBuilder, block, owner)
            case BombType.SMOKE:
                return new SmokeBomb(explosionsBuilder, block, owner)
            //bonuses
            case BonusType.ADD_BOMB:
                return new BonusAddBomb(block)
            case BonusType.ADD_BOMB_POWER:
                return new BonusAddBombPower(block)
            case BonusType.ADD_SPEED:
                return new BonusAddSpeed(block);
            case BonusType.HEAL:
                return new BonusHeal(block);
            case BonusType.WEAPON:
                return new BonusItem(block,ItemType.byValue(int(params["wt"])),int(params["count"]));
            case BonusType.RESOURCE:
                return new BonusResource(block,ResourceType.byServerValue(int(params["rt"])),int(params["count"]));
            //mines
            case MineType.REGULAR:
                return new RegularMine(block, owner);
        }
        throw Context.Exception("Error in file DynObjectBuilder.as: NotImplemented: " + objType.key);
    }

    public function setExplosionsBuilder(explosionsBuilder:ExplosionsBuilder):void {
        this.explosionsBuilder = explosionsBuilder
    }

    public static function params(obj:XML):Object {
        var res:Object = new Object()

        if(obj.@wt){
            res["wt"] = obj.@wt
        }
        return res
    }
}
}