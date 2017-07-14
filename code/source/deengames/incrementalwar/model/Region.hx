package deengames.incrementalwar.model;

import helix.data.Config;

// Contains units, buildings (attack and defense), perhaps enemies, energy
class Region
{
    // May eventually grow to be more per click
    private static inline var MANUAL_ALLOY_MINED_PER_CLICK:Int = 1;
    
    // Resources. Stored as floats but displayed as ints
    public var numAlloy(default, null):Float = 0;
    public var numNeodymium(default, null):Float = 0;
    public var numEnergy(default, null):Float = 0;

    public var energyGainPerSecond(get, null):Int;

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
        var buildingsData:Dynamic = Config.get("buildings");
        var negData:Dynamic = buildingsData.neodymiumElectricGenerator;
        var alloyCost:Int = negData.alloyCost;
        var neodymiumCost:Int = negData.neodymiumCost;
        if (numAlloy >= alloyCost  && numNeodymium >= neodymiumCost)
        {
            // CHA-CHING!
            this.numNeodymiumElectricGenerators++;
            numAlloy -= alloyCost;
            numNeodymium -= neodymiumCost;
            return true;
        }
        
        return false;
    }

    public function mineAlloyManually():Void
    {
        this.numAlloy += MANUAL_ALLOY_MINED_PER_CLICK;
    }

    public function update(elapsedSeconds:Float):Void
    {
        this.numEnergy += this.energyGainPerSecond * elapsedSeconds;
    }

    private function get_energyGainPerSecond():Int
    {
        var buildingsData:Dynamic = Config.get("buildings");
        var negEnergyPerSecond:Int = buildingsData.neodymiumElectricGenerator.energyGeneratedPerSecond;        
        var toReturn = negEnergyPerSecond * this.numNeodymiumElectricGenerators;
        return toReturn;
    }
}