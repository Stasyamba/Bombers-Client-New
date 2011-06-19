package loading {
import greensock.loading.MP3Loader;

public class SoundManager {

	public static const WINDOW_MOVE_OPENING: String = "windowMoveOpen.mp3";
	public static const BUTTON_CLICK_20: String = "button_20.mp3";
	public static const BUTTON_CLICK_21: String = "button_21.mp3";
	public static const BUTTON_CLICK_30: String = "button_30.mp3";
	public static const BUTTON_CLICK_46: String = "button_46.mp3";
	
    public static function play(file:String,volume:Number = 1.0):void {
        var s:MP3Loader = sound(file)
        if (s != null){
			s.volume = volume
			s.gotoSoundTime(0,true)
		}
    }

    private static function sound(file:String): MP3Loader {
        return BombersContentLoader.sound(file)
    }

}
}
