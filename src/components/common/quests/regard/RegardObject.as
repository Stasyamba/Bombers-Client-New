package components.common.quests.regard
{
	public class RegardObject
	{
		public var type: RegardType;
		public var amount: int;
		public var itemId: int;
		
		public function RegardObject(typeP: RegardType, amountP: int, itemIdP: int = -1)
		{
			type = typeP;
			amount = amountP;
			itemId = itemIdP;
		}
		
		public function clone():RegardObject
		{
			return new RegardObject(type, amount, itemId);
		}
	}
}