package components.common.bombers.colors
{
	import components.common.base.access.rules.AccessRuleObject;
	import components.common.base.access.rules.IAccessRule;
	import components.common.resources.ResourcePrice;
	
	import engine.playerColors.PlayerColor;

	public class BomberColorObject
	{
		public var color:PlayerColor;
		public var name: String;
		public var price: ResourcePrice;
		public var accessRules: Array;
		
		public function BomberColorObject(colorP:PlayerColor,
										  nameP: String,
										  priceP: ResourcePrice,
										  accessRulesP: Array)
		{
			color = colorP;
			name = nameP;
			price = priceP;
			
			accessRules = new Array();
			
			if(accessRulesP != null)
			{
				for each(var r:IAccessRule in accessRulesP)
				{
					accessRules.push(r);
				}
			}
		}
		
		public function checkAccess():Array {
			var res:Array = new Array();
			
			for each(var r:IAccessRule in accessRules) {
				res.push(new AccessRuleObject(r, r.checkAccess()));
			}
			
			return res;
		}
	}
}