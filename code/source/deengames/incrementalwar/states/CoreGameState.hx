package deengames.incrementalwar.states;

import deengames.incrementalwar.model.Earth;
import deengames.incrementalwar.model.Region;
import flixel.FlxState;

class CoreGameState extends FlxState
{
	private var earth:Earth;
	private var region:Region;

	override public function create():Void
	{
		if (Earth.instance == null)
		{
			new Earth();
		}

		this.earth = Earth.instance;
		super.create();
		this.region = earth.currentRegion;
	}

	override public function update(elapsedSeconds:Float):Void
	{
		super.update(elapsedSeconds);
		earth.update(elapsedSeconds);
	}
}
