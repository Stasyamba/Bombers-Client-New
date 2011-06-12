package components.common.friendslent
{
	import components.common.quests.regard.RegardObject;
	
	import engine.profiles.GameProfile;

	public class FriendObject
	{
		public var profile: GameProfile;
		public var isAskingForHelp: Boolean;
		public var prize: Array;
		
		public function FriendObject(profileP:GameProfile, isAskingForHelpP: Boolean = false, prizeP: Array = null)
		{
			profile = profileP;
			isAskingForHelp = isAskingForHelpP;
			
			prize = new Array();
			if(prizeP != null)
			{
				for each(var ro:RegardObject in prizeP)
				{
					prize.push(ro);	
				}
			}
		}
		
		public function clone(): FriendObject
		{
			return new FriendObject(profile, isAskingForHelp, prize);				
		}
	}
}