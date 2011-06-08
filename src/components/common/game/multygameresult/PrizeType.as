package components.common.game.multygameresult
{
	public class PrizeType
	{
		public static const RESOURCE:PrizeType = new PrizeType(1, "RESOURCE_TYPE");
		public static const CUP:PrizeType = new PrizeType(2, "CUP_TYPE");
		public static const COLLECTION_PART:PrizeType = new PrizeType(3, "COLLECTIONPART_TYPE");
		
		private var _value:int;
		private var _name:String;
		
		public function PrizeType(value:int, name:String) {
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