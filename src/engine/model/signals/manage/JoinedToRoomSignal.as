/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.model.signals.manage {
import org.osflash.signals.Signal

public class JoinedToRoomSignal extends Signal {
    public function JoinedToRoomSignal() {
        super(int, String, Array)
    }
}
}