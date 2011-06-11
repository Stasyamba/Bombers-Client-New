package components.common.superoffer
{
	import components.common.quests.regard.RegardObject;

	public class SuperOfferObject
	{
		public var type: SuperOfferType;
		public var difficult: int;
		public var imageURL: String;
		public var describe: String;
		
		public var timeLeft: int;
		public var friendsCountNeeded: int;
		public var reward: Array;
		
		public function SuperOfferObject(
											typeP: SuperOfferType,
											difficultP: int,
											imageURLP: String,
											describeP: String,
											friendsCountNeededP: int,
											rewardP: Array,
											timeLeftP: int = 0)
		{
			type = typeP;
			difficult = difficultP;
			imageURL = imageURLP;
			describe = describeP;
			
			friendsCountNeeded = friendsCountNeededP;
			
			reward = new Array();
			if(rewardP != null)
			{
				for each(var ro: RegardObject in rewardP)
				{
					reward.push(ro);
				}
			}
			
			timeLeft = timeLeftP;
		}
	}
}