package components.common.bombers
{
	import engine.bombers.BomberType;
	
	public class BomberType
	{
		public static const FURY_JOE:BomberType = new BomberType(0, "FURY_JOE");
		public static const R2D3:BomberType = new BomberType(1, "R2D3");
	
		private var _value:int;
		private var _name:String;
		
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
				
				default:
					res = null;
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