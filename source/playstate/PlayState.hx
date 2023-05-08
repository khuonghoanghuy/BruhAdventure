package playstate;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class PlayState extends MainState
{
	var onLevel:Int = 0;

	var bg:FlxSprite;
	var wall:FlxTilemap;
	var map:FlxOgmo3Loader;
	var coin:FlxTypedGroup<Coin>;
	var player:Player;
	var flag:FlxTypedGroup<Flags>;
	var trampoline:FlxTypedGroup<Trampoline>;

	var timeCounter:FlxText;

	var info_text:FlxText;
	var ranking:String = "No Hit";

	var justHit_:Bool = false;

	var jumpTimer:Float = 0;
	var jumping:Bool = false;

	override public function create()
	{
		super.create();

		FlxG.save.bind("data", "assets/data/");

		bg = new FlxSprite(0, 0).makeGraphic(640, 480, FlxColor.BLUE);
		bg.screenCenter();
		bg.scrollFactor.set();
		add(bg);

		map = new FlxOgmo3Loader(AssetPaths.level__ogmo, AssetPaths.level1__json);
		wall = map.loadTilemap(AssetPaths.first_level__png, "tile_set");
		wall.follow();
		wall.setTileProperties(1, NONE);
		wall.setTileProperties(2, ANY);
		add(wall);

		coin = new FlxTypedGroup<Coin>();
		add(coin);

		player = new Player();
		add(player);

		flag = new FlxTypedGroup<Flags>();
		add(flag);

		trampoline = new FlxTypedGroup<Trampoline>();
		add(trampoline);

		map.loadEntities(placeEntities, "entity");

		info_text = new FlxText(0, 0, 0, "", 12);
		info_text.scrollFactor.set();
		add(info_text);

		timeCounter = new FlxText(0, 40, 0, "", 12);
		timeCounter.scrollFactor.set();
		add(timeCounter);
	}

	function placeEntities(entity:EntityData)
	{
		var x = entity.x;
		var y = entity.y;

		switch (entity.name)
		{
			case "player":
				player.setPosition(x, y);
				player.acceleration.y = 900;
				player.maxVelocity.y = 300;

			case "coin":
				coin.add(new Coin(x, y));

			case "flag":
				flag.add(new Flags(x, y));

			case "trampoline":
				trampoline.add(new Trampoline(x, y));
		}
	}

	var time:Int = 0;

	override public function update(elapsed:Float)
	{
		time += 1;

		super.update(elapsed);

		FlxG.camera.follow(player, PLATFORMER);
		FlxG.collide(player, wall);
		FlxG.overlap(player, trampoline, trampolineTouch);
		FlxG.overlap(player, coin, touchCoin);
		FlxG.overlap(player, flag, win_yeah);

		if (justHit_)
		{
			Stuff.WASHIT++;
			info_text.color = FlxColor.RED;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				info_text.color = FlxColor.WHITE;
				justHit_ = false;
			});
		}

		info_text.text = "Score: " + Stuff.SCORE + "\nWas Hit: " + Stuff.WASHIT + " (" + ranking + ")";

		if (FlxG.save.data.timeCounter)
		{
			timeCounter.text = "Time: " + time;
		}
		else
		{
			timeCounter.text = "";
		}

		switch (Stuff.WASHIT)
		{
			case 0:
				ranking = "No Hit";

			case 1:
				ranking = "Was Hit";

			case 5:
				ranking = "Clear";
		}

		var up:Bool = FlxG.keys.anyPressed([UP, W]);
		var left:Bool = FlxG.keys.anyPressed([LEFT, A]);
		var right:Bool = FlxG.keys.anyPressed([RIGHT, D]);
		var pause:Bool = FlxG.keys.justPressed.ESCAPE;

		if (pause)
		{
			openSubState(new PauseSubState());
		}

		if (left && right)
			left = right = false;

		// From Haxe Snippests
		if (jumping && !up)
			jumping = false;

		if (player.isTouching(DOWN) && !jumping)
			jumpTimer = 0;

		if (jumpTimer >= 0 && up)
		{
			jumping = true;
			jumpTimer += elapsed;
		}
		else
			jumpTimer = -1;

		if (jumpTimer > 0 && jumpTimer < 0.25)
			player.velocity.y = -300;

		if (left)
			player.velocity.x = -100 * FlxG.save.data.runSpeed;
		else if (right)
			player.velocity.x = 100 * FlxG.save.data.runSpeed;
		else
			player.velocity.x = 0;
	}

	function touchCoin(player:Player, coin:Coin)
	{
		if (player.alive && player.exists && coin.alive && coin.exists)
		{
			coin.kill();
			Stuff.SCORE += 10;
		}
	}

	function win_yeah(player:Player, flag:Flags)
	{
		if (player.alive && player.exists && flag.alive && flag.exists)
		{
			flag.kill();
			#if desktop
			sys.io.File.saveContent("assets/data/data_score/lv1.txt", Std.string(Stuff.SCORE));
			#end
			Stuff.SCORE = 0;
			Stuff.WASHIT = 0;
			FlxG.switchState(new SelectLevelState());
		}
	}

	function trampolineTouch(player:Player, trampoline:Trampoline)
	{
		if (player.alive && player.exists && flag.alive && flag.exists)
		{
			player.velocity.y = -1000;
		}
	}
}
