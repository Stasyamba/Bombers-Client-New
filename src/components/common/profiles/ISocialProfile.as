package components.common.profiles {

[Bindable]
public interface ISocialProfile {

    function get id():String;

    function set id(value:String):void;

    function get name():String;

    function set name(value:String):void;

    function get surname():String;

    function set surname(value:String):void;

    function get photoURL():String;

    function set photoURL(value:String):void;
	
	function get photoSmallURL():String;
	
	function set photoSmallURL(value:String):void;
	
	function get photoBigURL():String;
	
	function set photoBigURL(value:String):void;

    function get profileLink():String;

    function set profileLink(value:String):void;
	
	function set isUserOnline(value: Boolean): void;
	
	function get isUserOnline(): Boolean;
	
    function clone(profile:ISocialProfile):void;

	//function setFriend(id: String): void;
	
	/**
	 * 
	 * @param type = const in SocialProfile
	 * @return 
	 * 
	 */
	function getFriends(type: int): Array; // type = [ISocialProfile, ... ] (const in SocialProfile)
	
	function updateFriends(): void;
}

}