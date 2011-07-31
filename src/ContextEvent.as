package {
import flash.events.Event;

public class ContextEvent extends Event {

	public static const WORLD_LOCATIONS_FILL_COLORS:String = "WORLDLocationsFillColors";
	public static const WORLD_ANIMATION_VISIBLE:String = "WORLDAnimationVisible";
	// pass: Boolean - > snow visible
	
	public static const VK_SHOW_VOTE_CONTROL: String = "GLOBALShowVoteControl";
	public static const GLOBAL_INVENTORY_BUTTON_ENABLED: String = "GLOBALBlockInventoryButton";
	
	public static const NEW_LEVEL_SHOW: String = "NEWLEVELShow";
	//public static const NEW_LEVEL_2_SHOW: String = "NEWLEVEL2Show";
	
	public static const NEED_TO_SHOW_WORLD_ANIMATION: String = "NeedToShowWorldAnimation";
	// pass: Boolean
	
	public static const MODAL_SET_STYLE_DEFAULT:String= "MODALSetStyleDefault";
	
    public static const MAIN_TAB_CHANGED:String = "MainTabChanged";
    public static const NEED_TO_CHANGE_MAIN_TAB:String = "NeedToChangeMainTab";
    // pass: String (const) -> tab name (const in ApplicationView)

    public static const NEED_TO_SHOW_MAIN_PREALODER:String = "ShowMainPreloder";
    // pass: Boolean -> preloader visible
	
    public static const NEED_TO_SHOW_DISCONNECTED_WINDOW:String = "NeedToShowDisconnectedWindow"
    public static const NEED_TO_SHOW_CANT_CONNECT_WINDOW:String = "NeedToShowCantConnectWindow"
	public static const NEED_TO_OPEN_GAME_CREATING_WINDOW: String = "NeedToOpenGameCreatingWindow";
	
	public static const NEED_TO_OPEN_LOCATION_QUESTS: String = "NeedToOpenLocationQuests";
	public static const NEED_TO_CLOSE_LOCATION_QUESTS: String = "NeedToCloseLocationQuests";
	// pass: LocationType
	
	public static const NEED_TO_SHOW_DAY_BONUS:String = "NeedToShowDayBonus";
	// pass: int -> currentDay
	
	public static const NEED_TO_SHOW_FRIENDS_HELP: String = "NeedToShowFriendsHelp";
	
	/**** super offer event ****/
	public static const SUPER_OFFER_OPEN: String = "SuperOfferOpen";
	// pass: 
	
    /***** worlds and locations *****/
    public static const NEED_TO_CHANGE_LOCATION:String = "NeedToChangeLocation";


    /***** resource market events *****/
    public static const NEED_TO_OPEN_RESOURCE_MARKET:String = "NeedToOpenMarket";
    // pass: ResourcePrice -> set by default in market
	public static const NEED_TO_CLOSE_RESOURCE_MARKET:String = "NeedToCloseMarket";
	
    public static const RESOURCE_VALUE_CHANGED:String = "ResourceValueChanged";
    // pass: {resourceType: ResourceType, value: int} -> resource that was changed
	public static const RESOURCE_MARKET_SHOW:String = "ResourceMarketShow";
	public static const RESOURCE_TOP_PANEL_VISIBLE:String = "ResourceTopPanelVisible";
	// pass: Boolean -> visible

	
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
	
	public static const GP_PREGAME_CLOSE:String = "GPPregameClose";
	public static const GP_COLOR_CHANGED:String = "GPColorChanged";
	
	public static const GP_OPEN_BOBMERS_REFRESH: String = "GPOpenBombersRefresh";
	
	public static const COLOR_SET_REFRESH: String = "COLORSetRefresh";
	public static const COLOR_PANEL_SHOW: String = "COLORPANELShow";
	// pass: Boolean
	
	
	/**** quest window ****/
	public static const QUEST_START_SHOW: String = "QUESTStartShow";
	// pass: QuestType
	public static const QUEST_START_CLOSE: String = "QUESTStartClose";
	public static const QUEST_END_SHOW: String = "QUESTEndShow";
	// pass: QuestResultObject
	public static const QUEST_SET_GAME_FOCUS: String = "QUESTSetGameFocus";
	// pass: Boolean -> game focus visible
	public static const QUEST_MEDAL_REFRESH: String = "QUESTMedalRefresh";
	
	public static const QUEST_LEFT_HAND_WEAPON_UPDATE: String = "QUESTWeaponChanged";
	
	public static const QUEST_TIME_STOP: String = "QUESTStopTime";
	public static const QUEST_TIME_START: String = "QUESTStartTime";
	public static const QUEST_TIME_SET: String = "QUESTSetTime";
	// pass: int -> quest time
	
    /***** inventory market events *****/
	
	public static const IM_SHOW: String = "NeedToOpenInventory";
	
	public static const IM_SHOW_COLLECTION:String = "IMShowCollection";
	// pass: ItemColelctionType
	public static const IM_HIDE_COLLECTION:String = "IMHideCollection";
    public static const IM_ITEMBUY_SUCCESS:String = "IMWeaponBoughtSuccess";
	public static const IM_ITEMBUY_FAIL:String = "IMWeaponBoughtFail";
	//pass: ItemType
	public static const IM_NEW_ITEM:String = "IMNewItem";
	//pass: Boolean
	public static const IM_CLOSE:String = "IMClose";
	public static const IM_NEED_RESOURCES:String = "IMNeedResources";
	public static const IM_NEED_RESOURCES_CLOSE:String = "IMNeedResourcesClose";
	public static const IM_HITS_LOADED:String = "IMHitsLoaded";
	// pass: Array -> [itemType, itemType, ...] hits now
	
    /***** enegry market events *****/
    public static const NEED_TO_OPEN_ENERGY_MARKET:String = "IMNeedToOpenEnergyMarket";

    /***** game page event *****/
    public static const GPAGE_NEED_TO_SHOW_PREGAME_WINDOW:String = "GPAGENeedToShowPregameWindow";
    public static const GPAGE_NEED_TO_SHOW_GAME_RESULTS_WINDOW:String = "GPAGENeedToShowResultsWindow";
    // pass: GameResults

    public static const GPAGE_MY_PARAMETERS_IS_CHANGED:String = "GPAGEMyParametersIsChanged";
    public static const GPAGE_UPDATE_GAME_WEAPONS:String = "GPAGEUpdateGameWeapons";
	public static const GPAGE_SET_GAME_FOCUS:String = "GPAGENeedToSetGameFocus";
	
	/** result game window events **/
	
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
    public static const GP_BOMBER_CHANGED:String = "BomberChanged";
    public static const GAME_PROFILE_LOADED:String = "GameProfileLoaded";

	/**** tutorial events ****/
	public static const TUTORIAL_NEXT_STEP: String = "TUTORIALNextStep";
	public static const TUTORIAL_OPEN_PART1: String = "TUTORIALPart1Tutorial";
	public static const TUTORIAL_OPEN_PART2: String = "TUTORIALPart2Tutorial";
	public static const TUTORIAL_OPEN_PART3: String = "TUTORIALPart3Tutorial";
	public static const TUTORIAL_OPEN_PART5: String = "TUTORIALPart5Tutorial";
	public static const TUTORIAL_CLOSE_TUTORIAL_LOCATION_WINDOW: String = "TUTORIALCloseTutorialLocation";
	public static const TUTORIAL_INVENTORY_TUTORIAL2: String = "TUTORIALInventoryTutorial2";
	public static const TUTORIAL_INVENTORY_TUTORIAL3: String = "TUTORIALInventoryTutorial3";
	public static const TUTORIAL_INVENTORY_TUTORIAL4: String = "TUTORIALInventoryTutorial4";
	public static const TUTORIAL_SHOW_PLAY_BUTTON: String = "TUTORIALShowPlayButton";
	
	/** vk events **/
	public static const VK_SEND_TO_WALL:String = "VKSendToWall";
	// pass: SendWallObject
 	
	
	public static const FRIENDS_PANEL_GET_BONUS: String = "FRIENDSPANELGetBonus";
	public static const FRIENDS_PANEL_FRIENDS_IS_LOADED: String = "FRIENDSPANELFriendsIsLoaded";
	public static const FRIENDS_PANEL_HIDE_ENEGRY: String = "FRIENDSPANELHideEnergy";

	public static const DEVELOP_DEBUG_STRING_SHOW: String = "DEVELOPDebugString";
	// pass: String;
	
	
	public static const MUSIC_SWITCH: String = "MUSICSwitch";
	// pass: Boolean
	
	public static const INVITE_FRIEND_SHOW: String = "INVITEFriendShow";
	// pass: FriendObject
	public static const INVITE_ALL_FRIENDS_SHOW: String = "INVITEAllFriendsShow";
	
	
	
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