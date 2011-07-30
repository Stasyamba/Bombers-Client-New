package components.common.quests
{
	import components.common.base.access.rules.medalrule.AccessMedalRule;
	import components.common.base.server.ImagesPrefixes;
	import components.common.quests.medals.MedalType;
	import components.common.quests.regard.RegardObject;
	import components.common.quests.regard.RegardType;
	import components.common.quests.tasks.TaskObject;
	import components.common.worlds.locations.LocationType;

	public class QuestManager
	{
		private var quests: Array; /* type = [ QuestObject, ... ] */
		private var medalists: Array;
		
		public function QuestManager()
		{
			/* testing, next laod from server */
			
			/* порядок имеет огромное значение,проверяются все квесты ДО определенного */
			
			quests = new Array();
			medalists = new Array();
			
//			quests.push(new QuestObject(QuestType.GRASS_Q1,
//				ImagesPrefixes.QUESTS_PREVIEW_PREFIX+"1.jpg",
//				"Грибная лихорадка",
//				15,
//				[],
//				[
//				new TaskObject(0, "Собрать 15 грибов",
//					[new RegardObject(RegardType.RESOURCE_GOLD, 100)],
//					MedalType.BRONZE_MEDAL),
//				new TaskObject(1, "Собрать 20 грибов",
//					[new RegardObject(RegardType.RESOURCE_GOLD, 300)],
//					MedalType.SILVER_MEDAL),
//				new TaskObject(2, "Собрать 3 фиолетовых",
//					[new RegardObject(RegardType.RESOURCE_ITEM, 1)],
//					MedalType.GOLD_MEDAL),
//				],
//				"Начался грибной сезон, по всей карте спрятаны волшебные грибы, найди их все и сдай в госнаркоконтроль! Немного можешь оставить себе ;)",
//				ImagesPrefixes.QUESTS_ADDITIONAL_PREVIEW_PREFIX+"marshrums.png"
//			));
//
//			quests.push(new QuestObject(QuestType.GRASS_Q2,
//				ImagesPrefixes.QUESTS_PREVIEW_PREFIX+"3.jpg",
//				"Священный грааль",
//				15,
//				[],
//				[]
//			));
//
//			quests.push(new QuestObject(QuestType.GRASS_Q3,
//				ImagesPrefixes.QUESTS_PREVIEW_PREFIX+"2.jpg",
//				"Завали босса",
//				20,
//				[new AccessMedalRule(QuestType.GRASS_Q3, null, 0, true)],
//				[]
//			));
//
//			quests.push(new QuestObject(QuestType.GRASS_Q4,
//				"",
//				"Пасхальное яйцо",
//				20,
//				[new AccessMedalRule(QuestType.GRASS_Q4, MedalType.SILVER_MEDAL, 2)],
//				[]
//			));
			
		}

		public function addMedalist(bpo:QuestBestPlayer): void
		{
			medalists.push(bpo);
		}
		
        //добавляет квесты когда они загрузились
		public function addQuests(_quests:Array):void{
            for (var i:int = 0; i < _quests.length; i++) {
                var qo:QuestObject = _quests[i];
                quests.push(qo)
            }
        }


		/*
		 	return type = [ QuestObject, ... ] 
		*/
		
		public function getQuestObject(id: String): QuestObject
		{
			var res: QuestObject = null;
			
			for each(var qo: QuestObject in quests)	
			{
				if(qo.id == id)
				{
					res = qo;
					break;
				}
			}
			
			return res;
		}
		
		public function getAllQuests(): Array
		{
			return quests;
		}
		
		public function getAllMedalists():Array
		{
			return medalists;
		}
		
		public function getQuests(locationType: LocationType): Array
		{
			var res: Array = new Array();
			
			for each(var qo: QuestObject in quests)
			{
				if(qo.locationId == locationType.value)
				{
					res.push(qo);
				}
			}
			
			return res;
		}
	}
}