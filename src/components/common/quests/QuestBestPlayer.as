package components.common.quests
{
	import components.common.quests.medals.MedalType;
	
	import engine.profiles.GameProfile;

	public class QuestBestPlayer
	{
		public var questId: String;
		public var gameProfile: GameProfile;
		public var medalType:MedalType;
		public var time:int;
		
		public function QuestBestPlayer(questIdP: String, idPlayer: String, photoURL: String, medalTypeP: MedalType, timeP: int)
		{
			questId = questIdP;	
			
			gameProfile = new GameProfile();
			gameProfile.id = idPlayer;
			gameProfile.photoURL = photoURL;
			
			medalType = medalTypeP;
			time = timeP;
		}
		
		public function clone(): QuestBestPlayer
		{
			return new QuestBestPlayer(questId, gameProfile.id, gameProfile.photoURL, medalType, time);
		}
	}
}