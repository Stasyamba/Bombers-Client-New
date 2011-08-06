package engine.maps.mapBlocks.view {
import engine.maps.interfaces.IMapBlock
import engine.maps.mapObjects.action.GatePass

import flash.display.Sprite
import flash.events.Event

public class GatePassView extends DynObjectView {

    private var _obj:GatePass

    public function GatePassView(block:IMapBlock, baseView:Sprite) {
        super(block, baseView)
        _obj = GatePass(block.object);
        draw();

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        _obj.stateChanged.add(onStateChanged)
    }

    private function onAddedToStage(event:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        (_self as Object).setActivate(_obj.state);
        (_self as Object).setDirection(_obj.isVert);
    }

    private function onStateChanged(state:Boolean):void {
        (_self as Object).setActivate(state);
    }


    override public function destroy():void {
        super.destroy()
        _obj.stateChanged.remove(onStateChanged)
    }
}
}
