package components.common.quests.tasks
{
	import components.common.quests.medals.MedalType;
	import components.common.quests.regard.RegardObject;

	public class TaskObject
	{
		public var id: int;
		public var describe: String;
		public var regards: Array;
		public var medalType: MedalType;
		
		public function TaskObject(idP: int, describeP: String, regardsP: Array, medalTypeP: MedalType)
		{
			id = idP;
			describe = describeP;
			
			regards = new Array();
			if(regardsP != null)
			{
				for each(var ro: RegardObject in regardsP)
				{
					regards.push(ro);
				}
			}
			
			medalType = medalTypeP;
		}
	}
}