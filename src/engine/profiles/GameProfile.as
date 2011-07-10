package engine.profiles {
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.ISFSObject;

import components.common.bombers.BomberType;
import components.common.items.ItemProfileObject;
import components.common.items.ItemType;
import components.common.quests.medals.MedalObject;
import components.common.quests.medals.MedalType;
import components.common.resources.ResourcePrice;
import components.common.worlds.locations.LocationType;

import engine.bombers.skin.BasicSkin;

import mx.controls.Alert;
import mx.utils.ObjectUtil;

public class GameProfile {

    private var _nick:String;
    private var _experience:int;
    public var energy:int;
    public var id:String;
    public var photoURL:String = "";

    public var currentLocation:LocationType;

    private var _selectedWeaponLeftHand:ItemProfileObject;
    private var _selectedWeaponRightHand:ItemProfileObject;

    /**
     * content = [MedalObject, ...]
     */
    public var medals:Array = new Array();
	
	public function addMedal(questId: String, medalsNew: Array): void
	{
		var findMedal: Array = new Array();
		for each(var cmo: MedalType in medalsNew)
		{
			findMedal.push({type: cmo, isFinded: false});
		}
		
		for each(var smo: Object in findMedal)
		{
			for each(var mo: MedalObject in medals)
			{
				if(mo.questId == questId)
				{
					if(mo.medalType == smo.medalType)
					{
						smo.isFinded = true;
					}
				}
			}
		}
		
		for each(smo in findMedal)
		{
			if(!smo.isFinded)
			{
				medals.push(new MedalObject(questId, smo.type));
			}
		}
	}

    /**
     * BomberType
     */
    public var currentBomberType:BomberType;
    public var resources:ResourcePrice;

    /**
     * content = [LocationType, ...]
     */
    public var openedLocations:Array = [LocationType.WORLD1_GRASSFIELDS];
    /**
     * content = [ItemProfileObject, ...]
     */
    public var packItems:Array = new Array();
    /**
     * content = [ItemProfileObject, ...]
     */
    public var gotItems:Array = new Array();
    /**
     * content = [ItemProfileObject, ...]
     */
    public var questItems:Array = new Array();
    /**
     * content = [ItemProfileObject, ...]
     */

    private var _aursTurnedOn:Array = [null,null];

    /*
     * content = [BomberType,...]
     * */
    public var bombersOpened:Array = [];
    //public var vkProfile:VkontakteProfile;


    public function GameProfile() {
    }

    public function get nick():String {
        return _nick;
    }

    public function set nick(value:String):void {
        _nick = value;
    }

    /**
     * content = [ItemType, ItemType]
     */
    public function get aursTurnedOn():Array {
        return _aursTurnedOn;
    }

    /* GET and SET */

    /**
     * ItemProfileObject
     */
    public function get selectedWeaponRightHand():ItemProfileObject {
        return _selectedWeaponRightHand;
    }

    /**
     * ItemProfileObject
     */
    public function get selectedWeaponLeftHand():ItemProfileObject {
        return _selectedWeaponLeftHand;
    }

    public function setWeaponLeftHand(itemType:ItemType, putInPackBack: Boolean = true):void {
        var finded:Boolean = false;
        var tmpArr:Array = new Array();
        var weapon:ItemProfileObject = null;

        if (itemType != null) {
            for each(var ipo:ItemProfileObject in packItems) {
                if (ipo.itemType != itemType) {
                    tmpArr.push(ipo);
                } else {
                    finded = true;
                    weapon = ipo.clone();
                }
            }

            if (finded) {
                packItems = tmpArr.concat();

                if (_selectedWeaponLeftHand != null) {
                    packItems.push(_selectedWeaponLeftHand.clone());
                }

                _selectedWeaponLeftHand = weapon;
            }

        } else {
			if(putInPackBack)
			{
            	packItems.push(_selectedWeaponLeftHand);
			}
			
            _selectedWeaponLeftHand = null;
        }


        Context.Model.dispatchCustomEvent(ContextEvent.GP_CURRENT_LEFT_WEAPON_IS_CHANGED);
        Context.Model.dispatchCustomEvent(ContextEvent.GP_GOTITEMS_IS_CHANGED);
    }


    public function setAura(itemType:ItemType, withEventDispatching:Boolean = false):void {
        /* looking for free place */

        var freePlaceFinded:Boolean = false;
        var putIntoPackItem:ItemType = null;

        for (var i:int = 0; i <= _aursTurnedOn.length - 1; i++) {
            if (_aursTurnedOn[i] == null) {
                _aursTurnedOn[i] = itemType;
                freePlaceFinded = true;
                break;
            }
        }

        if (!freePlaceFinded) {
            putIntoPackItem = _aursTurnedOn[0];
            _aursTurnedOn[0] = itemType;
        }

        /* delete from pack items */

        var tmpArr:Array = new Array();
        var finded:Boolean = false;

        for each(var ipo:ItemProfileObject in packItems) {
            if (ipo.itemType != itemType) {
                tmpArr.push(ipo);
            } else {
                if (finded) {
                    tmpArr.push(ipo);
                }

                finded = true;
            }
        }

        if (finded) {
            packItems = tmpArr.concat();
        }

        /* put into pack items if it need */

        if (putIntoPackItem != null) {
            packItems.push(new ItemProfileObject(putIntoPackItem, -1));
        }

        if (withEventDispatching) {
            Context.Model.dispatchCustomEvent(ContextEvent.GP_GOTITEMS_IS_CHANGED);
            Context.Model.dispatchCustomEvent(ContextEvent.GP_AURS_TURNED_ON_IS_CHANGED);
        }
    }

    public function deleteAura(itemType:ItemType, withEventDispatching:Boolean = false):void {
        var finded:Boolean = false;

        for (var i:int = 0; i <= _aursTurnedOn.length - 1; i++) {
            if (_aursTurnedOn[i] == itemType) {
                _aursTurnedOn[i] = null;
                finded = true;
                break;
            }
        }

        /* put into pack */

        if (finded) {
            packItems.push(new ItemProfileObject(itemType, -1));
        }

        if (withEventDispatching) {
            Context.Model.dispatchCustomEvent(ContextEvent.GP_GOTITEMS_IS_CHANGED);
            Context.Model.dispatchCustomEvent(ContextEvent.GP_AURS_TURNED_ON_IS_CHANGED);
        }
    }

    public function getItemProfileObject(itemType:ItemType):ItemProfileObject {
        var res:ItemProfileObject = null;

        for each(var i:ItemProfileObject in gotItems) {
            if (i.itemType == itemType) {
                res = i.clone();
            }
        }

        return res;
    }

    /* quest items */

	public function useQuestLeftWeapon(): void
	{
		if(_selectedWeaponLeftHand != null)
		{
			if(_selectedWeaponLeftHand.itemCount <= 1)
			{
				Context.Model.dispatchCustomEvent(ContextEvent.QUEST_LEFT_HAND_WEAPON_UPDATE);
			}else
			{
				_selectedWeaponLeftHand.itemCount--;
			}
		}else
		{
			Context.Model.dispatchCustomEvent(ContextEvent.QUEST_LEFT_HAND_WEAPON_UPDATE);
		}
	}
	
	public function setQuestWeapon(itemProfileObject:ItemProfileObject): void
	{
		//Alert.show("Call set weapon");
		//Alert.show(ObjectUtil.toString({weapon: itemProfileObject}));
		
		_selectedWeaponLeftHand = itemProfileObject.clone();
		Context.Model.dispatchCustomEvent(ContextEvent.QUEST_LEFT_HAND_WEAPON_UPDATE);
	}
	
	public function clearQuestWeapon(): void
	{
		_selectedWeaponLeftHand = null;
	}
	
    /* 
	
	public function addQuestItemObject(itemProfileObject:ItemProfileObject):void {
        var isItemFinded:Boolean = false;

        for each(var ipo:ItemProfileObject in questItems) {
            if (itemProfileObject.itemType == ipo.itemType) {
                ipo.itemCount += itemProfileObject.itemCount;
                isItemFinded = true;
                break;
            }
        }

        if (!isItemFinded) {
            questItems.push(ipo);
        }
    }

    public function refreshQuestWeapons():void {
    }
	
	
	

    public function setQuestWeaponToLeftHand(itemType:ItemType):void {
        if (itemType != null) {
            for each(var ipo:ItemProfileObject in questItems) {
                if (ipo.itemType == itemType) {
                    _selectedWeaponLeftHand = ipo;
                    break;
                }
            }

        } else {
            _selectedWeaponLeftHand = null;
        }

    }
	
	*/

    public function getSkin(slot:int):BasicSkin {

        if (slot % 2 != 0) {
            //return Context.imageService.bomberSkin(engine.bombers.BomberType.get(0));
        }

        //return Context.imageService.bomberSkin(engine.bombers.BomberType.get(1))

        return null; // ????
    }

    public static function fromISFSObject(obj:ISFSObject):GameProfile 
	{
        var res:GameProfile = new GameProfile();
        res.id = obj.getUtfString("Id");
        res.nick = obj.getUtfString("Nick");
        res.experience = obj.getInt("Experience");
        res.energy = obj.getInt("Energy");
        res.currentBomberType = BomberType.byValue(obj.getInt("BomberId"));
        //res.selectedWeaponRightHand = new ItemProfileObject(res.currentBomberType.baseBomb, -1);

        var items:ISFSArray = obj.getSFSArray("WeaponsOpen");
		
        for (var i:int = 0; i < items.size(); i++) 
		{
            var objItem:ISFSObject = items.getSFSObject(i);
            var itemId:int = objItem.getInt("WeaponId");
            var itemCount:int = objItem.getInt("Count");
			var itemType: ItemType = ItemType.byValue(itemId);
			
			if(itemType != null)
			{
				if(Context.Model.itemCollectionsManager.getCollection(itemType) != null)
				{
					/* not collection part */
	            	var modelItem:ItemProfileObject = new ItemProfileObject(itemType, itemCount);
					res.packItems.push(modelItem);
		            res.gotItems.push(modelItem);
				}else
				{
					/* if 0 collection part */
					
					if(itemCount != 0)
					{
						var modelItem:ItemProfileObject = new ItemProfileObject(itemType, itemCount);
						res.packItems.push(modelItem);
						res.gotItems.push(modelItem);
					}
				}
			}else
			{
				Alert.show("Error - unknown item type "+itemId.toString()+" | GameProfile.as");
			}
        }

        var a:int = obj.getInt("AuraOne");
		var aType:ItemType;
		
		if (a != 0) 
		{
			aType = ItemType.byValue(a);
			if(aType != null)
			{
            	res.setAura(aType, false);
			}else
			{
				Alert.show("Error - unknown arua type "+a.toString()+" | GameProfile.as");
			}
        }

        a = obj.getInt("AuraTwo");
        if (a != 0) 
		{
			aType = ItemType.byValue(a);
			if(aType != null)
			{
				res.setAura(aType, false);
			}else
			{
				Alert.show("Error - unknown arua type "+a.toString()+" | GameProfile.as");
			}
        }

        res.resources = new ResourcePrice(obj.getInt("Gold"), obj.getInt("Crystal"), obj.getInt("Adamantium"), obj.getInt("Antimatter"))

        items = obj.getSFSArray("LocationsOpen");
        for (i = 0; i < items.size(); i++)
		{
			var locationType:LocationType = LocationType.byValue(items.getInt(i));
			if(locationType != null)	
			{
            	res.openedLocations.push(locationType);
			}else
			{
				Alert.show("Error - unknown location type | GameProfile.as");
			}
        }

        items = obj.getSFSArray("BombersOpen");
        //res.bombersOpened.push(BomberType.get(0))
        //res.bombersOpened.push(BomberType.get(1))

        for (i = 0; i < items.size(); i++) {
			var bType: BomberType = BomberType.byValue(items.getInt(i));
			
			if(bType != null)
			{
            	res.bombersOpened.push(bType);
			}
        }

        return res;
    }

    public function addItem(iType:ItemType, count:int):void {
		
        if (selectedWeaponLeftHand != null && selectedWeaponLeftHand.itemType == iType) {
			selectedWeaponLeftHand.itemCount += count;
            return
        } else {
            for (var i:int = 0; i < gotItems.length; i++) {
                var io:ItemProfileObject = gotItems[i];
                if (io.itemType == iType) {
                    io.itemCount += count;
                    return;
                }
            }
        }
		
        io = new ItemProfileObject(iType, count);
        gotItems.push(io);
        packItems.push(io);
    }

	public function removeItem(iType: ItemType, count: int): void
	{
		if (selectedWeaponLeftHand != null && selectedWeaponLeftHand.itemType == iType) {
			
			//var itemselectedWeaponLeftHand.itemCount -= count
			// remove from hand
			
			return;
		} else {
			
			var fullRemoveItemType: ItemType = null;
			
			for (var i:int = 0; i < gotItems.length; i++) 
			{
				var io:ItemProfileObject = gotItems[i];
				if (io.itemType == iType) 
				{
					var itemCount: int = io.itemCount;
					if(itemCount - count > 0)
					{
						io.itemCount -= count;
						break;
					}else
					{
						fullRemoveItemType = io.itemType;
						break;
					}
				}
			}
			
			if(fullRemoveItemType != null)
			{
				/* remove from got */
				
				var tmpItems: Array = gotItems.concat();
				gotItems = new Array();
				
				for (i = 0; i < tmpItems.length; i++) 
				{
					var ipo:ItemProfileObject = tmpItems[i];
					
					if (ipo.itemType != fullRemoveItemType) {
						gotItems.push(ipo);
					}
				}
				
				/* remove from pack */
				
				var tmpPackItems: Array = packItems.concat();
				packItems = new Array();
				
				for (i = 0; i < tmpPackItems.length; i++) 
				{
					ipo = tmpPackItems[i];
					
					if (ipo.itemType != fullRemoveItemType) {
						packItems.push(ipo);
					}
				}
			}
			
			
		}
	}
	
    /*public function removeItem(itemType:ItemType):void {
        removeItemFromArray(itemType, packItems)
        removeItemFromArray(itemType, gotItems)
        Context.Model.dispatchCustomEvent(ContextEvent.GP_GOTITEMS_IS_CHANGED);
        Context.Model.dispatchCustomEvent(ContextEvent.GP_PACKITEMS_IS_CHANGED);
    }

    private function removeItemFromArray(itemType:ItemType, arr:Array):void {
        for (var i:int = 0; i < arr.length; i++) {
            var obj:ItemProfileObject = arr[i];
            if (obj.itemType == itemType) {
                for (var j:int = i; j < arr.length - 1; j++) {
                    arr[j] = arr[j + 1]
                }
                arr.length--
            }
        }
    }*/

    public function get experience():int {
        return _experience
    }

    public function set experience(value:int):void {
        _experience = value
        Context.Model.dispatchCustomEvent(ContextEvent.GP_EXPERIENCE_CHANGED, value)
    }


    public function get speed():Number {
        return  baseSpeed + speedAuraBonus
    }

    public function get baseSpeed():Number {
        return currentBomberType.getEngineType().speed
    }

    public function get bombCount():int {
        return baseBombCount + bombCountAuraBonus;
    }


    public function get baseBombCount():int {
        return currentBomberType.getEngineType().bombCount
    }

    public function get bombPower():int {
        return baseBombPower + bombPowerAuraBonus
    }

    public function get baseBombPower():int {
        return currentBomberType.getEngineType().bombPower
    }


    public function get startLife():int {
        return currentBomberType.getEngineType().startLife + lifeAuraBonus
    }

    public function get lifeAuraBonus():int {
        return 0
    }

    public function get hasLifeAuraBonus():Boolean {
        return lifeAuraBonus > 0
    }

    public function get speedAuraBonus():Number {
        return 0
    }

    public function get hasSpeedAuraBonus():Boolean {
        return speedAuraBonus > 0
    }

    public function get bombCountAuraBonus():int {
        return 0
    }

    public function get hasBombCountAuraBonus():Boolean {
        return bombCountAuraBonus > 0
    }

    public function get bombPowerAuraBonus():int {
        return 0
    }

    public function get hasBombPowerAuraBonus():Boolean {
        return bombPowerAuraBonus > 0
    }

}
}


