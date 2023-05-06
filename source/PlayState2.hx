package;

import PlayState.Stuff;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class PlayState2 extends MainState
{
	var onLevel:Int = 0;

	var bg:FlxSprite;
	var wall:FlxTilemap;
	var map:FlxOgmo3Loader;
	var coin:FlxTypedGroup<Coin>;
	var player:Player;
	var flag:Flags;

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

		map = new FlxOgmo3Loader(AssetPaths.level__ogmo, AssetPaths.level2__json);
		wall = map.loadTilemap(AssetPaths.first_level__png, "tile_set");
		wall.follow();
		wall.setTileProperties(1, NONE);
		wall.setTileProperties(2, ANY);
		add(wall);

		coin = new FlxTypedGroup<Coin>();
		add(coin);

		player = new Player();
		add(player);

		flag = new Flags(1584, 384);
		add(flag);

		map.loadEntities(placeEntities, "entity");

		info_text = new FlxText(0, 0, 0, "", 12);
		info_text.scrollFactor.set();
		add(info_text);

		timeCounter = new FlxText(0, 20, 0, "", 12);
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
				flag.setPosition(1584, 384);
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.camera.follow(player, PLATFORMER);
		FlxG.collide(player, wall);
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
			timeCounter.text = "Time: " + FlxG.elapsed;
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
			PlayState.Stuff.SCORE = 0;
			PlayState.Stuff.WASHIT = 0;
			FlxG.switchState(new SelectLevelState());
		}
	}
}
