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
				
				
			default:
				return null;
        }
        throw new ArgumentError("no ItemType found with value = " + value);
    }
}
}