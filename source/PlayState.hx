package;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import openfl.Assets;


class PlayState extends FlxState
{

	var player:FlxSprite;
	var level:FlxTilemap;
	var enemy:FlxSprite;
	var uiLayer:FlxGroup;
	var scoreTxt:FlxText;
	var healthTxt:FlxText;
	var depthTxt:FlxText;

	var completed = false;
	var room:String;

	var enemies:FlxGroup;

	override public function create():Void
	{

		FlxG.camera.flash(0x000000, 0.5, function() {  });
		super.create();

		Reg.init();
		FlxG.cameras.bgColor = 0xff131c1b;
		FlxG.mouse.hide();

		level = new FlxTilemap();
		var rooms = ["empty", "barricade", "corners", "hallway"];
		room = rooms[Std.random(rooms.length)];
		level.loadMap(Assets.getText('assets/data/${room}.csv'), "assets/images/delveTiles.png", 16, 16, FlxTilemap.OFF, 0, 1, 20);	
		// level.setCustomTileMappings([0], [1], [[2,3,4]]);
		//level.loadMap(Assets.getText("assets/data/empty.csv"), "assets/images/delveTiles.png", 16, 16, FlxTilemap.OFF, 0, 1, 20);
		add(level);
		add(Reg.effects);

		player = Reg.player;
		player.x = FlxG.width / 2;
		player.y = 160;

		var colors = [FlxColor.AQUAMARINE, FlxColor.RED, FlxColor.GREEN, FlxColor.GOLDENROD];
		enemies = new FlxGroup();
	    var enemyCount = Std.int(10/Reg.level) + 2;
		for (i in 2...enemyCount) {
			var e = new Slime();

			e.color = colors[Std.random(colors.length)];

			var ex = 0;
			var ey = 0;

            // Check if enemy position is on a tile?
            // Grab all tiles that are floor and assign from there
			ex = FlxRandom.intRanged(16, FlxG.width - 16);
			ey = FlxRandom.intRanged(16, 160);

			e.x = ex;
			e.y = ey;
			enemies.add(e);
		}

		add(enemies);
		add(player);
		add(Reg.projectiles);


		var pad = 1;
		uiLayer = new FlxGroup();
		var blackDrop = new FlxSprite(0,0);
		blackDrop.makeGraphic(FlxG.width, 48, 0xFF000000);
		scoreTxt  = new FlxText(2,2,100, 'score ${Reg.score}');
		healthTxt = new FlxText(2, scoreTxt.y  + scoreTxt.height  + pad, 100, 'health ${Reg.player.health}');
		depthTxt  = new FlxText(2, healthTxt.y + healthTxt.height + pad, 100, 'level  ${Reg.level}');
		uiLayer.add(blackDrop);
		uiLayer.add(scoreTxt);
		uiLayer.add(healthTxt);
		uiLayer.add(depthTxt);
		uiLayer.setAll("scrollFactor", new flixel.util.FlxPoint(0,0));
		add(uiLayer);

        // level.setPosition(0, 48);
        level.setTileProperties(10, FlxObject.NONE, playerOnStairs, Player);
        FlxG.camera.setBounds(0, 0, level.width, level.height);
        FlxG.camera.follow(player, FlxCamera.STYLE_SCREEN_BY_SCREEN);
        FlxG.log.add(FlxG.width);
        FlxG.log.add(level.width);
        FlxG.log.add(level.widthInTiles);
	}

	override public function update():Void
	{
		scoreTxt.text  = 'score  ${Reg.score}';
		healthTxt.text = 'health ${Reg.player.health}';
		depthTxt.text  = 'depth  ${Reg.level}';

		FlxG.collide(enemies, level);
		FlxG.overlap(enemies, Reg.projectiles, onHit);
		FlxG.overlap(enemies, player, enemyHitPlayer);
		FlxG.collide(player, level);
		FlxG.overlap(player, Reg.effects, onPickup);

		FlxG.collide(Reg.projectiles, Reg.projectiles, arrowOnArrow);
		FlxG.collide(Reg.projectiles, level, arrowHitWall);
		FlxG.collide(Reg.effects, level);

		super.update();
	}	

	private function playerOnStairs(player:FlxObject, level:FlxObject):Void
	{
		if(!completed) {
			completed = true;
			Reg.level += 1;
			FlxG.resetState();
		}
	}

	private function enemyHitPlayer(enemyRef:FlxBasic, playerRef:FlxBasic):Void
	{
		player.hurt(1);
	}

	private function onPickup(playerRef:FlxBasic, effectRef:FlxBasic):Void
	{
		var item  = cast(effectRef, Gem);
		var sound = openfl.Assets.getSound("assets/sounds/pickup.wav");
		var txtG = new FlxGroup(2);
		var txt = new FlxText(player.x, player.y, 40, Std.string(100 * item.level), 7);
		var txs = new FlxText(txt.x + 1, txt.y + 1, 40, txt.text, 7);
		txs.color = FlxColor.BLACK;
		FlxTimer.start(2,   function(flxtimer:FlxTimer) { txt.kill(); txs.kill(); });
		FlxTimer.start(0.1, function(flxtimer:FlxTimer) { txt.alpha -= 0.17;
														  txs.alpha -= 0.17; }, 100);
		FlxTimer.start(0.1, function(flxtimer:FlxTimer) { txt.y     -= 2.10;
														  txs.y     -= 2.10; }, 100);
		txtG.add(txs);
		txtG.add(txt);
		add(txtG);
		sound.play();
		item.kill();
		Reg.score += 100 * item.level;
	}

	private function onHit(enemyRef:FlxBasic, arrowRef:FlxBasic):Void
	{
		var slime = cast(enemyRef, Slime);
		var arrow = cast(arrowRef, Arrow);

		arrow.hurt(1);
		slime.hurt(arrow.damage);
	}

	private function arrowOnArrow(targetRef:FlxBasic, otherRef:FlxBasic):Void
	{
		cast(targetRef, Arrow).hurt(1);
	}

	private function arrowHitWall(arrowRef:FlxBasic, levelRef:FlxBasic):Void 
	{
		var arrow = cast(arrowRef, Arrow);
		arrow.velocity.x = arrow.velocity.y = 0;
		arrow.animation.frameIndex = 1;
		FlxTimer.start(2, function(timer:FlxTimer) { arrow.hurt(99); });
	}
}