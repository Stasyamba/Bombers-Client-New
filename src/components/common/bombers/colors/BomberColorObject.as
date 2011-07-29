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
		public var accessRulesFailed: Array;
		public var gotColor:Boolean;
		
		public function BomberColorObject(colorP:PlayerColor,
										  nameP: String,
										  priceP: ResourcePrice,
										  accessRulesP: Array,
										  failedRulesP: Array = null,
										  gotColorP: Boolean = false)
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
			
			accessRulesFailed = new Array();
			if(failedRulesP != null)
			{
				for(var i: int = 0; i<= failedRulesP.length - 1; i++)
				{
					if(failedRulesP[i] is IAccessRule)
					{
						accessRulesFailed.push(failedRulesP[i]);
					}
				}
			}
			
			gotColor = gotColorP;
		}
		
		public function clearFailRules(): void
		{
			accessRulesFailed = new Array();
		}
		
		public function addFailRule(aro:IAccessRule): void
		{
			accessRulesFailed.push(aro);
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