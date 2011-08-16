package components.common.worlds.locations {
import components.common.base.access.rules.betarule.AccessBetaRule;
import components.common.base.access.rules.itemrule.AccessItemRule;
import components.common.base.access.rules.levelrule.AccessLevelRule;
import components.common.base.access.rules.locationrule.AccessOpenedLocationsRule;
import components.common.items.ItemType;

public class LocationManager 
{
    private var locations:Array = new Array();

    public function LocationManager() {
        locations.push(new LocationObject(
                LocationType.WORLD1_GRASSFIELDS,
                []
                ));

        locations.push(new LocationObject(
                LocationType.WORLD1_CASTLE,[]
//               todo: [new AccessLevelRule(4), new AccessBetaRule()]
                ));


        locations.push(new LocationObject(
                LocationType.WORLD1_SNOWPEAK,
                [new AccessLevelRule(9), new AccessBetaRule()]
                ));

        locations.push(new LocationObject(
                LocationType.WORLD1_MINE,
                [new AccessLevelRule(7), new AccessBetaRule()]
                ));


        locations.push(new LocationObject(
                LocationType.WORLD1_UFO,
                [new AccessLevelRule(13),new AccessOpenedLocationsRule([LocationType.WORLD1_SNOWPEAK], true)]
                ));

        locations.push(new LocationObject(
                LocationType.WORLD1_SEA,
                [new AccessLevelRule(15),new AccessOpenedLocationsRule([LocationType.WORLD1_CASTLE], true), new AccessBetaRule()]
                ));


        locations.push(new LocationObject(
                LocationType.WORLD1_ROCKET,
                [new AccessLevelRule(20),
                    new AccessOpenedLocationsRule([LocationType.WORLD1_SEA, LocationType.WORLD1_UFO], true)]
                ));

        locations.push(new LocationObject(
                LocationType.WORLD1_SATTELITE,
                [new AccessLevelRule(25), new AccessOpenedLocationsRule([LocationType.WORLD1_ROCKET], true)]
                ));


        locations.push(new LocationObject(
                LocationType.WORLD1_MOON,
                [new AccessLevelRule(30),new AccessOpenedLocationsRule([LocationType.WORLD1_SATTELITE], true)]
                ));
    }


    public function getLocations():Array {
        return locations.concat();
    }

    public function getLocation(locationType:LocationType):LocationObject 
	{
        var res:LocationObject = null;

        for each(var loc:LocationObject in locations) {
            if (loc.type == locationType) {
                res = loc;
            }
        }

        return res;
    }
}
}