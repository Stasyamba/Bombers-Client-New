package components.common.base.access.rules.medalrule
{
	import components.common.base.access.rules.AccessRuleType;
	import components.common.base.access.rules.IAccessRule;
	import components.common.quests.QuestObject;
	import components.common.quests.QuestType;
	import components.common.quests.medals.MedalObject;
	import components.common.quests.medals.MedalType;
	import components.common.worlds.locations.LocationType;
	
	import engine.games.quest.medals.Medal;
	
	import mx.controls.Alert;

	public class AccessMedalRule implements IAccessRule {
		private var type:AccessRuleType;
		
		private var _questType: QuestType;
		private var _medalsType: MedalType;
		private var _medalsCount: int;
		private var _needAnyMedalInEachQuestBefore: Boolean;
		
		public function get needAnyMedalInQuestsBefore():Boolean
		{
			return _needAnyMedalInEachQuestBefore;
		}

		public function get medalsCount():int
		{
			return _medalsCount;
		}

		public function get medalsType():MedalType
		{
			return _medalsType;
		}
		
		
		public function AccessMedalRule(questTypeP:QuestType, medalsTypeP: MedalType, medalCountP: int, needAnyMedalInEachQuestBeforeP: Boolean = false) 
		{
			type = AccessRuleType.MEDAL_RULE;
			
			_questType = questTypeP;
			_medalsType = medalsTypeP;
			_medalsCount = medalCountP;
			
			_needAnyMedalInEachQuestBefore = needAnyMedalInEachQuestBeforeP;	
		}
		
		public function checkAccess():Boolean {
			var res:Boolean = true;
			
			var quests: Array = Context.Model.questManager.getAllQuests();
			
			if(Context.Model.currentSettings.gameProfile.medals.length == 0)
			{
				/* no medals ever */
				Alert.show("No medals!");
			}
			
			if(_needAnyMedalInEachQuestBefore)
			{
				for(var i: int = 0; i<= quests.length - 1; i++)
				{
					if((quests[i] as QuestObject).questType != _questType)
					{
						var findMedal: Boolean = false;
						for each(var mo: MedalObject in Context.Model.currentSettings.gameProfile.medals)
						{
							if((quests[i] as QuestObject).questType == mo.questType)
							{
								findMedal = true;
								break;
							}
						}
						
						if(!findMedal)
						{
							res = false;
						}
						
					}else
					{
						break;
					}
				}
			}else
			{
				var mCount: int = 0;
				
				for(i = 0; i<= quests.length - 1; i++)
				{
					if((quests[i] as QuestObject).questType != _questType)
					{
						for each(mo in Context.Model.currentSettings.gameProfile.medals)
						{
							if((quests[i] as QuestObject).questType == mo.questType)
							{
								if(_medalsType.isLessOrEqual((mo as MedalObject).medalType))
								{
									mCount++;
								}
								
								break;
							}
						}
						
					}else
					{
						break;
					}
				}
				
				if(mCount < _medalsCount)
				{
					res = false;
				}
			}
		
			return res;
		}
		
		public function getAccessRuleType():AccessRuleType {
			return type;
		}
		
	}
}