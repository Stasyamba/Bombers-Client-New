package {
import components.common.profiles.ISocialProfile;
import components.common.profiles.SocialProfile;
import components.common.resources.ResourcePrice;
import components.common.utils.enviroment.vkontakte.ApiResult;
import components.common.utils.enviroment.vkontakte.FlashVars;

import engine.profiles.GameProfile;

[Bindable]
public class Settings {

    public var flashVars:FlashVars = new FlashVars();
    public var apiResult:ApiResult;

    public var gameProfile:GameProfile = new GameProfile();
    public var socialProfile:ISocialProfile;
    public var currentSocialWeb:int = SocialProfile.VKONTAKTE;

	/*public var lotteryTodayPrice: ResourcePrice = new ResourcePrice(10,2,0,0);
	public var lotteryTryToWinCount: int = 2;
	public var lotteryPresentFinded: ResourcePrice = null;
	public var lotteryResourcePrize:ResourcePrice = new ResourcePrice(0,0,0,0);
	*/
	public var votes: Number = 0;
    public var gameProfileLoaded:Boolean = false;

    public function Settings()
	{
    }

}
}