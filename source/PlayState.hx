package;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
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

	var mapCamera:FlxCamera;

	override public function create():Void
	{
		super.create();

		Reg.init();
		FlxG.cameras.bgColor = 0xff131c1b;
		FlxG.mouse.hide();

		level = new FlxTilemap();
		// level.setCustomTileMappings([0], [1], [[2,3,4]]);
		level.loadMap(Assets.getText("assets/data/empty_room.csv"), "assets/images/delveTiles.png", 16, 16, FlxTilemap.OFF, 0, 1, 20);
		add(level);
		add(Reg.effects);

		player = Reg.player;
		player.x = FlxG.width / 2;
		player.y = FlxG.height / 2;

		enemy = new Slime();
		enemy.x = FlxG.width / 2;
		enemy.y = 50;

		add(enemy);

		add(player);
		add(Reg.projectiles);


		var pad   = 1;
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

        var uiCamera = new FlxCamera(0, 0, FlxG.width, Math.ceil(43 * FlxG.camera.zoom));
        uiCamera.color = flixel.util.FlxColor.AQUAMARINE;
        FlxG.cameras.add(uiCamera);


		// var camera = new FlxCamera(0, 43, FlxG.width, FlxG.height - 43);
		// camera.setBounds(0, 43, FlxG.width, level.height);
		// camera.color = flixel.util.FlxColor.AQUAMARINE;
		// camera.follow(player);
		// camera.style = FlxCamera.STYLE_SCREEN_BY_SCREEN;
		// FlxG.cameras.add(camera);

        FlxG.camera.color = flixel.util.FlxColor.RED;
        FlxG.camera.setPosition(0, 43 * FlxG.camera.zoom);
        FlxG.camera.setBounds(0, 0, level.width, level.height);
        FlxG.camera.follow(player, FlxCamera.STYLE_SCREEN_BY_SCREEN);
	}

	override public function update():Void
	{
		scoreTxt.text  = 'score  ${Reg.score}';
		healthTxt.text = 'health ${Reg.player.health}';
		depthTxt.text  = 'depth  ${Reg.level}';

		FlxG.collide(enemy, level);
		FlxG.overlap(enemy, Reg.projectiles, onHit);

		FlxG.collide(player, level);
		FlxG.overlap(player, Reg.effects, onPickup);
		FlxG.overlap(enemy, player, enemyHitPlayer);

		FlxG.collide(Reg.projectiles, Reg.projectiles, arrowOnArrow);
		FlxG.collide(Reg.projectiles, level, arrowHitWall);
		FlxG.collide(Reg.effects, level);

		super.update();
	}	

	private function enemyHitPlayer(enemyRef:FlxBasic, playerRef:FlxBasic):Void
	{
		player.hurt(1);
	}

	private function onPickup(playerRef:FlxBasic, effectRef:FlxBasic):Void
	{
		var item  = cast(effectRef, Gem);
		var sound = openfl.Assets.getSound("assets/sounds/pickup.wav");
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