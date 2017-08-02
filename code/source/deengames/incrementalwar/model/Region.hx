package deengames.incrementalwar.model;

import helix.data.Config;

// Contains units, buildings (attack and defense), perhaps enemies, energy
class Region
{
    // Resources. Stored as floats but displayed as ints
    public var numPolymetal(default, null):Float = 0;
    public var numNeodymium(default, null):Float = 0;
    public var numEnergy(default, null):Float = 0;

    public var energyGainPerSecond(get, null):Float;

    // Buildings.
    public var numNeodymiumElectricGenerators(default, null):Int = 0;

    // Units
    public var numpolymetalHarvesters(default, null):Int = 0;
    public var numNeodymiumHarvesters(default, null):Int = 0;

    public function new(startingPolymetal:Int = 0, startingNeodymium:Int = 0)
    {
        this.numPolymetal = startingPolymetal;
        this.numNeodymium = startingNeodymium;
    }

    // Returns true if bought, false if insufficient funds
    public function buyNeydymiumElectricGenerator():Bool
    {
        var buildingsData:Dynamic = Config.get("buildings");
        var negData:Dynamic = buildingsData.neodymiumElectricGenerator;
        var polymetalCost:Int = negData.polymetalCost;
        var neodymiumCost:Int = negData.neodymiumCost;
        if (numPolymetal >= polymetalCost  && numNeodymium >= neodymiumCost)
        {
            // CHA-CHING!
            this.numNeodymiumElectricGenerators++;
            numPolymetal -= polymetalCost;
            numNeodymium -= neodymiumCost;
            return true;
        }
        
        return false;
    }

    public function buyPolymetalHarvester():Bool
    {
        var unitsData:Dynamic = Config.get("units");
        var polymetalCost:Int = unitsData.polymetalHarvester.polymetalCost;
        if (numPolymetal >= polymetalCost)
        {
            // CHA-CHING!
            this.numpolymetalHarvesters++;
            numPolymetal -= polymetalCost;
            return true;
        }
        
        return false;
    }

    public function buyNeodymiumHarvester():Bool
    {
        var unitsData:Dynamic = Config.get("units");
        var polymetalCost:Int = unitsData.neodymiumHarvester.polymetalCost;
        var neodymiumCost:Int = unitsData.neodymiumHarvester.neodymiumCost;
        if (numPolymetal >= polymetalCost && numNeodymium >= neodymiumCost)
        {
            // CHA-CHING!
            this.numNeodymiumHarvesters++;
            numPolymetal -= polymetalCost;
            numNeodymium -= neodymiumCost;
            return true;
        }
        
        return false;
    }

    public function minePolymetalManually():Void
    {
        var polymetalGained:Int = Config.get("manualPolymetalMinedPerClick");
        this.numPolymetal += polymetalGained;
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
        
        if (numEnergy > 0)
        {
            // Update polymetal mined
            this.numPolymetal += this.numpolymetalHarvesters * unitsConfig.polymetalHarvester.polymetalMinedPerSecond * elapsedSeconds;
            // Update neodymium mined
            this.numNeodymium += this.numNeodymiumHarvesters * unitsConfig.neodymiumHarvester.neodymiumMinedPerSecond * elapsedSeconds;
        }
        else
        {
            // Don't sink into a deep, dark pit; cap at 0.
            this.numEnergy = 0;
        }
    }

    private function get_energyGainPerSecond():Float
    {
        var unitsConfig:Dynamic = Config.get("units");
        
        // Energy gain from energy-producing NEGs
        var buildingsData:Dynamic = Config.get("buildings");
        var negEnergyPerSecond:Int = buildingsData.neodymiumElectricGenerator.energyGeneratedPerSecond;        
        var amountGenerated = negEnergyPerSecond * this.numNeodymiumElectricGenerators;

        //// Energy lost per building
        // Polymetal harvesters
        var polymetalHarvesterCost:Float = this.numpolymetalHarvesters * unitsConfig.polymetalHarvester.energyDrainPerSecond;        
        // Neodymium harvesters
        var neodymiumHarvesterCost:Float = this.numNeodymiumHarvesters * unitsConfig.neodymiumHarvester.energyDrainPerSecond;

        return amountGenerated - polymetalHarvesterCost - neodymiumHarvesterCost;
    }
}