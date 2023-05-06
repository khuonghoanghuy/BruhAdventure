package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class WinnerState extends MainState
{
	var text:FlxText;

	public function new()
	{
		super(FlxColor.BLACK);

		text = new FlxText(0, 0, 0, "- !Win! -
            \nYou are win, this game still in beta\nWait the update for more level\nPress Enter or Escape to return\nPress R to restart", 16);
		text.screenCenter();
		text.alignment = CENTER;
		add(text);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.anyJustPressed([ESCAPE, ENTER]))
		{
			FlxG.switchState(new MenuState());
		}

		if (FlxG.keys.justPressed.R)
		{
			FlxG.switchState(new PlayState());
		}
	}
}
