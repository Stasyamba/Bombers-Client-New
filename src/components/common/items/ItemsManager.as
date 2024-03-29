package components.common.items {
import components.common.base.access.rules.levelrule.AccessLevelRule;
import components.common.base.server.ImagesPrefixes;

public class ItemsManager {
    private var items:Array;

    public function ItemsManager() {
        items = new Array();

        items.push(new ItemObject(
                ItemType.BASE_BOMB,
                [],

                new ItemViewObject(
                        ItemType.BASE_BOMB,
                        ImagesPrefixes.WEAPON_PREFIX + "baseBomb.png",
                        "Базовая бомба",
                        "",
                        ""
                        )
                ));

        /*** AURS ***/

        items.push(new ItemObject(
                ItemType.AURA_FIRE,
                [],

                new ItemViewObject(
                        ItemType.AURA_FIRE,
                        ImagesPrefixes.AURS_PREFIX + "fireAura.png",
                        "Аура огня",
                        "Аура позволяет, не теряя здоровья, проходить по огненным элементам карты.",
                        ImagesPrefixes.AURS_PREFIX + "fireAuraAnotherImage.png"
                        )
                ));

        /*** BOMBS AND POISONS ***/

		items.push(new ItemObject(
			ItemType.SMOKE_BOMB,
			[],
			
			new ItemViewObject(
				ItemType.SMOKE_BOMB,
				ImagesPrefixes.WEAPON_PREFIX + "smokeBomb.png",
				"Дымовая бомба",
				"Задыми всю карту, передвигайся как тень и верши свое правосудие в суде неравных"
			)
		));
		
		items.push(new ItemObject(
			ItemType.HAMELEON_POISON,
			[],
			
			new ItemViewObject(
				ItemType.HAMELEON_POISON,
				ImagesPrefixes.WEAPON_PREFIX + "hamelionPoison.png",
				"Зелье хамелеона",
				"На 2 минуты ваш бомбастер сольется с картой и станет практически незаметным для врагов!"
			)
		));
		
		items.push(new ItemObject(
			ItemType.HEALTH_PACK_POISON,
			[],
			
			new ItemViewObject(
				ItemType.HEALTH_PACK_POISON,
				ImagesPrefixes.WEAPON_PREFIX + "healthPackPoison.png",
				"Зелье здоровья",
				"Восстанавливает 5 едениц здоровья в бою, когда в важном бою силы на исходе, используй его!"
			)
		));
		
		items.push(new ItemObject(
			ItemType.MINA_BOMB,
			[],
			
			new ItemViewObject(
				ItemType.MINA_BOMB,
				ImagesPrefixes.WEAPON_PREFIX + "minaBomb.png",
				"Мина",
				"Взрывается при касании нанося 15 урона. Для вас хорошо видима, для врагов почти незаметная. Блокируй ходы соперника и побеждай."
			)
		));

		items.push(new ItemObject(
			ItemType.DINAMIT_BOMB,
			[],
			
			new ItemViewObject(
				ItemType.DINAMIT_BOMB,
				ImagesPrefixes.WEAPON_PREFIX + "dinamitBomb.png",
				"Динамит",
				"Мощнейшая бомба, взрывает несколько видов больших объектов. Наносит 15 урона."
			)
		));
		
		items.push(new ItemObject(
			ItemType.HEALTH_PACK_ADVANCED_POISON,
			[],
			
			new ItemViewObject(
				ItemType.HEALTH_PACK_ADVANCED_POISON,
				ImagesPrefixes.WEAPON_PREFIX + "healthPackAdvancedPoison.png",
				"Зелье здоровья (увеличенное)",
				"Редчайшая выжимка из ночного опоссума, восстанавливает 10 едениц здоровья."
			)
		));
		
		items.push(new ItemObject(
			ItemType.NUCLEAR_BOMB,
			[],
			
			new ItemViewObject(
				ItemType.NUCLEAR_BOMB,
				ImagesPrefixes.WEAPON_PREFIX + "nuclearBomb.png",
				"Ядерная бомба",
				"Мощнейшая бомба, которая способна сокрушить на карте буквально все. Взрывная волна держится дольше обычного."
			)
		));
		
		
		
		

        


       /* items.push(new ItemObject(
                ItemType.X_RAY_BOMB,
                [],

                new ItemViewObject(
                        ItemType.X_RAY_BOMB,
                        ImagesPrefixes.WEAPON_PREFIX + "xrayBomb.png",
                        "Бомба рентген",
                        "Уничтожает только коробки, в которымх могут находиться бонусы, не трогая при этом бомбастеров"
                        )
                ));*/

        
       /* items.push(new ItemObject(
                ItemType.BOX_BOMB,
                [],

                new ItemViewObject(
                        ItemType.BOX_BOMB,
                        ImagesPrefixes.WEAPON_PREFIX + "boxBomb.png",
                        "Разбрасыватель",
                        "Когда вы спасаетесь от врагов, нет ничего лучше чем заградить их путь стенами! Почувствуй себя архитектором карты, мечи коробки!"
                        )
                ));*/


       
		
		/* Parts */
		
		/* Набор - теплая ночь */
		
		items.push(new ItemObject(
			ItemType.PART_MAGIC_SNOW,
			[],
			
			new ItemViewObject(
				ItemType.PART_MAGIC_SNOW,
				ImagesPrefixes.PARTS_PREFIX + "partMagicSnow.png",
				"Магическая снежинка",
				"Магическая снежинка"
			)
		));
		
		items.push(new ItemObject(
			ItemType.PART_BOOTS,
			[],
			
			new ItemViewObject(
				ItemType.PART_BOOTS,
				ImagesPrefixes.PARTS_PREFIX + "partBoots.png",
				"Шерстяные ботинки из вьючного мулла",
				"Шерстяные ботинки из вьючного мулла"
			)
		));
		
		items.push(new ItemObject(
			ItemType.PART_GLOVES,
			[],
			
			new ItemViewObject(
				ItemType.PART_GLOVES,
				ImagesPrefixes.PARTS_PREFIX + "partGloves.png",
				"Теплые врежки из сибирского верблюда",
				"Теплые врежки из сибирского верблюда"
			)
		));
		
		
		items.push(new ItemObject(
			ItemType.PART_CAP,
			[],
			
			new ItemViewObject(
				ItemType.PART_CAP,
				ImagesPrefixes.PARTS_PREFIX + "partCap.png",
				"Шапка из шерсти молодого Чубаки",
				"Шапка из шерсти молодого Чубаки"
			)
		));

		

    }

    public function getItem(itemType:ItemType):ItemObject {
        var res:ItemObject = null
        for each(var io:ItemObject in items) {
            if (io.type == itemType) {
                res = io;
                break;
            }
        }

        return res;
    }

    public function getItems():Array {
        return items;
    }
}
}