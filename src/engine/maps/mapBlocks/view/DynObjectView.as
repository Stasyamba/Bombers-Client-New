package engine.maps.mapBlocks.view {
import engine.data.Consts
import engine.maps.interfaces.IMapBlock
import engine.maps.mapObjects.DynObjectType

import flash.display.Sprite

import loading.LoadedObject

public class DynObjectView extends DestroyableSprite {

    protected var block:IMapBlock;
    protected var _baseView:Sprite;

    private var _self:Sprite;

    public override function draw():void {
        if (_self != null && contains(_self))
            removeChild(_self);
        if (block.object.type == DynObjectType.NULL)
            return;
        _self = Context.imageService.dynObject(block.object.type);
        _self.x = -(_self.width - Consts.BLOCK_SIZE)/2
        _self.y = -(_self.height - Consts.BLOCK_SIZE)/2
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
