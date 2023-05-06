package;

import flixel.FlxSprite;

class Player extends FlxSprite
{
	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		loadGraphic(AssetPaths.player__png, false, 16, 16);
	}
}
