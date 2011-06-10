package components.common.base.access {
import components.common.items.ItemObject;
import components.common.items.ItemType;
import components.common.quests.QuestObject;
import components.common.worlds.locations.LocationObject;
import components.common.worlds.locations.LocationType;

public class AccessManager {
    public function AccessManager() {
    }

    /**
     * return Array of AccessRuleObject
     * @param location
     * @return
     *
     */
    public static function checkAccessLocation(location:LocationType):Array {
        var res:Array = new Array();

        for each(var l:LocationObject in Context.Model.locationManager.getLocations()) {
            if (l.type == location) {
                res = l.checkAccess();
                break;
            }

        }

        return res;
    }

    /**
     * return Array of AccessRuleObject
     * @param item
     * @return
     *
     */
    public static function checkAccessItem(item:ItemType):Array {
        var res:Array = new Array();

        for each(var i:ItemObject in Context.Model.itemsManager.getItems()) {
            if (i.type == item) {
                res = i.checkAccess();
                break;
            }

        }

        return res;
    }
	
	
	public static function checkAccessQuest(questId: String): Array
	{
		var res:Array = new Array();
		
		for each(var i:QuestObject in Context.Model.questManager.getAllQuests())
		{
			if(i.id == questId)
			{
				res = i.checkAccess();
				break;
			}
		}
		
		return res;
	}
	
}
}