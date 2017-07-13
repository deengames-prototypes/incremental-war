package deengames.incrementalwar.states;

import deengames.incrementalwar.model.Earth;
import deengames.incrementalwar.model.Region;
import flixel.text.FlxText;
import helix.core.HelixState;

class CoreGameState extends HelixState
{
	private static inline var UI_PADDING:Int = 16;
	private static inline var UI_FONT_SIZE:Int = 16;

	private var earth:Earth;
	private var region:Region;

	// UI elements
	private var energyDisplay:FlxText;

	override public function create():Void
	{
		super.create();
		
		if (Earth.instance == null)
		{
			new Earth();
		}

		this.earth = Earth.instance;
		this.region = earth.currentRegion;

		this.createUi();
	}

	override public function update(elapsedSeconds:Float):Void
	{
		super.update(elapsedSeconds);
		earth.update(elapsedSeconds);
		this.updateUi();
	}

	private function createUi():Void
	{
		// Expectation: four digits max, eg. 1.1M, 1.7B
		this.energyDisplay = this.addText(0, UI_PADDING, "Energy: 9999", UI_FONT_SIZE);
		this.energyDisplay.x = this.width - this.energyDisplay.width - UI_PADDING;
	}

	private function updateUi():Void
	{
		this.energyDisplay.text = 'Energy: ${Std.int(Math.floor(this.region.energyHarvested))}';
	}
}
