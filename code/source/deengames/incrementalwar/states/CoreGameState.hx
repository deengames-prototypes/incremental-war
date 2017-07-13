package deengames.incrementalwar.states;

import deengames.incrementalwar.model.Earth;
import deengames.incrementalwar.model.Region;
import flixel.text.FlxText;
import helix.core.HelixState;
import helix.core.HelixText;

class CoreGameState extends HelixState
{
	private static inline var UI_PADDING:Int = 16;
	private static inline var UI_FONT_SIZE:Int = 16;

	private var earth:Earth;
	private var region:Region;

	//// UI elements (display)
	// resources
	private var energyDisplay:FlxText;
	private var alloyDisplay:FlxText;
	private var neodymiumDisplay:FlxText;

	// buildings
	private var neodymiumElectricGeneratorsDisplay:FlxText;

	//// UI elements (control)
	private var buyNeodymiumElectricGenerator:HelixText;

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
		// UI: resources
		this.energyDisplay = this.addText(0, UI_PADDING, "Energy: 9999", UI_FONT_SIZE);
		this.energyDisplay.x = this.width - this.energyDisplay.width - UI_PADDING;

		this.alloyDisplay = this.addText(0, Std.int(this.energyDisplay.y + this.energyDisplay.size + UI_PADDING), "Alloy: 9999", UI_FONT_SIZE);
		this.alloyDisplay.x = this.width - this.alloyDisplay.width - UI_PADDING;

		this.neodymiumDisplay = this.addText(0, Std.int(this.alloyDisplay.y + this.alloyDisplay.size + UI_PADDING), "Neodymium: 9999", UI_FONT_SIZE);
		this.neodymiumDisplay.x = this.width - this.neodymiumDisplay.width - UI_PADDING;

		// UI: buildings
		this.neodymiumElectricGeneratorsDisplay = this.addText(UI_PADDING, 0, "NEGs: 0", UI_FONT_SIZE);
		this.neodymiumElectricGeneratorsDisplay.y = this.height - this.neodymiumElectricGeneratorsDisplay.height - UI_PADDING;
		
		// UI: controls/buttons
		// TODO: abbreviate to NEG with a mandatory pop-up expounding what it really is
		this.buyNeodymiumElectricGenerator = this.addText(UI_PADDING, 0, "Buy NEG (Neodymium Electric Generator)", UI_FONT_SIZE);
		this.buyNeodymiumElectricGenerator.y = this.neodymiumElectricGeneratorsDisplay.y - this.neodymiumElectricGeneratorsDisplay.height;
		this.buyNeodymiumElectricGenerator.onClick(function()
		{
			var bought = this.region.buyNeydymiumElectricGenerator();
			if (bought)
			{
				this.neodymiumElectricGeneratorsDisplay.text = 'NEGs: ${this.region.numNeodymiumElectricGenerators}';
			}
			else
			{
				// Play cancel sound
			}
		});
	}

	private function updateUi():Void
	{
		this.energyDisplay.text = 'Energy: ${Std.int(Math.floor(this.region.numEnergy))}';
		this.alloyDisplay.text = 'Alloy: ${Std.int(Math.floor(this.region.numAlloy))}';
		this.neodymiumDisplay.text = 'Neodymium: ${Std.int(Math.floor(this.region.numNeodymium))}';
	}
}
