package engine.maps.bigObjects.view {
import engine.maps.bigObjects.ActivatedBigObject
import engine.maps.bigObjects.BigObjectActivator
import engine.maps.bigObjects.BigObjectBase
import engine.maps.bigObjects.SimpleBigObject
import engine.maps.bigObjects.SpecialSimpleBigObject

import flash.display.Sprite

public class BigObjectViewFactory {
    public function BigObjectViewFactory() {
    }

    public static function make(obj:BigObjectBase):Sprite {
        if (obj is BigObjectActivator) {
            return new BigObjectActivatorView(obj);
        }
        if (obj is ActivatedBigObject) {
            return new ActivatedBigObjectView(obj);
        }
        if (obj is SpecialSimpleBigObject) {
            return new SpecialSimpleBigObjectView(obj as SpecialSimpleBigObject);
        }
        if (obj is SimpleBigObject) {
            return new SimpleBigObjectView(obj as SimpleBigObject);
        }
        throw Context.Exception("Error at BigObjectViewFactory.as: Unknown big object type");
    }
}
}
