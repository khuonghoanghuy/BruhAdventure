package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class OptionsMenu extends MainState
{
	var list:Array<String> = ["Exit"];
	var group_button:FlxTypedGroup<FlxSprite>;
	var curSelected:Int = 0;

	override public function create()
	{
		group_button = new FlxTypedGroup<FlxSprite>();
		add(group_button);

		super.create();

		change();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.anyJustPressed([UP, W]))
		{
			change(-1);
		}

		if (FlxG.keys.anyJustPressed([DOWN, S]))
		{
			change(1);
		}
	}

	function change(change:Int = 0)
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = group_button.length - 1;
		if (curSelected >= group_button.length)
			curSelected = 0;
	}
}
