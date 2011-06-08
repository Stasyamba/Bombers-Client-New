package components.common.worlds.locations {
import components.common.utils.adjustcolor.Color
import components.common.utils.adjustcolor.ColorMatrixObject

public class LocationViewManager {

   	private var locations:Array = new Array();

    public function LocationViewManager() {
        locations.push(new LocationViewObject(
                LocationType.WORLD1_GRASSFIELDS,
                "Минные поля",
                "Опасное место для начинающего бомбастера. На этих полях пройдут ваши первые сражения, в которых вы докажете всем свое превосходство."
				)
                );

        locations.push(new LocationViewObject(
                LocationType.WORLD1_MINE,
                "Шахты",
                "Если у вас клаустрофобия, не стоит даже близко подходить! Темные шахты полны отчаяных бойцов-психопатов!"
                )
                );

        locations.push(new LocationViewObject(
                LocationType.WORLD1_CASTLE,
                "Подземелья замка",
                "Каждый день в подземельях этого замка проходят ожесточенные бои. Здесь сотни воинов выяснют, кто из них достоин звания короля!"
                )
                );

        locations.push(new LocationViewObject(
                LocationType.WORLD1_SNOWPEAK,
                "Горный хребет",
                "Сражения здесь проходят даже в неистовые снежные бури, только очень суровые бомбастеры вступают на эту землю!"
                )
                );

        locations.push(new LocationViewObject(
                LocationType.WORLD1_SATTELITE,
                "Затерянный спутник",
                "Спутник, который ушел с орбиты 20 лет назад, снова здесь. На его борту вас ждет шокирующая правда о бесконечном космосе и его обитателях."
                )
                );

        locations.push(new LocationViewObject(
                LocationType.WORLD1_SEA,
                "Нейтральные воды",
                "В морских глубинах никто не услышит ваших криков, здесь каждый вершит свои законы."
                )
                );

        locations.push(new LocationViewObject(
                LocationType.WORLD1_ROCKET,
                "Космодром",
                "Место отправки опытных бомбастеров в космические глубины. В преддверии взлета можно сразиться с достойными сопрениками!"
				)
                );

        locations.push(new LocationViewObject(
                LocationType.WORLD1_MOON,
                "Луна",
                "Мало кому посчастливилось тут побывать. Самые опытные бойцы заступят на эту арену с великой гордостью."
				)
                );

        locations.push(new LocationViewObject(
                LocationType.WORLD1_UFO,
                "Крушение НЛО",
                "Информация о данном месте стого засекречена, просим вас забыть о существовании этой локации."
				)
                );

    }

    public function getLocationViewObject(locationType:LocationType):LocationViewObject {
        var res:LocationViewObject = null;

        for each(var lvo:LocationViewObject in locations) {
            if (lvo.locationType == locationType) {
                res = lvo;
                break;
            }
        }

        return res;
    }
}
}