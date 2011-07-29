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
				new BomberColorObject(PlayerColor.BLACK,
					"Черный",
					new ResourcePrice(0,15,0,0),
					[new AccessLevelRule(7)]
				));
			
		}
		
		public function getColors(): Array
		{
			return bomberColors;
		}
	}
}