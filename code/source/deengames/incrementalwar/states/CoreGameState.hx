package deengames.incrementalwar.states;

import deengames.incrementalwar.model.Discovery;
import deengames.incrementalwar.model.Earth;
import deengames.incrementalwar.model.Region;
import helix.core.HelixState;
import helix.core.HelixText;
import helix.data.Config;

class CoreGameState extends HelixState
{
	private static inline var UI_PADDING:Int = 16;
	private static inline var UI_FONT_SIZE:Int = 16;
	private static inline var UI_ACTION_FONT_SIZE:Int = 24;

	private var earth:Earth;
	private var region:Region;

	//// UI elements (display)
	// resources
	private var energyDisplay:HelixText;
	private var alloyDisplay:HelixText;
	private var neodymiumDisplay:HelixText;
	// units
	private var numAlloyHarvestersDisplay:HelixText;
	private var numNeodymiumHarvestersDisplay:HelixText;
	// buildings
	private var neodymiumElectricGeneratorsDisplay:HelixText;

	//// UI elements (control)
	private var buyNeodymiumElectricGenerator:HelixText;
	private var mineAlloyManually:HelixText;
	private var mineNeodymiumManually:HelixText;
	// TODO: rename to fit world
	private var buyAlloyHarvester:HelixText;
	private var buyNeodymiumHarvester:HelixText;

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
		var discoveriesData:Dynamic = Config.get("discoveries");
		
		// UI: resources
		this.energyDisplay = new HelixText(0, UI_PADDING, "Energy: 9999", UI_FONT_SIZE);

		this.alloyDisplay = new HelixText(0, Std.int(this.energyDisplay.y + this.energyDisplay.size + UI_PADDING), "Alloy: 9999", UI_FONT_SIZE);
		this.alloyDisplay.x = this.width - this.alloyDisplay.width - UI_PADDING;

		this.neodymiumDisplay = new HelixText(0, Std.int(this.alloyDisplay.y + this.alloyDisplay.fontSize + UI_PADDING), "Neodymium: 9999", UI_FONT_SIZE);
		this.neodymiumDisplay.x = this.width - this.neodymiumDisplay.width - UI_PADDING;

		// UI: units
		this.numAlloyHarvestersDisplay = new HelixText(Std.int(this.neodymiumDisplay.x) - UI_PADDING, Std.int(this.neodymiumDisplay.y) + this.neodymiumDisplay.fontSize + 2 * UI_PADDING, "Alloy Harvesters: 0", UI_FONT_SIZE);
		this.numAlloyHarvestersDisplay.alpha = 0;

		this.numNeodymiumHarvestersDisplay = new HelixText(Std.int(this.numAlloyHarvestersDisplay.x), Std.int(this.numAlloyHarvestersDisplay.y) + numAlloyHarvestersDisplay.fontSize + UI_PADDING, "Neodymium Harvesters: 0", UI_FONT_SIZE);
		this.numNeodymiumHarvestersDisplay.alpha = 0;

		// UI: buildings
		this.neodymiumElectricGeneratorsDisplay = new HelixText(UI_PADDING, 0, "NEGs: 0", UI_FONT_SIZE);
		this.neodymiumElectricGeneratorsDisplay.y = this.height - this.neodymiumElectricGeneratorsDisplay.height - UI_PADDING;
		
		// UI: controls/buttons
		this.buyAlloyHarvester = new HelixText(0, 0, "Buy alloy harvester", UI_ACTION_FONT_SIZE);
		this.buyAlloyHarvester.alpha = 0;

		this.mineAlloyManually = new HelixText(UI_PADDING, UI_PADDING, "Mine Alloy", UI_ACTION_FONT_SIZE);
		this.mineAlloyManually.alpha = 0;
		this.mineAlloyManually.onClick(function()
		{			
			this.region.mineAlloyManually();

			if (this.buyAlloyHarvester.alpha == 0 && 
				!this.earth.player.isDiscovered(Discovery.AlloyHarvester) &&
				 this.region.numAlloy >= discoveriesData.alloyHarvester.alloyCost)
			{
				this.earth.player.discover(Discovery.AlloyHarvester);
				this.buyAlloyHarvester.alpha = 1;
				this.numAlloyHarvestersDisplay.alpha = 1;
			}
		});

		this.mineNeodymiumManually = new HelixText(UI_PADDING, Std.int(this.mineAlloyManually.y) + this.mineAlloyManually.fontSize + UI_PADDING, "Mine Neodymium", UI_ACTION_FONT_SIZE);
		this.mineNeodymiumManually.alpha = 0;
		this.mineNeodymiumManually.onClick(function() {
			this.region.mineNeodymiumManually();

			if (this.buyNeodymiumHarvester.alpha == 0 && 
				!this.earth.player.isDiscovered(Discovery.NeodymiumHarvester) &&
				 this.region.numNeodymium >= discoveriesData.neodymiumHarvester.neodymiumRequired)
				{
					this.earth.player.discover(Discovery.NeodymiumHarvester);
					this.buyNeodymiumHarvester.alpha = 1;
					this.numNeodymiumHarvestersDisplay.alpha = 1;
				}
		});

		this.buyAlloyHarvester.x = (this.width - this.buyAlloyHarvester.width) / 2;
		this.buyAlloyHarvester.y = mineAlloyManually.y;
		this.buyAlloyHarvester.onClick(function()
		{
			var bought = this.region.buyAlloyHarvester();
			if (bought)
			{
				this.numAlloyHarvestersDisplay.text = 'Alloy harvesters: ${this.region.numAlloyHarvesters}';
				// Play cash sound

				if (this.mineNeodymiumManually.alpha == 0 && 
				!this.earth.player.isDiscovered(Discovery.ManuallyMineNeodymium) &&
				 this.region.numAlloyHarvesters >= discoveriesData.mineNeodymium.alloyHarvestersRequired)
				{
					this.earth.player.discover(Discovery.ManuallyMineNeodymium);
					this.mineNeodymiumManually.alpha = 1;
				}			
			}
			else
			{
				// Play cancel sound
			}
		});

		this.buyNeodymiumHarvester = new HelixText(Std.int(this.buyAlloyHarvester.x), Std.int(this.buyAlloyHarvester.y) + this.buyAlloyHarvester.fontSize + UI_PADDING, "Buy neodymium harvester", UI_ACTION_FONT_SIZE);
		this.buyNeodymiumHarvester.alpha = 0;
		this.buyNeodymiumHarvester.onClick(function() {
			var bought = this.region.buyNeodymiumHarvester();
			if (bought)
			{
				this.numNeodymiumHarvestersDisplay.text = 'NeoD harvesters: ${this.region.numNeodymiumHarvesters}';
				// Play cash sound			
			}
			else
			{
				// Play cancel sound
			}
		});

		// TODO: abbreviate to NEG with a mandatory pop-up expounding what it really is
		this.buyNeodymiumElectricGenerator = new HelixText(UI_PADDING, 0, "Buy NEG", UI_FONT_SIZE);
		this.buyNeodymiumElectricGenerator.y = this.neodymiumElectricGeneratorsDisplay.y - this.neodymiumElectricGeneratorsDisplay.height;
		this.buyNeodymiumElectricGenerator.onClick(function()
		{
			var bought = this.region.buyNeydymiumElectricGenerator();
			if (bought)
			{
				this.neodymiumElectricGeneratorsDisplay.text = 'NEGs: ${this.region.numNeodymiumElectricGenerators}';

				if (this.mineAlloyManually.alpha == 0 && 
				!this.earth.player.isDiscovered(Discovery.ManuallyMineAlloy) &&
				 this.region.energyGainPerSecond >= discoveriesData.mineAlloy.energyPerSecondRequirement)
				{
					this.earth.player.discover(Discovery.ManuallyMineAlloy);
					this.mineAlloyManually.alpha = 1;
				}
			}
			else
			{
				// Play cancel sound
			}
		});
	}

	private function updateUi():Void
	{
		this.energyDisplay.text = 'Energy: ${Std.int(Math.floor(this.region.numEnergy))} (+${this.region.energyGainPerSecond}/s)';
		this.energyDisplay.x = this.width - this.energyDisplay.width - UI_PADDING;


		this.alloyDisplay.text = 'Alloy: ${Std.int(Math.floor(this.region.numAlloy))}';
		this.neodymiumDisplay.text = 'Neodymium: ${Std.int(Math.floor(this.region.numNeodymium))}';
	}
}
