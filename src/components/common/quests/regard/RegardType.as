package components.common.quests.regard
{
	public class RegardType
	{
		public static const RESOURCE_GOLD:RegardType = new RegardType(0, "R_GOLD");
		public static const RESOURCE_CRYSTALS:RegardType = new RegardType(1, "R_CRYSTALS");
		public static const RESOURCE_ADAMANT:RegardType = new RegardType(2, "R_ADAMANT");
		public static const RESOURCE_ANTIMATTER:RegardType = new RegardType(3, "R_ANTIMATTER");
		
		public static const RESOURCE_ITEM:RegardType = new RegardType(4, "R_ITEM");
		public static const RESOURCE_ENERGY:RegardType = new RegardType(5, "R_ENERGY");
		public static const RESOURCE_EXP:RegardType = new RegardType(6, "R_EXP");
		
		
		private var _value:int;
		private var _name:String;
		
		public function RegardType(value:int, name:String) {
			_value = value;
			_name = name;
		}
		
		
		public function get value():int {
			return _value;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function toString():String {
			return "value: " + _value.toString() + " name: " + _name.toString();
		}
	}
}