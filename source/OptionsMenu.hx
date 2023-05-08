package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class OptionsMenu extends MainState
{
	var list:Array<String> = ["Run Speed", #if !flash "FPS Counter", "FPS Cap", #end "Exit"];
	var group_button:FlxTypedGroup<FlxText>;
	var curSelected:Int = 0;
	var text:FlxText;

	override public function create()
	{
		var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(640, 480, FlxColor.BLUE);
		bg.screenCenter();
		bg.scrollFactor.set();
		add(bg);

		showText(true);

		group_button = new FlxTypedGroup<FlxText>();
		add(group_button);

		for (i in 0...list.length)
		{
			var optionText:FlxText = new FlxText(20, 20 + (i * 50), 0, list[i], 32);
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

			case "FPS Counter":
				text.text = "" + FlxG.save.data.fpsCounter;

			case "FPS Cap":
				text.text = "" + FlxG.save.data.fpsCap;

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

				case "FPS Counter":
					FlxG.save.data.fpsCounter = !FlxG.save.data.fpsCounter;
					text.text = "" + FlxG.save.data.fpsCounter;
					FlxG.save.data.fpsCounter = FlxG.save.data.fpsCounter;
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
					if (FlxG.save.data.runSpeed == 0)
					{
						FlxG.save.data.runSpeed -= 0;
					}
					else
					{
						FlxG.save.data.runSpeed -= 1;
					}

				case "FPS Cap":
					if (FlxG.save.data.fpsCap == 60)
					{
						FlxG.save.data.fpsCap -= 0;
					}
					else
					{
						FlxG.save.data.fpsCap -= 10;
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

				case "FPS Cap":
					if (FlxG.save.data.fpsCap == 120)
					{
						FlxG.save.data.fpsCap += 0;
					}
					else
					{
						FlxG.save.data.fpsCap += 10;
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

			case "FPS Counter":
				text.text = "" + FlxG.save.data.fpsCounter;

			case "FPS Cap":
				text.text = "" + FlxG.save.data.fpsCap;

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
