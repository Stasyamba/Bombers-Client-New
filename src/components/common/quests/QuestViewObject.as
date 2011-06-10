package components.common.quests
{
	import components.common.base.access.rules.AccessRuleObject;
	import components.common.base.access.rules.IAccessRule;
import components.common.base.server.ImagesPrefixes
import components.common.quests.medals.MedalType;
	import components.pages.world.windows.locationenter.RuleView;
	
	import engine.profiles.GameProfile;

	public class QuestViewObject
	{
		public var imageURL: String;
		public var name: String;
		public var accessFailedRules: Array;
		public var bestPlayer: GameProfile;
		public var medalHave: MedalType;
		public var describe: String;
		public var additionalImageURL: String;
		
		public function QuestViewObject(imageURLP: String, 
										nameP: String,
										medalP: MedalType = null,
										bestPlayerP: GameProfile = null,
										accessFailedRulesP: Array = null,
										describeP: String = "",
										imageAdditionalURLP: String = ""
		)
		{
			imageURL = ImagesPrefixes.QUESTS_PREVIEW_PREFIX + imageURLP;
			additionalImageURL = ImagesPrefixes.QUESTS_ADDITIONAL_PREVIEW_PREFIX + imageAdditionalURLP;
			name = nameP;
			
			medalHave = medalP;
			
			bestPlayer = bestPlayerP;
			
			accessFailedRules = new Array();
			if(accessFailedRulesP != null)
			{
				for each(var rule:AccessRuleObject in accessFailedRulesP)
				{
					accessFailedRules.push(rule);
				}
			}
			
			describe = describeP;
		}
		
		public function addFailRule(failedRule: IAccessRule): void
		{
			accessFailedRules.push(failedRule);
		}
		
		public function setMedal(medalType: MedalType): void
		{
			medalHave = medalType;
		}
		
		public function setBestPlayer():void
		{
			
		}
		
	}
}