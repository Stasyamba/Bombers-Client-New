package components.common.game.questgameresult
{
	import components.common.quests.QuestObject;
	import components.common.quests.medals.MedalType;

	public class QuestResultObject
	{
		public var isNew: Boolean;
		public var medals: Array;
		//public var questObject: QuestObject;
		
		public function QuestResultObject(isNewP: Boolean, medalsP: Array) 
		{
			isNew = isNewP;
			medals = new Array();
			
			if(medalsP != null)
			{
				for each(var mt: MedalType in medalsP)
				{
					medals.push(mt);
				}
			}
			
		}
	}
}