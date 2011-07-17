package loading {
import greensock.TweenMax
import greensock.loading.MP3Loader

import org.osflash.signals.Signal

public class SoundManager {

    public static const WINDOW_MOVE_OPENING:String = "windowMoveOpen.mp3";
    public static const BUTTON_CLICK_20:String = "button_20.mp3";
    public static const BUTTON_CLICK_21:String = "button_21.mp3";
    public static const BUTTON_CLICK_30:String = "button_30.mp3";
    public static const BUTTON_CLICK_46:String = "button_46.mp3";

    private static var _isPlayingSounds:Boolean = true;
    private static var _isPlayingMusic:Boolean = true;

    private static var playingForever:MP3Loader

    private static const FADE_TIME:Number = 2.0;

    private static var musicStopped:Signal = new Signal()

    public static function playSound(file:String, volume:Number = 1.0):void {
        var s:MP3Loader = sound(file)
        if (s != null) {
            s.volume = _isPlayingSounds ? volume : 0;
            s.gotoSoundTime(0, true);
        }
    }

    public static function playMusic(file:String, volume:Number = 1.0):void {

        if (stopMusic()) {
            musicStopped.addOnce(function() {
                startSurely(file, volume)

            })
        } else
            startSurely(file, volume)
    }

    private static function startSurely(file:String, volume:Number = 1.0):void {
        if (!startMusic(file, volume)) {
            BombersContentLoader.soundsLoaded.addOnce(function() {
                startMusic(file, volume)
            })
        }
    }

    private static function startMusic(file:String, volume:Number = 1.0):Boolean {
        var s:MP3Loader = sound(file)
        if (s != null) {
            s.volume = _isPlayingMusic ? volume : 0;
            s.vars.repeat = -1;
            s.gotoSoundTime(0, true)
            playingForever = s;
        }
        return s != null;
    }

    public static function stopMusic():Boolean {
        if (playingForever) {
            TweenMax.to(playingForever, FADE_TIME, {volume:0,onComplete:function() {
                playingForever.pauseSound();
                playingForever.vars.repeat = 0
                playingForever = null;
                musicStopped.dispatch()
            }})
        }
        return playingForever;
    }

    public static function changeMusicVolume(volume:Number):void {
        if (playingForever && _isPlayingMusic) {
            TweenMax.to(playingForever, FADE_TIME, {volume:volume})
        }
    }

    public function switchMusicOff():void {
        changeMusicVolume(0);
        _isPlayingMusic = false;
    }

    public function switchMusicOn():void {
        _isPlayingMusic = true;
        changeMusicVolume(1);
    }

    private static function sound(file:String):MP3Loader {
        return BombersContentLoader.sound(file)
    }

}
}
