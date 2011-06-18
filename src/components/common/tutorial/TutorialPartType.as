package components.common.tutorial
{
	public class TutorialPartType
	{
		public static const DONE:TutorialPartType = new TutorialPartType(0, "ALL_DONE");
		public static const PART1:TutorialPartType = new TutorialPartType(1, "PART1");
		public static const PART2:TutorialPartType = new TutorialPartType(2, "PART2");
		
		
		private var _value:int;
		private var _name:String;
		
		public function TutorialPartType(value:int, name:String) {
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
		
		public static function byValue(value: int): TutorialPartType
		{
			var res: TutorialPartType = null;
			
			switch(value)
			{
				case DONE.value:
					res = DONE;
					break;
				case PART1.value:
					res = PART1;
					break;
				case PART2.value:
					res = PART2;
					break;
			}
			
			return res;
		}
	}
}