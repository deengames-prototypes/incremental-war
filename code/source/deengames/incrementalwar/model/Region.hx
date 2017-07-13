package deengames.incrementalwar.model;

class Region
{
    // Contains units, buildings (attack and defense), perhaps enemies, energy

    // Stored as floats but displayed as ints
    public var alloyHarvested(default, null):Float = 0;
    public var neodymiumHarvested(default, null):Float = 0;
    public var energyHarvested(default, null):Float = 0;

    public function new()
    {
    }

    public function update(elapsedSeconds:Float):Void
    {
    }
}