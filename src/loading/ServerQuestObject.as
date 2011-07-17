package loading {
public class ServerQuestObject {

    private var _id:String
    private var _energyCost:int;
    private var _rewards:Array;


    public function ServerQuestObject(id:String, energyCost:int, rewards:Array) {
        _id = id
        _energyCost = energyCost
        _rewards = rewards
    }

    public function get id():String {
        return _id
    }

    public function get energyCost():int {
        return _energyCost
    }

    public function get rewards():Array {
        return _rewards
    }
}
}
