package;

import flixel.FlxG;

class Data
{
	public static function init()
	{
		if (FlxG.save.data.runSpeed == null)
		{
			FlxG.save.data.runSpeed = 1; // 1 was default
		}

		if (FlxG.save.data.fpsCounter == null)
		{
			FlxG.save.data.fpsCounter = true; // true was default
		}
	}
}
