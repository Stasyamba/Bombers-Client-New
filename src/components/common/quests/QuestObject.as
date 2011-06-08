package components.common.quests
{
	import components.common.base.access.rules.AccessRuleObject;
	import components.common.base.access.rules.IAccessRule;
	import components.common.quests.medals.MedalType;
	import components.common.quests.tasks.TaskObject;
	import components.common.worlds.locations.LocationType;

	public class QuestObject
	{
		public var questType: QuestType;
		
		public var view: QuestViewObject;
		
		public var energyCost: int;
		public var accessRules: Array;
		
		public var tasks: Array;
		
		public function QuestObject(questTypeP: QuestType, 
									imageURLP: String, 
									nameP: String, 
									energyCostP: int, 
									accessRulesP: Array = null,
									tasksP: Array = null,
									describe: String = "",
									additionalImageURL: String = ""
		)
		{
			questType = questTypeP;				
			energyCost = energyCostP;
			
			view = new QuestViewObject(imageURLP, nameP, null, null, null, describe, additionalImageURL);
			
			tasks = new Array();
			if(tasksP != null)
			{
				for each(var to:TaskObject  in tasksP)	
				{
					tasks.push(to);
				}
			}
			
			accessRules = new Array();
			if(accessRulesP != null)
			{
				for each(var ar: IAccessRule in accessRulesP)	
				{
					accessRules.push(ar);
				}
			}
		}
		
		public function getTask(mt: MedalType): TaskObject
		{
			var res: TaskObject = null;
			
			if(tasks != null)
			{
				for each(var to:TaskObject in tasks)	
				{
					if(to.medalType == mt)
					{
						res = to;
						break;
					}
				}
			}
			
			return res;
		}
		
		public function setMedal(medalType: MedalType):void
		{
			view.setMedal(medalType);
		}
		
		public function addFailRule(failRule: IAccessRule): void
		{
			view.addFailRule(failRule);
		}
		
		
		public function checkAccess():Array 
		{
			var res:Array = new Array();
			
			for each(var r:IAccessRule in accessRules) 
			{
				res.push(new AccessRuleObject(r, r.checkAccess()));
			}
			
			return res;
		}
	}
}