package components.pages.global.inventorynew.market
{
	import components.common.items.ItemType;
	import components.common.items.ItemViewObject;
	import components.common.items.categories.ItemCategory;

	public class ItemMarket
	{
		public var imageURL: String;
		public var itemCategory: ItemCategory;
		public var type: *;
		
		public function ItemMarket(typeP: *, imageURLP: String, itemCategoryP: ItemCategory)
		{
			type = typeP;
			imageURL = imageURLP;
			itemCategory = itemCategoryP;
		}
	}
}