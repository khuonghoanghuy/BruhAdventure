package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var fpsCounter:FPS;

	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, MenuState));
		#if !flash
		fpsCounter = new FPS(615, 0, 0xFFFFFF);
		addChild(fpsCounter);
		#end
	}
}
