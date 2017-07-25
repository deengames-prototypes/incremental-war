package;

import flixel.FlxGame;
import openfl.display.Sprite;
import openfl.Assets;
import polyglot.Translater;

class Main extends Sprite
{
	public function new()
	{
		super();

		var localizations = ["en", "ar"];
		for (localization in localizations)
		{
			Translater.addLanguage(localization, Assets.getText('assets/data/localizations/${localization}.txt'));
		}
		Translater.selectLanguage(localizations[0]);
		
		addChild(new FlxGame(0, 0, deengames.incrementalwar.states.CoreGameState, 1, 60, 60, true));
	}
}
