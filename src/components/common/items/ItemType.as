package components.common.items {
public class ItemType {
    public static const NUCLEAR_BOMB:ItemType = new ItemType(1, "WEAPON_ITEM_NUCLEAR_BOMB");
    

    public static const BASE_BOMB:ItemType = new ItemType(0, "BASE_BOMB");

    public static const HAMELEON_POISON:ItemType = new ItemType(21, "HAMELEON_POISON");
    
    public static const MINA_BOMB:ItemType = new ItemType(41, "MINA_BOMB");
    public static const BOX_BOMB:ItemType = new ItemType(2, "BOX_BOMB")
    public static const DINAMIT_BOMB:ItemType = new ItemType(3, "DINAMIT_BOMB");
	public static const SMOKE_BOMB:ItemType = new ItemType(4, "SMOKE_BOMB");

	public static const HEALTH_PACK_POISON:ItemType = new ItemType(22, "HEALTH_PACK_POISON");
	public static const HEALTH_PACK_ADVANCED_POISON:ItemType = new ItemType(23, "HEALTH_PACK_ADVANCED_POISON");

	/* parts */
	/* набор - теплая ночь */
	public static const AURA_FIRE:ItemType = new ItemType(100100, "FIRE_AURA");
	//public static const AURA_WARM_NIGHT:ItemType = new ItemType(100100, "AURA_WARM_NIGHT");
	
	public static const PART_BOOTS:ItemType = new ItemType(100101, "PART_BOOTS");
	public static const PART_GLOVES:ItemType = new ItemType(100102, "PART_GLOVES");
	public static const PART_CAP:ItemType = new ItemType(100103, "PART_CAP");
 	public static const PART_MAGIC_SNOW:ItemType = new ItemType(100104, "PART_MAGIC_SNOW");
	
	/* набор - бомба ренген */
	public static const X_RAY_BOMB:ItemType = new ItemType(-1, "X_RAY_BOMB");
	
	public static const PART_BLACK_PAPER:ItemType = new ItemType(104, "PART_BLACK_PAPER");
	public static const PART_ULTRA_RAY:ItemType = new ItemType(105, "PART_ULTRA_RAY");
	public static const PART_GENERATOR:ItemType = new ItemType(106, "PART_GENERATOR");
	
	/* 
		важно чтобы id абстрактных предметов совпадали с id типов того что они представляют
		BomberType, PlayerColor
		
		а здесь нужно дублировать, только для покупки в магазине этих предметов 
		тк в функцию покупки передается ItemType
	*/
	
	/* абстрактные предметы - цвета - нету ни в каких менеджерах, все парсится в другие места при логине */
	
	public static const COLOR_RED:ItemType = new ItemType(1000, "COLOR_RED");
	public static const COLOR_BLUE:ItemType = new ItemType(1001, "COLOR_BLUE");
	public static const COLOR_ORANGE:ItemType = new ItemType(1002, "COLOR_ORANGE");
	public static const COLOR_PINK:ItemType = new ItemType(1003, "COLOR_PINK");
	public static const COLOR_GREEN:ItemType = new ItemType(1004, "COLOR_GREEN");
	public static const COLOR_BLACK:ItemType = new ItemType(1005, "COLOR_BLACK");
	
	/* абстрактные предметы бомбастеры */
	public static const BOMBER_FURYJOE:ItemType = new ItemType(10000, "BOMBER_FURYJOE");
	public static const BOMBER_R2D3:ItemType = new ItemType(10001, "BOMBER_R2D3");
	public static const BOMBER_ZOMBIE:ItemType = new ItemType(10002, "BOMBER_ZOMBIE");
	
	
	
    private var _value:int;
    private var _name:String;

    public function ItemType(value:int, name:String) {
        _value = value;
        _name = name;
    }


    public function get value():int {
        return _value;
    }

    public function get name():String {
        return _name;
    }

    public function toString():String {
        return "value: " + _value.toString() + " name: " + _name.toString();
    }

    public static function byValue(value:int):ItemType {
        switch (value) {
            case NUCLEAR_BOMB.value:
                return NUCLEAR_BOMB
            case AURA_FIRE.value:
                return AURA_FIRE
            case BASE_BOMB.value:
                return BASE_BOMB
            case HAMELEON_POISON.value:
                return HAMELEON_POISON
            case X_RAY_BOMB.value:
                return X_RAY_BOMB
            case MINA_BOMB.value:
                return MINA_BOMB
            case DINAMIT_BOMB.value:
                return DINAMIT_BOMB
            case BOX_BOMB.value:
                return BOX_BOMB
            case SMOKE_BOMB.value:
                return SMOKE_BOMB
            case HEALTH_PACK_POISON.value:
                return HEALTH_PACK_POISON
            case HEALTH_PACK_ADVANCED_POISON.value:
                return HEALTH_PACK_ADVANCED_POISON
			
			case PART_BOOTS.value:
				return PART_BOOTS;
			case PART_CAP.value:
				return PART_CAP;
			case PART_GLOVES.value:
				return PART_GLOVES;
			case PART_MAGIC_SNOW.value:
				return PART_MAGIC_SNOW;
			case AURA_FIRE.value:
				return AURA_FIRE;
			
			case COLOR_BLACK.value:
				return COLOR_BLACK;
			case COLOR_BLUE.value:
				return COLOR_BLUE;
			case COLOR_GREEN.value:
				return COLOR_GREEN;
			case COLOR_ORANGE.value:
				return COLOR_ORANGE;
			case COLOR_PINK.value:
				return COLOR_PINK;
			case COLOR_RED.value:
				return COLOR_RED;
				
			case BOMBER_FURYJOE.value:
				return BOMBER_FURYJOE;
			case BOMBER_R2D3.value:
				return BOMBER_R2D3;
			case BOMBER_ZOMBIE.value:
				return BOMBER_ZOMBIE;
				
			default:
				return null;
        }
        throw new ArgumentError("no ItemType found with value = " + value);
    }
}
}