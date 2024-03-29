package components.common.bombers.colors
{
	import components.common.base.access.rules.levelrule.AccessLevelRule;
	import components.common.resources.ResourcePrice;
	
	import engine.playerColors.PlayerColor;

	public class BomberColorManager
	{
		private var bomberColors: Array;
		
		public function BomberColorManager()
		{
			bomberColors = new Array();
			
			bomberColors.push(
				new BomberColorObject(PlayerColor.BLUE,
					"Синий",
					new ResourcePrice(0,0,0,0),
					[]
				));
			
			bomberColors.push(
				new BomberColorObject(PlayerColor.RED,
					"Красный",
					new ResourcePrice(0,0,0,0),
					[]
				));
			
			bomberColors.push(
				new BomberColorObject(PlayerColor.PINK,
					"Розовый",
					new ResourcePrice(150,0,0,0),
					[]
				));
			
			bomberColors.push(
				new BomberColorObject(PlayerColor.ORANGE,
					"Оранжевый",
					new ResourcePrice(150,0,0,0),
					[]
				));
			
			bomberColors.push(
				new BomberColorObject(PlayerColor.GREEN,
					"Зеленый",
					new ResourcePrice(0,10,0,0),
					[]
				));
			
			bomberColors.push(
				new BomberColorObject(PlayerColor.YELLOW,
					"Желтый",
					new ResourcePrice(0,10,0,0),
					[]
				));
			
		}
		
		public function setColorParameters(pc: PlayerColor, rp:ResourcePrice): void
		{
			for each(var bco:BomberColorObject in bomberColors)
			{
				if(bco.color == pc)
				{
					bco.price = rp.clone();
				}
			}
		}
		
		public function getColors(): Array
		{
			return bomberColors;
		}
	}
}