package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, deengames.incrementalwar.states.CoreGameState, 1, 60, 60, true));
	}
}
