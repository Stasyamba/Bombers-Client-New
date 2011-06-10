package components.common.quests.medals
{
	public class MedalObject
	{
		public var questId: String;
		public var medalType: MedalType;
		
		public function MedalObject(qt: String, mt: MedalType)
		{
			questId = qt;
			medalType = mt;
		}
	}
}