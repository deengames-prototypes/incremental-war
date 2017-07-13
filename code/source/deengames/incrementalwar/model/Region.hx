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

    public function update(elapsedSeconds:Float):Void
    {
        var buildingsData:Dynamic = Config.get("buildings");
        var negEnergyPerSecond:Int = buildingsData.neodymiumElectricGenerator.energyGeneratedPerSecond;
        this.numEnergy += this.numNeodymiumElectricGenerators * negEnergyPerSecond * elapsedSeconds;
    }
}