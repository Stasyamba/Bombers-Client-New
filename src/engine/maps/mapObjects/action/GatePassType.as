package engine.maps.mapObjects.action {
import engine.maps.mapObjects.*;

public class GatePassType extends DynObjectType {

    public static const GATE_PASS:GatePassType = new GatePassType(210,"GATE_PASS","Spikes");

    public function GatePassType(value:int, key:String, swfClassName:String = null) {
        super(value, key, swfClassName)
    }
}
}
