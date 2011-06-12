package engine.games.quest.goals {
import engine.games.quest.IQuestGame

public class TimeGoal extends GoalBase implements IGoal {

    public static const name:String = "TimeGoal"

    private var _time:int

    public function TimeGoal(text:String,time_seconds:int) {
        super(text)
        _time = time_seconds
    }

    public function check(game:IQuestGame):Boolean {
        return game.timePassed < _time
    }

}
}
