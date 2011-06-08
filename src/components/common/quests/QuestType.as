package components.common.quests{
	import components.common.worlds.locations.LocationType;

	public class QuestType {
		
		public static const GRASS_Q1:QuestType = new QuestType(0, "GRASS_Q1", LocationType.WORLD1_GRASSFIELDS);
		public static const GRASS_Q2:QuestType = new QuestType(1, "GRASS_Q2", LocationType.WORLD1_GRASSFIELDS);
		public static const GRASS_Q3:QuestType = new QuestType(2, "GRASS_Q3", LocationType.WORLD1_GRASSFIELDS);
		public static const GRASS_Q4:QuestType = new QuestType(3, "GRASS_Q4", LocationType.WORLD1_GRASSFIELDS);
				
		
		private var _value:int;
		private var _name:String;
		private var _locationType: LocationType;
		
		public function QuestType(value:int, name:String, locationType: LocationType) {
			_value = value;
			_name = name;
			_locationType = locationType;
		}
		
		
		public function get locationType():LocationType
		{
			return _locationType;
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
		
		/*public static function byValue(value:int):MedalType {
			switch (value) 
			{
				case GOLD_MEDAL.value:
					return GOLD_MEDAL;
			}
		}*/
	}
}