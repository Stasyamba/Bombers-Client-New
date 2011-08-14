package engine.maps.mapObjects {
import engine.maps.interfaces.IMapBlock

public class DynObjectBase {

    protected var _id:int;
    protected var _block:IMapBlock;

    public function DynObjectBase(id:int, block:IMapBlock) {
        _id = id
        _block = block
    }

    public function get id():int {
        return _id
    }

    public function get block():IMapBlock {
        return _block
    }

    public function get x():int {
        return block.x;
    }

    public function get y():int {
        return block.y;
    }
}
}
