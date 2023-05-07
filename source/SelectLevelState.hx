package;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class SelectLevelState extends MainState
{
	var list:Array<String> = [
		"Level 1",
		"Level 2",
		"Level 3",
		"Level 4",
		"Level 5",
		"Level 6",
		"Level 7",
		"Exit"
	];
	var group_button:FlxTypedGroup<FlxText>;
	var curSelected:Int = 0;

	override public function create()
	{
		super.create();

		group_button = new FlxTypedGroup<FlxText>();
		add(group_button);

		showText(true);

		for (i in 0...list.length)
		{
			var optionText:FlxText = new FlxText(20, 20 + (i * 50), 0, list[i], 32);
			optionText.ID = i;
			group_button.add(optionText);
		}

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

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(new MenuState());
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			switch (list[curSelected])
			{
				case "Level 1":
					FlxG.switchState(new PlayState());

				case "Level 2":
					FlxG.switchState(new PlayState2());

				case "Level 3":
					FlxG.switchState(new PlayState3());

				case "Level 4":
					FlxG.switchState(new PlayState4());

				case "Level 5":
					FlxG.switchState(new PlayState5());

				case "Level 6":
					FlxG.switchState(new PlayState6());

				case "Level 7":
					FlxG.switchState(new PlayState7());

				case "Exit":
					FlxG.switchState(new MenuState());
			}
		}
	}

	function change(change:Int = 0)
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = group_button.length - 1;
		if (curSelected >= group_button.length)
			curSelected = 0;

		group_button.forEach(function(txt:FlxText)
		{
			txt.color = FlxColor.WHITE;

			if (txt.ID == curSelected)
				txt.color = FlxColor.YELLOW;
		});
	}
}
