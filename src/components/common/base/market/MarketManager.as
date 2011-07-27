package components.common.base.market {
import components.common.bombers.BomberType;
import components.common.items.ItemType;
import components.common.resources.ResourcePrice;

public class MarketManager {

    private var _itemPrices:Array = new Array()
	private var _bomberPrices:Array = new Array();
		
    public function MarketManager() {
    }

    //array of ItemMarketObject
    public function setItemPrices(prices:Array):void {
        _itemPrices = prices
    }
	
	public function setBomberPrices(prices:Array):void {
		_bomberPrices = prices;
	}


    public function getItemPrice(itemType:ItemType):ItemMarketObject {
        if (_itemPrices[itemType.value] != null)
            return  _itemPrices[itemType.value]
        return new ItemMarketObject(new ResourcePrice(1,0,0,0),1,false)
    }
	
	public function getBomberPrice(bomberType:BomberType):ItemMarketObject 
	{
		if (_bomberPrices[bomberType.value] != null)
		{
			return _bomberPrices[bomberType.value];
		}
		
		return new ItemMarketObject(new ResourcePrice(0,0,0,0),1,false);
	}
}
}