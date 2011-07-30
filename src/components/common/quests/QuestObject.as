package components.common.quests
{
	import components.common.base.access.rules.AccessRuleObject;
	import components.common.base.access.rules.IAccessRule;
	import components.common.base.server.ImagesPrefixes;
	import components.common.quests.medals.MedalType;
	import components.common.quests.tasks.TaskObject;
	import components.common.worlds.locations.LocationType;
	import components.pages.game.GamePage;
	
	import engine.profiles.GameProfile;

	public class QuestObject
	{

        public var id:String;

        public var locationId:int;

		public var view: QuestViewObject;
		
		public var energyCost: int;
		public var accessRules: Array;
		
		public var tasks: Array;
		
		public var timeLimit: int;
		
		/* quest best player */
		public var bestPlayer:QuestBestPlayer;
		
		public function setBestPlayer(qbp: QuestBestPlayer):void
		{
			bestPlayer = qbp.clone();
		}
		
		public function QuestObject(idP: String,
                                    locationIdP:int,
									imageURLP: String, 
									nameP: String, 
									energyCostP: int, 
									accessRulesP: Array = null,
									tasksP: Array = null,
									describe: String = "",
									additionalImageURL: String = "",
									timeLimitP: int = 0,
									bestPlayerP:QuestBestPlayer = null
		)
		{
			id = idP;
            locationId = locationIdP;
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
			
			timeLimit = timeLimitP;
			
			if(bestPlayerP != null)
			{
				bestPlayer = bestPlayerP.clone();
			}else
			{
				bestPlayer = null;
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
		
		public function clearMedals(): void
		{
			view.clearMedals();
		}
		
		public function addMedal(medalType: MedalType):void
		{
			view.addMedal(medalType);
		}
		
		public function clearFailRule(): void
		{
			view.clearFailRule();
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