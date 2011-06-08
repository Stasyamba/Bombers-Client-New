package components.common.worlds.locations {
import components.common.utils.adjustcolor.ColorMatrixObject

import mx.core.IVisualElement

[Bindable]
public class LocationViewObject 
{
    private var _locationType:LocationType;

    public var name:String = "";
    public var describe:String = "";

    public function LocationViewObject(locactionTypeP:LocationType, nameP:String, descirbeP:String) 
	{
        _locationType = locactionTypeP;

        name = nameP;
        describe = descirbeP;
    }

    public function get locationType():LocationType {
        return _locationType;
    }

}
}