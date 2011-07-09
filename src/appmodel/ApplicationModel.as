package appmodel {
import api.vkontakte.constant.UserProfileField;
import api.vkontakte.model.VkontakteApplicationModel;

import components.common.base.expirance.ExperienceManager;
import components.common.base.market.MarketManager;
import components.common.base.window.WindowsManager;
import components.common.bombers.BombersManager;
import components.common.items.ItemsManager;
import components.common.items.categories.ItemsCategoriesManager;
import components.common.items.collections.ItemCollectionManager;
import components.common.quests.QuestManager;
import components.common.resources.ResourceViewManager;
import components.common.tutorial.TutorialPartType;
import components.common.worlds.locations.LocationManager;
import components.common.worlds.locations.LocationViewManager;

import flash.events.EventDispatcher;

import org.vyana.control.VyanaEvent;

public class ApplicationModel extends VkontakteApplicationModel {


	public var applicationId: String = "";
	public var applicationSecret: String = "";
	public var applicationLink: String = "";
	public var applicationAuthorId: String = "72969483";
	
    function ApplicationModel() {
        super(applicationId, applicationSecret, applicationAuthorId);
    }

	/* Vkontakte API */

	public function wallSavePhotoID(wallIdP: String, photoIdP: String, postIdP: String, messageP: String):void
	{		
		new VyanaEvent(APIVkontakte.SAVE_WALL_POST,
			{
				wall_id: wallIdP,
				photo_id: photoIdP,
				post_id: postIdP,
				message: messageP
			}).dispatch(
				function (result:*): void {
					for each (var o:* in result.response){
						//mx.controls.Alert.show("responce:"+ObjectUtil.toString(result.response));
					}
				});
	}

    public function pushIntoArray(val:*, arr:Array, compareProperty:String = ""):Array {
        var newArray:Array = arr;
        var elementFinded:Boolean = false;

        for each(var o:* in arr) {
            if (compareProperty != "") {
                // it's mean that o is Simple

                if (o.hasOwnProperty(compareProperty)) {
                    if (val[compareProperty] == o[compareProperty]) {
                        elementFinded = true;
                    }
                }
            } else {
                if (val == o) {
                    elementFinded = true;
                }
            }
        }

        if (!elementFinded) {
            newArray.push(val);
        }

        return newArray;
    }

	
	public var isDevelopment: Boolean = true;
	
    [Bindable]
    public var currentSettings:Settings = new Settings();

    [Bindable]
    public var trustContent:Boolean = true;

    public var resourceViewManager:ResourceViewManager = new ResourceViewManager();
    public var locationViewManager:LocationViewManager = new LocationViewManager();
    public var locationManager:LocationManager = new LocationManager();
    public var windowsManager:WindowsManager = new WindowsManager();
    public var experianceManager:ExperienceManager = new ExperienceManager();
    public var itemsManager:ItemsManager = new ItemsManager();
    public var itemsCategoryManager:ItemsCategoriesManager = new ItemsCategoriesManager();
	public var itemCollectionsManager: ItemCollectionManager = new ItemCollectionManager();   
    public var bomberManager:BombersManager = new BombersManager();
    public var marketManager:MarketManager = new MarketManager();
	public var questManager: QuestManager = new QuestManager();
	
	/* tutorial */
	public var currentTutorialPart: TutorialPartType = TutorialPartType.DONE;
	
	/* quests */
	public var questIdLastOpened: String = null;
	public var questToken: int;
	
	
    public var disp:EventDispatcher;

    public function hasCustomListener(event:String):Boolean {
        if (disp == null) return false;
        return disp.hasEventListener(event);
    }

    public function addCustomListener(event:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
        if (disp == null) disp = new EventDispatcher();
        disp.addEventListener(event, listener, useCapture, priority, useWeakReference);
    }

    public function dispatchCustomEvent(event:String, data:* = null):void {
        if (disp == null) return;
        disp.dispatchEvent(new ContextEvent(event, false, false, data));
    }

    public function removeCustomEventListener(event:String, func:Function):void {
        if (disp != null && disp.hasEventListener(event)) {
            disp.removeEventListener(event, func);
        }
    }
}
}