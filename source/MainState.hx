package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class MainState extends FlxState
{
	var version_text:FlxText;

	override public function create()
	{
		super.create();
	}

	private function showText(enable:Bool)
	{
		if (enable)
		{
			version_text = new FlxText(0, 0, 0, "v1.3 Beta", 12);
			version_text.scrollFactor.set();
			add(version_text);
		}
		else {}

		return enable;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!FlxG.save.data.fpsCounter)
		{
			FlxG.stage.removeChild(Main.fpsCounter);
		}
		else
		{
			FlxG.stage.addChild(Main.fpsCounter);
		}
	}
}
