package components.common.quests.regard
{
	public class RegardObject
	{
		public var type: RegardType;
		public var amount: int;
		
		public function RegardObject(typeP: RegardType, amountP: int)
		{
			type = typeP;
			amount = amountP;
		}
	}
}