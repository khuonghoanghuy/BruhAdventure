package;

import flixel.FlxSprite;

class Trampoline extends FlxSprite
{
	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		loadGraphic(AssetPaths.trampoline__png, false, 16, 16);
	}
}
