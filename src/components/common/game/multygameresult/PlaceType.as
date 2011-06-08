package components.common.game.multygameresult
{
	public class PlaceType
	{
		public static const FIRST:PlaceType = new PlaceType(1, "F");
		public static const SECOND:PlaceType = new PlaceType(2, "S");
		public static const THIRD:PlaceType = new PlaceType(3, "T");
		
		private var _value:int;
		private var _name:String;
		
		public function PlaceType(value:int, name:String) {
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