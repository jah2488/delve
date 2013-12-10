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
import flixel.util.FlxPoint;
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

	var levelCompleted = false;
	var room:String;

	var enemies:FlxGroup;
	var scoreText:ScoreText;

	var chasmTiles:Array<FlxPoint>;

	override public function create():Void
	{

		FlxG.camera.flash(0x000000, 0.5, function(){});
		super.create();

		Reg.init();
		FlxG.cameras.bgColor = 0xff131c1b;
		FlxG.mouse.hide();

		scoreText = new ScoreText();

		level = new FlxTilemap();
		var rooms = ["empty", "barricade", "corners", "hallway"];
		room = rooms[Std.random(rooms.length)];
		level.setCustomTileMappings( [1],
									 [1, 20, 23, 26, 32, 37, 
									     42, 47, 53, 56],
									 [
									  [1,1,1,1,1,1,1,1,1,1,1,1,1,2,3,4,5,6],
									  [20,21],
									  [28,23,23,23], [29,26,26,26],
									  [31,32,32,32], [38,37,37,37],
									  [41,42,42,42], [48,47,47,47],
									  [58,53,53,53], [59,56,56,56]
									 ]);
		level.loadMap(Assets.getText('assets/data/${room}.csv'), "assets/images/delveTiles.png", 16, 16, FlxTilemap.OFF, 0, 1, 20);	
		add(level);
		add(Reg.effects);

		player = Reg.player;
		player.x = FlxG.width / 2;
		player.y = 160;


		enemies = new FlxGroup();
		add(enemies);
		add(player);
		add(Reg.weapon);
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
		add(scoreText);

        level.setTileProperties(10, FlxObject.NONE, playerOnStairs, Player);
        level.setTileProperties(11, FlxObject.ANY);
        level.setTileProperties(21, FlxObject.ANY, Arrow);
        FlxG.camera.setBounds(0, 0, level.width, level.height);
        FlxG.camera.follow(player, FlxCamera.STYLE_SCREEN_BY_SCREEN);

        FlxTimer.start(0.5, function(t:FlxTimer) { spawnEnemies(); });
	}

	override public function update():Void
	{
		scoreTxt.text  = 'score  ${Reg.score}';
		healthTxt.text = 'health ${Reg.player.health}';
		depthTxt.text  = 'depth  ${Reg.level}';

		FlxG.collide(enemies, level);
		FlxG.collide(enemies, enemies);
		FlxG.overlap(enemies, Reg.projectiles, onHit);
		FlxG.overlap(enemies, player, enemyHitPlayer);
		FlxG.collide(player, level);
		FlxG.overlap(player, Reg.effects, onPickup);

		FlxG.overlap(Reg.weapon, enemies, swordHitEnemy);

		FlxG.collide(Reg.projectiles, Reg.projectiles, arrowOnArrow);
		FlxG.collide(Reg.projectiles, level, arrowHitWall);
		FlxG.collide(Reg.effects, level);

		spriteOverChasm(player);
		enemies.members.map(function (f:FlxBasic) { 
			spriteOverChasm(cast(f, Slime)); 
		});
		super.update();
	}	

	private function swordHitEnemy(swordRef:FlxBasic, enemyRef:FlxBasic):Void 
	{
		var enemy = cast(enemyRef, Slime);
		var sword = cast(swordRef, Weapon);

		if(FlxG.pixelPerfectOverlap(sword, enemy)) {
			enemy.hurt(sword.damage);
		}
	}

	private function spriteOverChasm(sprite:FlxSprite):Void {
		for(tile in [level.getTileCoords(13, true), level.getTileCoords(14, true)]) {
			if(tile == null) { break; }
			for(point in tile) {
				if(sprite.getMidpoint().inCoords(point.x - 2, point.y - 4, 2, 4)) {
					FlxTimer.start(0.2, function(t:FlxTimer) { 
						sprite.velocity = new FlxPoint(0,0);
						if(sprite.alive) {
							if(sprite.scale.x > 0.005) { 
								sprite.scale.x -= 0.05;
								sprite.scale.y -= 0.05;
							} else { 
								if(Type.getClass(sprite) == Player) {

								} else {
									sprite.kill(); 
								}
							}
							sprite.angle += 25;
						}
					}, 25);
				}
			}
		}
	}

	private function spawnEnemies():Void
	{
		var colors = [FlxColor.AQUAMARINE, FlxColor.RED, FlxColor.GREEN, FlxColor.GOLDENROD];
	    var enemyCount = Std.int(20/Reg.level) + (1 * FlxRandom.intRanged(0,2));
		for (i in 1...enemyCount) {
			var e = new Slime();

			e.color = colors[Std.random(colors.length)];

        	var floorTiles = level.getTileCoords(01, false);
        	var location = floorTiles[Std.random(floorTiles.length)];
			e.x = location.x;
			e.y = location.y;
			enemies.add(e);
		}	
	}

	private function playerOnStairs(player:FlxObject, level:FlxObject):Void
	{
		if(!levelCompleted) {
			levelCompleted = true;
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
		var score = 100 * item.level;
		var msg   = Std.string(score);

		if(scoreText.visible) {
			msg = Std.string(Std.parseInt(scoreText.getText()) + score);
		}
		scoreText.place(player.x, player.y, msg);
		sound.play();
		item.kill();
		Reg.score += score;
	}

	private function onHit(enemyRef:FlxBasic, weaponRef:FlxBasic):Void
	{
		var slime = cast(enemyRef, Slime);
		var weapon = cast(weaponRef, Arrow);

		var hurtText = new ScoreText();
		hurtText.color(FlxColor.RED);
		weapon.hurt(1);
		var tx = slime.getMidpoint().x + FlxRandom.intRanged(-6,6);
		var ty = slime.getMidpoint().y + FlxRandom.intRanged(-4,4);
		hurtText.place(tx, ty, Std.string(weapon.damage));
		slime.hurt(weapon.damage);
		add(hurtText);
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