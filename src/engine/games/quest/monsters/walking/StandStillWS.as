package engine.games.quest.monsters.walking {
import engine.bombers.interfaces.IMapCoords
import engine.utils.Direction

public class StandStillWS implements IWalkingStrategy{
    public function StandStillWS()  {
    }

    public function getDirection(dir:Direction, _coords:IMapCoords):Direction {
        return Direction.NONE
    }
}
}
