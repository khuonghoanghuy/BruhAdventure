package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class MenuState extends MainState
{
	var list:Array<String> = ["play", "setting", "exit"];
	var button:FlxSprite;
	var group_button:FlxTypedGroup<FlxSprite>;
	var curSelected:Int = 0;

	override public function create()
	{
		super.create();

		FlxG.save.bind("data", "assets/data/");

		group_button = new FlxTypedGroup<FlxSprite>();
		add(group_button);

		for (i in 0...list.length)
		{
			var item:FlxSprite = new FlxSprite(0, 0);
			item.loadGraphic(AssetPaths.main_menu__png, true, 24, 16);
			item.animation.add("play", [0]);
			item.animation.add("setting", [1]);
			item.animation.add("exit", [2]);
			item.animation.play("play");
			item.scale.set(3, 3);
			item.screenCenter(Y);
			item.x = 30;
			item.ID = i;
			group_button.add(item);
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

		if (FlxG.keys.justPressed.ENTER)
		{
			switch (list[curSelected])
			{
				case "play":
					FlxG.switchState(new PlayState());

				case "setting":
					FlxG.switchState(new OptionsMenu());

				case "exit":
					FlxG.save.flush();
					Sys.exit(0);
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

		group_button.forEach(function(spr:FlxSprite)
		{
			switch (curSelected)
			{
				case 0:
					spr.ID = 0;
					spr.animation.play("play");

				case 1:
					spr.ID = 1;
					spr.animation.play("setting");

				case 2:
					spr.ID = 2;
					spr.animation.play("exit");
			}

			spr.updateHitbox();
		});
	}
}
