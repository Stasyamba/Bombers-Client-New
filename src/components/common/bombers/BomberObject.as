package components.common.bombers {
import components.common.base.access.rules.AccessRuleObject;
import components.common.base.access.rules.IAccessRule;


public class BomberObject {
    private var _type:BomberType;
    private var _rulesList:Array;
    private var _viewObject:BomberViewObject;
	private var _cost: int;

    public function BomberObject(typeP:BomberType, accessRulesP:Array, viewObject:BomberViewObject, cost: int = 0) {
        _type = typeP;

        _rulesList = new Array();

        for each(var ar:IAccessRule in accessRulesP) {
            _rulesList.push(ar);
        }

        _viewObject = viewObject;
		_cost = cost;
    }

	public function get cost():int
	{
		return _cost;
	}

    public function get viewObject():BomberViewObject {
        return _viewObject;
    }

    public function get type():BomberType {
        return _type;
    }

    public function checkAccess():Array {
        var res:Array = new Array();

        for each(var r:IAccessRule in _rulesList) {
            res.push(new AccessRuleObject(r, r.checkAccess()));
        }

        return res;
    }
}
}