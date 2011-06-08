/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.profiles {
public class LobbyProfile {
    public var id:String
    public var nick:String
    public var photoURL:String
    public var experience:int
    public var slot:int
    public var isReady:Boolean

    public var place:int
    public var expEarned:int

    public function LobbyProfile(id:String, nick:String, photo:String, experience:int, slot:int, isReady:Boolean,place:int = 0, expEarned: int = 0) {
        this.id = id
        this.nick = nick
        this.photoURL = photo
        this.experience = experience
        this.slot = slot
        this.isReady = isReady
		
		this.place = place;
		this.expEarned = expEarned;
    }
}
}
