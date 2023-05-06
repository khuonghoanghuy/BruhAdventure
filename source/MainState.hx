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

		version_text = new FlxText(0, 0, 0, "v1.2 Beta", 12);
		version_text.scrollFactor.set();
		add(version_text);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
