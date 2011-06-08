package components.common.quests.medals{
	
	public class MedalType 
	{
		
		public static const GOLD_MEDAL:MedalType = new MedalType(0, "GOLD_MEDAL");
		public static const SILVER_MEDAL:MedalType = new MedalType(1, "SILVER_MEDAL");
		public static const BRONZE_MEDAL:MedalType = new MedalType(2, "BRONZE_MEDAL");
		//public static const NO_MEDAL:MedalType = new MedalType(3, "NO_MEDAL");
		
		
		
		private var _value:int;
		private var _name:String;
		
		public function MedalType(value:int, name:String) {
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
		
		public function isLessOrEqual(medalType: MedalType): Boolean
		{
			var res: Boolean = false;
			
			switch(medalType)
			{
				case MedalType.GOLD_MEDAL:
					res = true;
					break;
				
				case MedalType.SILVER_MEDAL:
					if(this == MedalType.BRONZE_MEDAL || this == MedalType.SILVER_MEDAL)
					{
						res = true;
					}
					break;
				
				case MedalType.BRONZE_MEDAL:
					if(this == MedalType.BRONZE_MEDAL)
					{
						res = true;
					}
					break;
				
			}
			
			return res;
		}
		
	}
}