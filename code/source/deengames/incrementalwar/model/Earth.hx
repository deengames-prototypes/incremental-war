package deengames.incrementalwar.model;

import helix.data.Config;

class Earth
{
    public var regions(default, null):Array<Region>;
    public var currentRegion(default, null):Region;
    public static var instance(default, null):Earth;

    public function new() 
    {
        Earth.instance = this;
        this.regions = new Array<Region>();

        var startingCosts:Array<Int> = Config.get("startingResources");
        var alloy = startingCosts[0];
        var neodymium = startingCosts[1];

        this.currentRegion = new Region(alloy, neodymium);
        this.regions.push(this.currentRegion);
    }

    public function update(elapsedSeconds:Float):Void
    {
        for (region in this.regions)
        {
            region.update(elapsedSeconds);
        }
    }
}