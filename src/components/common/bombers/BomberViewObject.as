package components.common.bombers {

public class BomberViewObject {
    private var type:BomberType;

    public var name:String;
    public var describe:String;

    public var bigImageURL:String;
	public var shopImageURL: String;
	
    public function BomberViewObject(typeP:BomberType, nameP:String, describeP:String, bigImageURLP:String, shopImageURLP: String) {
        type = typeP;

        name = nameP;
        describe = describeP;

        bigImageURL = bigImageURLP;
		shopImageURL = shopImageURLP;
    }


}
}