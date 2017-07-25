package deengames.incrementalwar.states;

import deengames.incrementalwar.model.Discovery;
import deengames.incrementalwar.model.Earth;
import deengames.incrementalwar.model.Region;
import helix.core.HelixState;
import helix.core.HelixText;
import helix.data.Config;
import polyglot.Translater;

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
		this.energyDisplay = new HelixText(0, UI_PADDING, "", UI_FONT_SIZE);

		this.alloyDisplay = new HelixText(0, Std.int(this.energyDisplay.y + this.energyDisplay.size + UI_PADDING), Translater.get("ALLOY_AMOUNT", [0]), UI_FONT_SIZE);
		this.alloyDisplay.x = this.width - this.alloyDisplay.width - UI_PADDING;

		this.neodymiumDisplay = new HelixText(0, Std.int(this.alloyDisplay.y + this.alloyDisplay.fontSize + UI_PADDING), Translater.get("NEODYMIUM_AMOUNT", [0]), UI_FONT_SIZE);
		this.neodymiumDisplay.x = this.width - this.neodymiumDisplay.width - UI_PADDING;

		// UI: units
		this.numAlloyHarvestersDisplay = new HelixText(Std.int(this.neodymiumDisplay.x) - UI_PADDING, Std.int(this.neodymiumDisplay.y) + this.neodymiumDisplay.fontSize + 2 * UI_PADDING, Translater.get("ALLOY_HARVESTERS", [0]), UI_FONT_SIZE);
		this.numAlloyHarvestersDisplay.alpha = 0;

		this.numNeodymiumHarvestersDisplay = new HelixText(Std.int(this.numAlloyHarvestersDisplay.x), Std.int(this.numAlloyHarvestersDisplay.y) + numAlloyHarvestersDisplay.fontSize + UI_PADDING, Translater.get("NEODYMIUM_HARVESTERS", [0]), UI_FONT_SIZE);
		this.numNeodymiumHarvestersDisplay.alpha = 0;

		// UI: buildings
		this.neodymiumElectricGeneratorsDisplay = new HelixText(UI_PADDING, 0, Translater.get("NEODYMIUM_BUILDINGS", [0]), UI_FONT_SIZE);
		this.neodymiumElectricGeneratorsDisplay.y = this.height - this.neodymiumElectricGeneratorsDisplay.height - UI_PADDING;
		
		// UI: controls/buttons
		this.buyAlloyHarvester = new HelixText(0, 0, Translater.get("BUY_ALLOY_HARVESTER"), UI_ACTION_FONT_SIZE);
		this.buyAlloyHarvester.alpha = 0;

		this.mineAlloyManually = new HelixText(UI_PADDING, UI_PADDING, Translater.get("MINE_ALLOY"), UI_ACTION_FONT_SIZE);
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

		this.mineNeodymiumManually = new HelixText(UI_PADDING, Std.int(this.mineAlloyManually.y) + this.mineAlloyManually.fontSize + UI_PADDING, Translater.get("MINE_NEODYMIUM"), UI_ACTION_FONT_SIZE);
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
				this.numAlloyHarvestersDisplay.text = Translater.get("ALLOY_HARVESTERS", [this.region.numAlloyHarvesters]);
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

		this.buyNeodymiumHarvester = new HelixText(Std.int(this.buyAlloyHarvester.x), Std.int(this.buyAlloyHarvester.y) + this.buyAlloyHarvester.fontSize + UI_PADDING, Translater.get("BUY_NEODYMIUM_HARVESTER"), UI_ACTION_FONT_SIZE);
		this.buyNeodymiumHarvester.alpha = 0;
		this.buyNeodymiumHarvester.onClick(function() {
			var bought = this.region.buyNeodymiumHarvester();
			if (bought)
			{
				this.numNeodymiumHarvestersDisplay.text = Translater.get("NEODYMIUM_HARVESTERS", [this.region.numNeodymiumHarvesters]);
				// Play cash sound			
			}
			else
			{
				// Play cancel sound
			}
		});

		// TODO: abbreviate to NEG with a mandatory pop-up expounding what it really is
		this.buyNeodymiumElectricGenerator = new HelixText(UI_PADDING, 0, Translater.get("BUY_NEODYMIUM_ELECTRIC_GENERATOR"), UI_FONT_SIZE);
		this.buyNeodymiumElectricGenerator.y = this.neodymiumElectricGeneratorsDisplay.y - this.neodymiumElectricGeneratorsDisplay.height;
		this.buyNeodymiumElectricGenerator.onClick(function()
		{
			var bought = this.region.buyNeydymiumElectricGenerator();
			if (bought)
			{
				this.neodymiumElectricGeneratorsDisplay.text = Translater.get("NEODYMIUM_BUILDINGS", [this.region.numNeodymiumElectricGenerators]);

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
		this.energyDisplay.text = Translater.get("ENERGY_AMOUNT", [Std.int(Math.floor(this.region.numEnergy)), this.region.energyGainPerSecond]);
		this.energyDisplay.x = this.width - this.energyDisplay.width - UI_PADDING;


		this.alloyDisplay.text = Translater.get("ALLOY_AMOUNT", [Std.int(Math.floor(this.region.numAlloy))]);
		this.neodymiumDisplay.text = Translater.get("NEODYMIUM_AMOUNT",  [Std.int(Math.floor(this.region.numNeodymium))]);
	}
}
