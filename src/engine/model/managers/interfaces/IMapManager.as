package engine.model.managers.interfaces {
import engine.maps.IMap

public interface IMapManager {
    function make(xml:XML):IMap;

    function get map():IMap;

    function setDieWall(x:int, y:int):void;

    function get canUseMap():Boolean;
}
}