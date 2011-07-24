package components.common.friendslent
{
	import components.common.profiles.ISocialProfile;
	import components.common.profiles.SocialProfile;
	import components.common.quests.regard.RegardObject;
	
	import engine.profiles.GameProfile;

	public class FriendObject
	{
		public var profile: GameProfile;
		public var sProfile: ISocialProfile;
		
		public var isAskingForHelp: Boolean;
		public var isEnergy:Boolean;
		
		public var hasApp: Boolean;
		
		
		
		public function FriendObject(
										profileP:GameProfile, 
										hasAppP: Boolean, 
										isAskingForHelpP: Boolean = false, 
										isEnegryP: Boolean = false,
										socialProfileP: ISocialProfile = null
		)
		{
			profile = profileP;
			isAskingForHelp = isAskingForHelpP;
			isEnergy = isEnegryP;
			
			hasApp = hasAppP;
			
			sProfile = socialProfileP;
		}
		
		public function clone(): FriendObject
		{
			return new FriendObject(profile, hasApp, isAskingForHelp, isEnergy, sProfile);				
		}
	}
}