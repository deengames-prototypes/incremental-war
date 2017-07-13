package deengames.incrementalwar.model;

import helix.data.Config;

class Region
{
    // Contains units, buildings (attack and defense), perhaps enemies, energy

    // Resources. Stored as floats but displayed as ints
    public var numAlloy(default, null):Float = 0;
    public var numNeodymium(default, null):Float = 0;
    public var numEnergy(default, null):Float = 0;

    // Buildings.
    public var numNeodymiumElectricGenerators(default, null):Int = 0;

    public function new(startingAlloy:Int = 0, startingNeodymium:Int = 0)
    {
        this.numAlloy = startingAlloy;
        this.numNeodymium = startingNeodymium;
    }

    // Returns true if bought, false if insufficient funds
    public function buyNeydymiumElectricGenerator():Bool
    {
        var costs:Dynamic = Config.get("buildingCosts");
        var buildingCosts:Array<Int> = costs.neodymiumElectricGenerator;
        if (numAlloy >= buildingCosts[0] && numNeodymium >= buildingCosts[1])
        {
            // CHA-CHING!
            this.numNeodymiumElectricGenerators++;
            numAlloy -= buildingCosts[0];
            numNeodymium -= buildingCosts[1];
            return true;
        }
        
        return false;
    }

    public function update(elapsedSeconds:Float):Void
    {
    }
}