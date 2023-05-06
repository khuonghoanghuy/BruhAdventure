package;

import flixel.FlxSprite;

class Flags extends FlxSprite
{
	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		loadGraphic(AssetPaths.flags__png, true, 16, 16);
		animation.add("idle", [0, 1, 2, 3], 12, true);
		animation.add("touch!", [5, 6], 12, true);
	}
}
