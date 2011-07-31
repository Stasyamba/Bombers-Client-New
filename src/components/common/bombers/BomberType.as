package components.common.bombers
{
	import engine.bombers.BomberType;
	
	public class BomberType
	{
		public static const FURY_JOE:BomberType = new BomberType(10000, "FURY_JOE");
		public static const R2D3:BomberType = new BomberType(10001, "R2D3");
		public static const ZOMBIE:BomberType = new BomberType(10002, "ZOMBIE");
		
		
		private var _value:int;
		private var _name:String;
		
		public static function getViewSpeed(speed:Number):int {
			return int(Math.round((Math.log(speed) - Math.log(100)) / Math.log(1.1))) + 1
		}
		
		public function BomberType(value:int, name:String) {
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
		
		public static function byValue(value: int):BomberType
		{
			var res: BomberType = null;
			
			switch(value)
			{
				case FURY_JOE.value:
					res = FURY_JOE;
					break;
				
				case R2D3.value:
					res = R2D3;
					break;
				
				case ZOMBIE.value:
					res = ZOMBIE;
					break;
				
				default:
					res = null;
					break;
			}
			
			return res;
		}
		
		public static function haveId(id: int): Boolean
		{
			var res: Boolean = false;
			
			switch(id)
			{
				case FURY_JOE.value:
				case R2D3.value:
				case ZOMBIE.value:
					res = true;
					break;
			}
			
			return res;
		}
		
		public function getEngineType(): engine.bombers.BomberType
		{
			return engine.bombers.BomberType.byValue(this.value);
		}
	}
}