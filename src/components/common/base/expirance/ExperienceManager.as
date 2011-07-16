package components.common.base.expirance {
public class ExperienceManager {
    public function ExperienceManager() {
    }

    // type = [ ExperianceObject , ... ]
    public var levelExperiencePair:Array = new Array();

    public function getLevel(experience:int):ExperianceObject {
        for (var i:int = 0; i < levelExperiencePair.length; i++) {
            var eo:ExperianceObject = levelExperiencePair[i];
            if (experience < eo.experiance)
                return getEObyLevel(eo.level - 1)
        }
        return null
    }

    public function getNextLevel(experience:int):ExperianceObject {
        for (var i:int = 0; i < levelExperiencePair.length; i++) {
            var eo:ExperianceObject = levelExperiencePair[i];
            if (experience < eo.experiance)
                return getEObyLevel(eo.level)
        }
        return null
    }

    public function getEObyLevel(level:int):ExperianceObject {
        for each (var eo:ExperianceObject in levelExperiencePair) {
            if (eo.level == level)
                return eo;
        }
        throw Context.Exception("Error in file ExperienceManages.as: no Experience object for level " + level)
    }

}
}