package deengames.incrementalwar.model;

class Region
{
    // Contains units, buildings (attack and defense), perhaps enemies, energy

    // Resources. Stored as floats but displayed as ints
    public var alloyHarvested(default, null):Float = 0;
    public var neodymiumHarvested(default, null):Float = 0;
    public var energyHarvested(default, null):Float = 0;

    // Buildings.
    public var numNeodymiumElectricGenerators(default, null):Int = 0;

    public function new(startingAlloy:Int = 0, startingNeodymium:Int = 0)
    {
        this.alloyHarvested = startingAlloy;
        this.neodymiumHarvested = startingNeodymium;
    }

    public function update(elapsedSeconds:Float):Void
    {
    }
}