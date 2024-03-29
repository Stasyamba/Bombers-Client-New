package components.common.resources {
	
[Bindable]
public class ResourceObject {
    private var _type:ResourceType;
    private var _value:int = 0;

    public function ResourceObject(type:ResourceType, amount:int = 0) {
        _type = type;
        _value = amount;
    }


    public function get type():ResourceType {
        return _type;
    }

    public function get value():int {
        return _value;
    }

	public function set type(value: ResourceType):void
	{
		_type = value;
	}
	
    public function set value(value:int):void {
        if (value >= 0) {
            _value = value;
        }
    }

    public function cloneFrom(ro:ResourceObject):void {
        this._type = ro.type;
        this._value = ro.value;
    }
	
	public function clone(): ResourceObject
	{
		return new ResourceObject(this._type, this._value);
	}

}
}