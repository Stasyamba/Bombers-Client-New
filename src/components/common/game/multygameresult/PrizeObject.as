package components.common.game.multygameresult
{
	import components.common.resources.ResourceType;

	public class PrizeObject
	{
		public var prizeType: PrizeType;
		public var resourceType: ResourceType;
		public var amount: int;			
		public var placeType: PlaceType;
		public var collectionPartId: int;
		
		
		public function PrizeObject(prizeTypeP: PrizeType, 
									resourceTypeP: ResourceType,
									amountP: int = 0, 
									placeTypeP: PlaceType = null, 
									collectionPartIdP: int = 0
		)
		{
			prizeType = prizeTypeP;
			resourceType = resourceTypeP;
			amount = amountP;
			placeType = placeTypeP;
			collectionPartId = collectionPartIdP;
		}
	}
}