package components.common.tutorial
{
	public class TutorialPartType
	{
		public static const DONE:TutorialPartType = new TutorialPartType(5, "ALL_DONE");
		public static const PART1:TutorialPartType = new TutorialPartType(0, "PART1");
		public static const PART2:TutorialPartType = new TutorialPartType(1, "PART2");
		public static const PART3:TutorialPartType = new TutorialPartType(2, "PART3");
		public static const PART4:TutorialPartType = new TutorialPartType(3, "PART4");
		public static const PART5:TutorialPartType = new TutorialPartType(4, "PART5");
		
		
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
				case PART3.value:
					res = PART3;
					break;
				case PART4.value:
					res = PART4;
					break;
				case PART5.value:
					res = PART5;
					break;
			}
			
			return res;
		}
	}
}