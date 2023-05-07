package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class MainState extends FlxState
{
	var version_text:FlxText;
	var version:String = "v1.3";

	override public function create()
	{
		super.create();

		Data.init();
		FlxG.save.bind("data", "assets/data/");
	}

	private function showText(enable:Bool)
	{
		if (enable)
		{
			version_text = new FlxText(0, 0, 0, version + " Beta", 12);
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

		if (FlxG.save.data.fpsCap == null)
		{
			FlxG.updateFramerate = 60;
			FlxG.drawFramerate = 60;
		}
		else
		{
			FlxG.updateFramerate = FlxG.save.data.fpsCap;
			FlxG.drawFramerate = FlxG.save.data.fpsCap;
		}
	}
}
