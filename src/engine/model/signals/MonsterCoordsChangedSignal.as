/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.model.signals {
import org.osflash.signals.Signal

public class MonsterCoordsChangedSignal extends Signal {
    public function MonsterCoordsChangedSignal() {
        super(int, Number, Number)
    }
}
}
