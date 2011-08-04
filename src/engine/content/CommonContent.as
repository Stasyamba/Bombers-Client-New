package engine.content {
import flash.display.Bitmap;
import flash.system.ApplicationDomain;
import flash.utils.getDefinitionByName;

public class CommonContent {

    public static const BOMBERS_FURYJOE:Class = FuryJoe;
    public static const BOMBERS_R2D2:Class = R2D2;
    public static const BOMBERS_ZOMBIE:Class = Zombie;

    // DO
    [Embed(source="common/DO/00.png")]
    public static const DO_00:Class;

    [Embed(source="common/DO/01.png")]
    public static const DO_01:Class;

    [Embed(source="common/DO/03.png")]
    public static const DO_03:Class;

    [Embed(source="common/DO/41.png")]
    public static const DO_41:Class;

    [Embed(source="common/DO/100.png")]
    public static const DO_100:Class;

    [Embed(source="common/DO/101.png")]
    public static const DO_101:Class;

    [Embed(source="common/DO/1011.png")]
    public static const DO_1011:Class;

    [Embed(source="common/DO/1012.swf", mimeType="application/octet-stream")]
    public static const DO_1012:Class;

    [Embed(source="common/DO/1013.swf", mimeType="application/octet-stream")]
    public static const DO_1013:Class;

    [Embed(source="common/DO/102.png")]
    public static const DO_102:Class;

    [Embed(source="common/DO/103.png")]
    public static const DO_103:Class;

    [Embed(source="common/DO/104.png")]
    public static const DO_104:Class;

    [Embed(source="common/DO/106.1.png")]
    public static const DO_106_1:Class;

    [Embed(source="common/DO/106.10.png")]
    public static const DO_106_10:Class;

    [Embed(source="common/DO/106.2.png")]
    public static const DO_106_2:Class;

    [Embed(source="common/DO/106.5.png")]
    public static const DO_106_5:Class;

    //explosions
    [Embed(source="common/explosions/cross.png")]
    public static const EXPLOSIONS_CROSS:Class;

    [Embed(source="common/explosions/die0.png")]
    public static const EXPLOSIONS_DIE0:Class;

    [Embed(source="common/explosions/die1.png")]
    public static const EXPLOSIONS_DIE1:Class;

    [Embed(source="common/explosions/die2.png")]
    public static const EXPLOSIONS_DIE2:Class;

    [Embed(source="common/explosions/down.png")]
    public static const EXPLOSIONS_DOWN:Class;

    [Embed(source="common/explosions/horizontal.png")]
    public static const EXPLOSIONS_HORIZONTAL:Class;

    [Embed(source="common/explosions/left.png")]
    public static const EXPLOSIONS_LEFT:Class;

    [Embed(source="common/explosions/print.png")]
    public static const EXPLOSIONS_PRINT:Class;

    [Embed(source="common/explosions/right.png")]
    public static const EXPLOSIONS_RIGHT:Class;

    [Embed(source="common/explosions/smoke.png")]
    public static const EXPLOSIONS_SMOKE:Class;

    [Embed(source="common/explosions/up.png")]
    public static const EXPLOSIONS_UP:Class;

    [Embed(source="common/explosions/vertical.png")]
    public static const EXPLOSIONS_VERTICAL:Class;

    //  HealthBar

    [Embed(source="common/healthBar/green_center.png")]
    public static const HEALTHBAR_GREEN_CENTER:Class;

    [Embed(source="common/healthBar/green_side.png")]
    public static const HEALTHBAR_GREEN_SIDE:Class;

    [Embed(source="common/healthBar/red_center.png")]
    public static const HEALTHBAR_RED_CENTER:Class;

    [Embed(source="common/healthBar/red_side.png")]
    public static const HEALTHBAR_RED_SIDE:Class;

    [Embed(source="common/healthBar/yellow_center.png")]
    public static const HEALTHBAR_YELLOW_CENTER:Class;

    [Embed(source="common/healthBar/yellow_side.png")]
    public static const HEALTHBAR_YELLOW_SIDE:Class;

    // Map
    [Embed(source="common/map/fire1.swf", mimeType="application/octet-stream")]
    public static const MAP_FIRE1:Class;

    // Other
    [Embed(source="common/other/DYNAMITE_tip.png")]
    public static const OTHER_DYNAMYTE_tip:Class;

    [Embed(source="common/other/playerPointer.png")]
    public static const OTHER_PLAYER_POINTER:Class;


//  Location00

    [Embed(source="locations/l00/map/background.jpg")]
    public static const l00_MAP_BACKGROUND:Class;

    [Embed(source="locations/l00/map/box1.png")]
    public static const l00_MAP_BOX1:Class;

    [Embed(source="locations/l00/map/box2.png")]
    public static const l00_MAP_BOX2:Class;

    [Embed(source="locations/l00/map/box3.png")]
    public static const l00_MAP_BOX3:Class;

    [Embed(source="locations/l00/map/goldBox.png")]
    public static const l00_MAP_GOLDBOX:Class;

    [Embed(source="locations/l00/map/wall1.png")]
    public static const l00_MAP_WALL1:Class;

    // monsters

    [Embed(source="locations/l00/monsters/Spider.swf", mimeType="application/octet-stream")]
    public static const l00_MONSTERS_SPIDER:Class;

    [Embed(source="locations/l00/monsters/SpiderRed.swf", mimeType="application/octet-stream")]
    public static const l00_MONSTERS_SPIDERRED:Class;

//    Location01

    [Embed(source="locations/l01/map/background.jpg")]
    public static const l01_MAP_BACKGROUND:Class;

    [Embed(source="locations/l01/map/box1.png")]
    public static const l01_MAP_BOX1:Class;

    [Embed(source="locations/l01/map/goldBox.png")]
    public static const l01_MAP_GOLDBOX:Class;

    [Embed(source="locations/l01/map/wall1.png")]
    public static const l01_MAP_WALL1:Class;


    public static const swfs:Array = [
        new SWFDescriptor(DO_1012, "GreenMarshrum"),
        new SWFDescriptor(DO_1013, "RedMarshrum"),
        new SWFDescriptor(MAP_FIRE1, "Lava"),

        new SWFDescriptor(l00_MONSTERS_SPIDER, "Spider"),
        new SWFDescriptor(l00_MONSTERS_SPIDERRED, "SpiderRed")
    ]

    private static function className(cl:Class):String {
        for each (var desc:SWFDescriptor in swfs) {
            if (desc.swfClass == cl)
                return desc.className;
        }
        return null
    }

    public static function getBitmapOrMovieclip(code:String):* {
        trace("request embeded code: " + code)
        var c:Class = CommonContent[code];
        if(c == null)
            return new Bitmap();
        var n:String = className(c);
        if(n){
            var mcClass:Class = ApplicationDomain.currentDomain.getDefinition(n) as Class;
            return new mcClass();
        }
        return new c();
    }
}
}
