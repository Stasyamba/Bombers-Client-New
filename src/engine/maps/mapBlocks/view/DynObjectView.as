package engine.maps.mapBlocks.view {
import engine.data.Consts
import engine.maps.interfaces.IMapBlock
import engine.maps.mapObjects.DynObjectType
import engine.maps.mapObjects.bonuses.BonusItem
import engine.maps.mapObjects.bonuses.BonusResource
import engine.maps.mapObjects.bonuses.BonusType

import flash.display.Sprite

public class DynObjectView extends DestroyableSprite {

    protected var block:IMapBlock;
    protected var _baseView:Sprite;

    protected var _self:Sprite;

    public override function draw():void {
        if (_self != null && contains(_self))
            removeChild(_self);
        if (block.object.type == DynObjectType.NULL)
            return;
        //todo: add abstraction
        var postfix:String;
        if (block.object.type == BonusType.RESOURCE) {
            postfix = String((block.object as BonusResource).count);
        }else if (block.object.type == BonusType.ITEM) {
            postfix = String((block.object as BonusItem).weapon.value)
        }
        _self = Context.imageService.dynObject(block.object.type, postfix);
        _self.x = -(_self.width - Consts.BLOCK_SIZE) / 2
        _self.y = -(_self.height - Consts.BLOCK_SIZE) / 2
        addChild(_self)

    }

    public function DynObjectView(block:IMapBlock, baseView:Sprite) {
        this.block = block;
        _baseView = baseView;
    }

    override public function destroy():void {

        if (_baseView.contains(this))
            _baseView.removeChild(this);
    }
}
}
