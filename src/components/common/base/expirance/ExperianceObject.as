package components.common.base.expirance
{
	import components.common.quests.regard.RegardObject;

	public class ExperianceObject
	{
		public var level: int;
		public var experiance: int;
		public var rewards: Array;
		
		public function ExperianceObject(levelP: int, experianceP: int, rewardsP: Array = null)
		{
			level = levelP;
			experiance = experianceP;
			
			rewards = new Array();
			
			if(rewardsP != null)
			{
				for each(var ro: RegardObject in rewardsP)
				{
					rewards.push(ro.clone());
				}
			}
		}
	}
}