package components.common.game.questgameresult
{
	import components.common.quests.QuestObject;
	import components.common.quests.medals.MedalType;

	public class QuestResultObject
	{
		public var isNew: Boolean;
		public var medalType: MedalType;
		public var questObject: QuestObject;
		
		public function QuestResultObject(isNewP: Boolean, medalTypeP: MedalType, questObjectP: QuestObject)
		{
			isNew = isNewP;
			medalType = medalTypeP;
			questObject = questObjectP;
		}
	}
}