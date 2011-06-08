package components.common.quests.medals
{
	import components.common.quests.QuestType;

	public class MedalObject
	{
		public var questType: QuestType;
		public var medalType: MedalType;
		
		public function MedalObject(qt: QuestType, mt: MedalType)
		{
			questType = qt;
			medalType = mt;
		}
	}
}