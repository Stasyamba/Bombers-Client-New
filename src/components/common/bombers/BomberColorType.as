package components.common.bombers
{
	public class BomberColorType
	{
		public static const BASE_RED:BomberColorType = new BomberColorType(1, "BASE_RED");
		public static const BASE_BLUE:BomberColorType = new BomberColorType(2, "BASE_BLUE");
		public static const BASE_GREEN:BomberColorType = new BomberColorType(3, "BASE_GREEN");
		public static const BASE_PINK:BomberColorType = new BomberColorType(4, "BASE_PINK");
		
		private var _value:int;
		private var _name:String;
		
		public function BomberColorType(value:int, name:String) {
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