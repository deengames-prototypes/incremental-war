package deengames.incrementalwar.states;

import deengames.incrementalwar.model.Discovery;
import deengames.incrementalwar.model.Earth;
import deengames.incrementalwar.model.Region;
import flixel.FlxG;
import flixel.system.FlxSound;
import helix.core.HelixState;
import helix.core.HelixText;
import helix.data.Config;
import polyglot.Translater;

class CoreGameState extends HelixState
{
	// Placeholder indicating an amount of something, in four digits,
	// eg. 1.1M. Used to pad text fields so they are positioned correctly.
	private static inline var FOUR_DIGITS_SPACE:String = "XXXX";
	// Default building counts, etc. are zero and not updated until you buy
	private static inline var ZERO_PADDED_FOUR_DIGITS:String = "0   ";
	private static inline var UI_PADDING:Int = 16;
	private static inline var UI_FONT_SIZE:Int = 16;
	private static inline var UI_ACTION_FONT_SIZE:Int = 24;

	private var earth:Earth;
	private var region:Region;

	//// UI elements (display)
	// resources
	private var energyDisplay:HelixText;
	private var polymetalDisplay:HelixText;
	private var neodymiumDisplay:HelixText;
	// units
	private var numPolymetalHarvestersDisplay:HelixText;
	private var numNeodymiumHarvestersDisplay:HelixText;
	// buildings
	private var neodymiumElectricGeneratorsDisplay:HelixText;

	//// UI elements (control)
	private var buyNeodymiumElectricGenerator:HelixText;
	private var minePolymetalManually:HelixText;
	private var mineNeodymiumManually:HelixText;
	private var buyPolymetalHarvester:HelixText;
	private var buyNeodymiumHarvester:HelixText;

	// Sounds
	var buySuccessfulSound:FlxSound;
	var buyFailedSound:FlxSound;

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
		this.loadSounds();
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

		this.polymetalDisplay = new HelixText(0, Std.int(this.energyDisplay.y + this.energyDisplay.size + UI_PADDING), Translater.get("POLYMETAL_AMOUNT", [FOUR_DIGITS_SPACE]), UI_FONT_SIZE);
		this.polymetalDisplay.x = this.width - this.polymetalDisplay.width - UI_PADDING;

		this.neodymiumDisplay = new HelixText(0, Std.int(this.polymetalDisplay.y + this.polymetalDisplay.fontSize + UI_PADDING), Translater.get("NEODYMIUM_AMOUNT", [FOUR_DIGITS_SPACE]), UI_FONT_SIZE);
		this.neodymiumDisplay.x = this.width - this.neodymiumDisplay.width - UI_PADDING;

		// UI: units
		this.numPolymetalHarvestersDisplay = new HelixText(Std.int(this.neodymiumDisplay.x) - UI_PADDING, Std.int(this.neodymiumDisplay.y) + this.neodymiumDisplay.fontSize + 2 * UI_PADDING, Translater.get("POLYMETAL_HARVESTERS", [ZERO_PADDED_FOUR_DIGITS]), UI_FONT_SIZE);
		this.numPolymetalHarvestersDisplay.alpha = 0;

		this.numNeodymiumHarvestersDisplay = new HelixText(Std.int(this.numPolymetalHarvestersDisplay.x), Std.int(this.numPolymetalHarvestersDisplay.y) + numPolymetalHarvestersDisplay.fontSize + UI_PADDING, Translater.get("NEODYMIUM_HARVESTERS", [ZERO_PADDED_FOUR_DIGITS]), UI_FONT_SIZE);
		this.numNeodymiumHarvestersDisplay.alpha = 0;

		// UI: buildings
		this.neodymiumElectricGeneratorsDisplay = new HelixText(UI_PADDING, 0, Translater.get("NEODYMIUM_BUILDINGS", [0]), UI_FONT_SIZE);
		this.neodymiumElectricGeneratorsDisplay.y = this.height - this.neodymiumElectricGeneratorsDisplay.height - UI_PADDING;
		
		// UI: controls/buttons
		this.buyPolymetalHarvester = new HelixText(0, 0, Translater.get("BUY_POLYMETAL_HARVESTER"), UI_ACTION_FONT_SIZE);
		this.buyPolymetalHarvester.alpha = 0;

		this.minePolymetalManually = new HelixText(UI_PADDING, UI_PADDING, Translater.get("MINE_POLYMETAL"), UI_ACTION_FONT_SIZE);
		this.minePolymetalManually.alpha = 0;
		this.minePolymetalManually.onClick(function()
		{			
			this.region.minePolymetalManually();

			if (this.buyPolymetalHarvester.alpha == 0 && 
				!this.earth.player.isDiscovered(Discovery.PolymetalHarvester) &&
				 this.region.numPolymetal >= discoveriesData.polymetalHarvester.polymetalCost)
			{
				this.earth.player.discover(Discovery.PolymetalHarvester);
				this.buyPolymetalHarvester.alpha = 1;
				this.numPolymetalHarvestersDisplay.alpha = 1;
			}
		});

		this.mineNeodymiumManually = new HelixText(UI_PADDING, Std.int(this.minePolymetalManually.y) + this.minePolymetalManually.fontSize + UI_PADDING, Translater.get("MINE_NEODYMIUM"), UI_ACTION_FONT_SIZE);
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

		this.buyPolymetalHarvester.x = (this.width - this.buyPolymetalHarvester.width) / 2;
		this.buyPolymetalHarvester.y = minePolymetalManually.y;
		this.buyPolymetalHarvester.onClick(function()
		{
			var bought = this.region.buyPolymetalHarvester();
			if (bought)
			{
				this.numPolymetalHarvestersDisplay.text = Translater.get("POLYMETAL_HARVESTERS", [this.region.numpolymetalHarvesters]);
				this.buySuccessfulSound.play(true);

				if (this.mineNeodymiumManually.alpha == 0 && 
				!this.earth.player.isDiscovered(Discovery.ManuallyMineNeodymium) &&
				 this.region.numpolymetalHarvesters >= discoveriesData.mineNeodymium.polymetalHarvestersRequired)
				{
					this.earth.player.discover(Discovery.ManuallyMineNeodymium);
					this.mineNeodymiumManually.alpha = 1;
				}			
			}
			else
			{
				this.buyFailedSound.play(true);
			}
		});

		this.buyNeodymiumHarvester = new HelixText(Std.int(this.buyPolymetalHarvester.x), Std.int(this.buyPolymetalHarvester.y) + this.buyPolymetalHarvester.fontSize + UI_PADDING, Translater.get("BUY_NEODYMIUM_HARVESTER"), UI_ACTION_FONT_SIZE);
		this.buyNeodymiumHarvester.alpha = 0;
		this.buyNeodymiumHarvester.onClick(function() {
			var bought = this.region.buyNeodymiumHarvester();
			if (bought)
			{
				this.numNeodymiumHarvestersDisplay.text = Translater.get("NEODYMIUM_HARVESTERS", [this.region.numNeodymiumHarvesters]);
				this.buySuccessfulSound.play(true);
			}
			else
			{
				this.buyFailedSound.play(true);
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
				this.buySuccessfulSound.play(true);

				if (this.minePolymetalManually.alpha == 0 && 
				!this.earth.player.isDiscovered(Discovery.ManuallyminePolymetal) &&
				 this.region.energyGainPerSecond >= discoveriesData.minePolymetal.energyPerSecondRequirement)
				{
					this.earth.player.discover(Discovery.ManuallyminePolymetal);
					this.minePolymetalManually.alpha = 1;
				}
			}
			else
			{
				this.buyFailedSound.play(true);
			}
		});
	}

	private function updateUi():Void
	{
		this.energyDisplay.text = Translater.get("ENERGY_AMOUNT", [Std.int(Math.floor(this.region.numEnergy)), this.region.energyGainPerSecond]);
		this.energyDisplay.x = this.width - this.energyDisplay.width - UI_PADDING;


		this.polymetalDisplay.text = Translater.get("POLYMETAL_AMOUNT", [Std.int(Math.floor(this.region.numPolymetal))]);
		this.neodymiumDisplay.text = Translater.get("NEODYMIUM_AMOUNT",  [Std.int(Math.floor(this.region.numNeodymium))]);
	}

	private function loadSounds():Void
	{
		this.buySuccessfulSound = FlxG.sound.load("assets/sounds/ui/buy-success.ogg");
		this.buyFailedSound = FlxG.sound.load("assets/sounds/ui/buy-failed.ogg");
	}
}
