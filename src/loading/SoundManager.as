package loading {
import greensock.loading.MP3Loader;

public class SoundManager {

    public static function play(file:String):void {
        var s:MP3Loader = sound(file)
        if (s != null){
			s.gotoSoundTime(0,true)
		}
    }

    private static function sound(file:String): MP3Loader {
        return BombersContentLoader.sound(file)
    }

}
}
