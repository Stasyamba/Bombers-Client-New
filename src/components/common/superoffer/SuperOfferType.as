package components.common.superoffer
{
	public class SuperOfferType
	{
		public static const ENERGY: SuperOfferType = new SuperOfferType(0, "FURY_JOE");
		public static const QUEST: SuperOfferType = new SuperOfferType(1, "R2D3");
		
		private var _value:int;
		private var _name:String;
		
		public function SuperOfferType(value:int, name:String) {
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
		
		public static function byValue(value: int): SuperOfferType
		{
			var res: SuperOfferType = null;
			
			switch(value)
			{
				case ENERGY._value:
					res = ENERGY;
					break;
				case QUEST._value:
					res = QUEST;
					break;
			}
			
			return res;
		}

	}
}