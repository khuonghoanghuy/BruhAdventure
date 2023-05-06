package;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class OptionsMenu extends MainState
{
	var list:Array<String> = ["Run Speed", "Exit"];
	var group_button:FlxTypedGroup<FlxText>;
	var curSelected:Int = 0;

	override public function create()
	{
		group_button = new FlxTypedGroup<FlxText>();
		add(group_button);

		for (i in 0...list.length)
		{
			var optionText:FlxText = new FlxText(20, 300 + (i * 50), 0, list[i], 32);
			optionText.ID = i;
			group_button.add(optionText);
		}

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

		if (FlxG.keys.justPressed.ENTER)
		{
			switch (list[curSelected])
			{
				case "Exit":
					FlxG.save.flush();
					FlxG.switchState(new MenuState());
			}
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.save.flush();
			FlxG.switchState(new MenuState());
		}

		if (FlxG.keys.anyJustPressed([LEFT, A]))
		{
			switch (list[curSelected])
			{
				case "Run Speed":
					FlxG.save.data.runSpeed -= 10;
			}
		}

		if (FlxG.keys.anyJustPressed([RIGHT, D]))
		{
			switch (list[curSelected])
			{
				case "Run Speed":
					FlxG.save.data.runSpeed += 10;
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
