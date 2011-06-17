package loading {
import greensock.loading.MP3Loader;

public class SoundManager {

	public static const WINDOW_MOVE_OPENING: String = "windowMoveOpen.mp3";
	
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
