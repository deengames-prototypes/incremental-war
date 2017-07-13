package deengames.incrementalwar.model;

class Earth
{
    public var regions(default, null):Array<Region>;
    public var currentRegion(default, null):Region;
    public static var instance(default, null):Earth;

    public function new() 
    {
        Earth.instance = this;
        this.regions = new Array<Region>();
        this.regions.push(new Region());
        this.currentRegion = this.regions[0];
    }

    public function update(elapsedSeconds:Float):Void
    {
        for (region in this.regions)
        {
            region.update(elapsedSeconds);
        }
    }
}