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
	var text:FlxText;

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

		text = new FlxText(0, 20, 0, "", 12);
		text.scrollFactor.set();
		add(text);

		super.create();

		change();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		switch (list[curSelected])
		{
			case "Run Speed":
				text.text = "" + FlxG.save.data.runSpeed;

			default:
				text.text = "";
		}

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
					FlxG.save.bind("data", "assets/data/");
			}
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.save.flush();
			FlxG.switchState(new MenuState());
			FlxG.save.bind("data", "assets/data/");
		}

		if (FlxG.keys.anyJustPressed([LEFT, A]))
		{
			switch (list[curSelected])
			{
				case "Run Speed":
					if (FlxG.save.data.runSpeed == 1)
					{
						FlxG.save.data.runSpeed -= 0;
					}
					else
					{
						FlxG.save.data.runSpeed -= 1;
					}
			}
		}

		if (FlxG.keys.anyJustPressed([RIGHT, D]))
		{
			switch (list[curSelected])
			{
				case "Run Speed":
					if (FlxG.save.data.runSpeed == 10)
					{
						FlxG.save.data.runSpeed += 0;
					}
					else
					{
						FlxG.save.data.runSpeed += 1;
					}
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

		switch (list[curSelected])
		{
			case "Run Speed":
				text.text = "" + FlxG.save.data.runSpeed;

			default:
				text.text = "";
		}

		group_button.forEach(function(txt:FlxText)
		{
			txt.color = FlxColor.WHITE;

			if (txt.ID == curSelected)
				txt.color = FlxColor.YELLOW;
		});
	}
}
