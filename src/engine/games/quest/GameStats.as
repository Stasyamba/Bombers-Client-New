/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest {
import components.common.items.ItemProfileObject
import components.common.items.ItemType

import mx.collections.ArrayList

public class GameStats {

    private var _destroyedBlocks:ArrayList = new ArrayList();
    private var _collectedObjects:ArrayList = new ArrayList();
    private var _defeatedMonsters:ArrayList = new ArrayList();
    private var _collectedItems:Object = new Object();

    public var goldCollected:int = 0;

    //array of DestroyedMapBlockObject
    public function get destroyedBlocks():ArrayList {
        return _destroyedBlocks;
    }

    //array of CollectedDOObject
    public function get collectedObjects():ArrayList {
        return _collectedObjects;
    }

    //array of DefeatedMonsterObject
    public function get defeatedMonsters():ArrayList {
        return _defeatedMonsters;
    }


    public function get collectedItems():Object {
        return _collectedItems
    }

    public function GameStats() {
    }

    public function collectItem(item:ItemType, count:int):void {
        if (_collectedItems[item.value]) {
            _collectedItems[item.value].count += count
        } else {
            _collectedItems[item.value] = new ItemProfileObject(item, count);
        }

    }
}
}
