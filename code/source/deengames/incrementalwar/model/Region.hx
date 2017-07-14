package deengames.incrementalwar.model;

import helix.data.Config;

// Contains units, buildings (attack and defense), perhaps enemies, energy
class Region
{
    // Resources. Stored as floats but displayed as ints
    public var numAlloy(default, null):Float = 0;
    public var numNeodymium(default, null):Float = 0;
    public var numEnergy(default, null):Float = 0;

    public var energyGainPerSecond(get, null):Float;

    // Buildings.
    public var numNeodymiumElectricGenerators(default, null):Int = 0;

    // Units
    public var numAlloyHarvesters(default, null):Int = 0;

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

    public function buyAlloyHarvester():Bool
    {
        var unitsData:Dynamic = Config.get("units");
        var alloyCost:Int = unitsData.alloyHarvester.alloyCost;
        if (numAlloy >= alloyCost)
        {
            // CHA-CHING!
            this.numAlloyHarvesters++;
            numAlloy -= alloyCost;
            return true;
        }
        
        return false;
    }

    public function mineAlloyManually():Void
    {
        var alloyGained:Int = Config.get("manualAlloyMinedPerClick");
        this.numAlloy += alloyGained;
    }

    public function mineNeodymiumManually():Void
    {
        var neodymiumGained:Int = Config.get("manualNeodymiumMinedPerClick");
        this.numNeodymium += neodymiumGained;
    }

    public function update(elapsedSeconds:Float):Void
    {
        var unitsConfig:Dynamic = Config.get("units");

        // Update energy gain/loss
        var gained:Float = this.energyGainPerSecond;
        this.numEnergy += gained * elapsedSeconds;

        // Update alloy mined
        this.numAlloy += this.numAlloyHarvesters * unitsConfig.alloyHarvester.alloyMinedPerSecond * elapsedSeconds;
    }

    private function get_energyGainPerSecond():Float
    {
        var unitsConfig:Dynamic = Config.get("units");
        
        // Energy gain from energy-producing NEGs
        var buildingsData:Dynamic = Config.get("buildings");
        var negEnergyPerSecond:Int = buildingsData.neodymiumElectricGenerator.energyGeneratedPerSecond;        
        var toReturn = negEnergyPerSecond * this.numNeodymiumElectricGenerators;

        // Energy lost per harvester
        var harvesterCost:Float = this.numAlloyHarvesters * unitsConfig.alloyHarvester.energyDrainPerSecond;        
        return toReturn - harvesterCost;
    }
}