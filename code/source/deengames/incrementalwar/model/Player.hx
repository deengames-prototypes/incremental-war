package deengames.incrementalwar.model;

import deengames.incrementalwar.model.Discovery;

// Everything we want to serialize. THE Player's "global" stuff.
class Player
{
    private var discoveries = new Array<Discovery>();

    public function new()
    {

    }

    public function discover(discovery:Discovery):Void
    {
        this.discoveries.push(discovery);
    }

    public function isDiscovered(discovery:Discovery):Bool
    {
        var toReturn = this.discoveries.indexOf(discovery) > -1;
        return toReturn;
    }
}