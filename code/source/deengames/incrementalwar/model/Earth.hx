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

        this.currentRegion = new Region();
        this.currentRegion.setupFirstRegionEver();
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