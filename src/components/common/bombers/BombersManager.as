package components.common.bombers {
	import components.common.base.access.rules.betarule.AccessBetaRule;
	import components.common.base.access.rules.levelrule.AccessLevelRule;
	import components.common.base.server.ImagesPrefixes;

public class BombersManager {
    private var bombers:Array;


    public function BombersManager() {
        bombers = new Array();
		
		bombers.push(new BomberObject(
			BomberType.FURY_JOE,
			[],
			new BomberViewObject(BomberType.FURY_JOE,
				"Мохнатый Джо",
				"Коренной житель\nБомбастерии, истинный\nбоец! Хитер и быстр,\nочень не любит бриться.",
				ImagesPrefixes.BOMBERS_PREFIX + "furyJoe/furyJoeBigImage.png",
				ImagesPrefixes.BOMBERS_PREFIX + "furyJoe/furyJoeShopImage.png")
			));
		
		bombers.push(new BomberObject(
			BomberType.R2D3,
			[],
			new BomberViewObject(BomberType.R2D3,
				"R2D3",
				"Необычный робот упавший онажды с небес теперь он сражается на аренах Бомбастерии",
				ImagesPrefixes.BOMBERS_PREFIX + "r2d3/r2d3BigImage.png",
				ImagesPrefixes.BOMBERS_PREFIX + "r2d3/r2d3ShopImage.png")
		));
		
		bombers.push(new BomberObject(
			BomberType.ZOMBIE,
			[],
			new BomberViewObject(BomberType.ZOMBIE,
				"Зомбастер",
				"Настоящий живой мертвец! Он готов на все, ради аппетитных сочных мозгов своих соперников!",
				ImagesPrefixes.BOMBERS_PREFIX + "zombie/zombieBigImage.png",
				ImagesPrefixes.BOMBERS_PREFIX + "zombie/zombieShopImage.png")
		));
			
    }

    public function getBomber(type:BomberType):BomberObject {
        var res:BomberObject = null;

        for each(var bo:BomberObject in bombers) {
            if (bo.type == type) {
                res = bo;
                break;
            }
        }

        return res;
    }

    public function getBombers():Array {
        return bombers;
    }

/*    public function addBomber(bt:BomberType):void {
        bombers.push(new BomberObject(
                bt,
                bt.accessRules,

                new BomberViewObject(
                        bt,
                        bt.name,
                        bt.description,
                        bt.bigImageURL
                        )
                ));
    }*/

}
}