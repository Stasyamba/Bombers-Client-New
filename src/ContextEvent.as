package {
import flash.events.Event;

public class ContextEvent extends Event {
    public static const USERS_PROFILES_LOADED:String = "UsersProfileLoaded";

    public static const MAIN_TAB_CHANGED:String = "MainTabChanged";
    public static const NEED_TO_CHANGE_MAIN_TAB:String = "NeedToChangeMainTab";
    // pass: String (const) -> tab name (const in ApplicationView)

    public static const SHOW_MAIN_PREALODER:String = "ShowMainPreloder";
    // pass: Boolean -> preloader visible
    public static const NEED_TO_SHOW_ERROR:String = "NeedToShowError";
    public static const NEED_TO_SHOW_DISCONNECTED_WINDOW:String = "NeedToShowDisconnectedWindow"
    public static const NEED_TO_SHOW_CANT_CONNECT_WINDOW:String = "NeedToShowCantConnectWindow"
	public static const NEED_TO_OPEN_TAKE_LOOT_WINDOW: String = "NeedToOpenTakeLootWindow";	
	public static const NEED_TO_OPEN_GAME_CREATING_WINDOW: String = "NeedToOpenGameCreatingWindow";
	
	public static const NEED_TO_OPEN_LOCATION_QUESTS: String = "NeedToOpenLocationQuests";
	public static const NEED_TO_CLOSE_LOCATION_QUESTS: String = "NeedToCloseLocationQuests";
	// pass: LocationType
	public static const NEED_TO_OPEN_TUTORIAL: String = "NeedToOpenTutorial";
	
	
	
    /***** worlds and locations *****/
    public static const NEED_TO_CHANGE_LOCATION:String = "NeedToChangeLocation";


    /***** resource market events *****/
    public static const NEED_TO_OPEN_RESOURCE_MARKET:String = "NeedToOpenMarket";
    // pass: ResourcePrice -> set by default in market
	public static const NEED_TO_CLOSE_RESOURCE_MARKET:String = "NeedToCloseMarket";
	
    public static const RESOURCE_VALUE_CHANGED:String = "ResourceValueChanged";
    // pass: {resourceType: ResourceType, value: int} -> resource that was changed


    /***** game profile profile property change events *****/
    public static const GP_RESOURCE_CHANGED:String = "GPResourceChanged";
    public static const GP_CURRENT_LEFT_WEAPON_IS_CHANGED:String = "GPCurrentLeftWeaponIsChanged";
    public static const GP_GOTITEMS_IS_CHANGED:String = "GPGotItemsIsChanged";
    public static const GP_PACKITEMS_IS_CHANGED:String = "GPPackItemsIsChanged";
    public static const GP_AURS_TURNED_ON_IS_CHANGED:String = "GPAursTurnedOnIsChanged";
    public static const GP_ENERGY_IS_CHANGED:String = "GPEnegryIsChanged";
    public static const GP_EXPERIENCE_CHANGED:String = "GPExperienceChanged";
	// pass: int -> new expirance
    public static const GP_CURRENT_BOMBER_CHANGED:String = "GPCurrentBomberChanged";

	/**** quest window ****/
	public static const QUEST_START_SHOW: String = "QUESTStartShow";
	// pass: QuestType
	public static const QUEST_END_SHOW: String = "QUESTEndShow";
	// pass: QuestResultObject
	

    /***** inventory market events *****/
	
	public static const IM_SHOW: String = "NeedToOpenInventory";
	
	public static const IM_SHOW_COLLECTION:String = "IMShowCollection";
	// pass: ItemColelctionType
	public static const IM_HIDE_COLLECTION:String = "IMHideCollection";
    public static const IM_ITEMBUY_SUCCESS:String = "IMWeaponBoughtSuccess";
	//pass: ItemType
	public static const IM_NEW_ITEM:String = "IMNewItem";
	//pass: Boolean
	
    /***** enegry market events *****/
    public static const NEED_TO_OPEN_ENERGY_MARKET:String = "IMNeedToOpenEnergyMarket";

    /***** game page event *****/
    public static const GPAGE_NEED_TO_SHOW_PREGAME_WINDOW:String = "GPAGENeedToShowPregameWindow";
    public static const GPAGE_NEED_TO_SHOW_GAME_RESULTS_WINDOW:String = "GPAGENeedToShowResultsWindow";
    // pass: GameResults
    public static const GPAGE_NEED_TO_CLOSE_GAME_IS_CREATED_WINDOW:String = "GPAGENeedToCloseGameIsCreatedWindow"
    public static const GPAGE_NEED_TO_CLOSE_GAME_READY_WINDOW:String = "GPAGENeedToCloseGameReadyWindow"

    public static const GPAGE_MY_PARAMETERS_IS_CHANGED:String = "GPAGEMyParametersIsChanged";
    public static const GPAGE_UPDATE_GAME_WEAPONS:String = "GPAGEUpdateGameWeapons";
	public static const GPAGE_NEED_TO_SET_GAME_FOCUS:String = "GPAGENeedToSetGameFocus";
	
	/** result game window events **/
	public static const RGAME_NEED_TO_SET_WEAPON_TO_HAND:String = "RGAMENeedToSetWeaponToHand";
	// pass: ItemType
	
	
	/***** buy events: resources(RS), energy(EN), items(IT) *****/
	
	
	
    public static const RS_BUY_FAILED:String = "RSBuyFailed"
    public static const RS_BUY_SUCCESS:String = "RSBuySuccess"
    //pass: ResourcePrice -> how much bought each resource
    //EN_BUY_FAILED == RS_BUY_FAILED

    public static const EN_BUY_SUCCESS:String = "ENBuySuccess"
    //pass: int -> how much bought energy

    public static const IT_BUY_FAILED:String = "ITBuyFailed"
    public static const IT_BUY_SUCCESS:String = "ITBuySuccess"
    //pass: {it:ItemType, count:int} -> how much bought weapon

    /***** common events *****/
    public static const BOMBER_CHANGED:String = "BomberChanged";
    public static const GAME_PROFILE_LOADED:String = "GameProfileLoaded";

	
	public static const TUTORIAL_NEXT_STEP: String = "TUTORIALNextStep";
	
	/** vk events **/
	public static const VK_SEND_TO_WALL:String = "VKSendToWall";
	// pass: SendWallObject
 	
	/** wall events **/
	public static const WALL_TRY_COUNT_CHANGED: String = "WALLTryCountChanged";
	public static const WALL_FAST_LOGINED: String = "WALLFastLogined";
	// pass: boolean -> lottery type (const in WallChest.mxml)
	
    public var data:*;


    public function ContextEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:* = null) {
        super(type, bubbles, cancelable);
        this.data = data;
    }

    public override function toString():String {
        return formatToString("ContextEvent", "type", "bubbles", "cancelable", "eventPhase", "data");
    }

    public override function clone():Event {
        return new ContextEvent(type, bubbles, cancelable, data);
    }

}
}