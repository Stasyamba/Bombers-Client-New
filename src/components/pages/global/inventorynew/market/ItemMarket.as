package components.pages.global.inventorynew.market
{
	import components.common.items.ItemType;
	import components.common.items.ItemViewObject;
	import components.common.items.categories.ItemCategory;
	import components.common.resources.ResourcePrice;

	public class ItemMarket
	{
		public var imageURL: String;
		public var itemCategory: ItemCategory;
		public var type: *;
		public var itemLevelNessesory:int;
		public var itemPrice: ResourcePrice;
		
		public function ItemMarket(typeP: *, imageURLP: String, itemCategoryP: ItemCategory, itemLevelNessesoryP:int, itemPriceP:ResourcePrice)
		{
			type = typeP;
			imageURL = imageURLP;
			itemCategory = itemCategoryP;
			
			itemLevelNessesory = itemLevelNessesoryP;
			
			itemPrice = new ResourcePrice(0,0,0,0);
			itemPrice.cloneFrom(itemPriceP);
			
		}
	}
}