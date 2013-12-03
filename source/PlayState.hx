package;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import openfl.Assets;


class PlayState extends FlxState
{

	var player:FlxSprite;
	var level:FlxTilemap;
	var enemy:FlxSprite;

	override public function create():Void
	{
		Reg.init();
		FlxG.cameras.bgColor = 0xff131c1b;
		FlxG.mouse.hide();
		
		level = new FlxTilemap();
		level.loadMap(Assets.getText("assets/data/empty_room.csv"), "assets/images/dungeon.png", 16, 16, FlxTilemap.OFF, 0, 0, 1);
		add(level);

		player = Reg.player;
		player.x = FlxG.width / 2;
		player.y = FlxG.height / 2;

		enemy = new Slime();
		enemy.x = FlxG.width / 2;
		enemy.y = 20;

		add(enemy);

		add(player);
		add(Reg.projectiles);

        FlxG.camera.setBounds(0, 0, level.width, level.height, true);
        FlxG.camera.style = FlxCamera.STYLE_SCREEN_BY_SCREEN;
        FlxG.camera.follow(player);
		super.create();
	}
	

	override public function destroy():Void
	{
		super.destroy();
	}


	override public function update():Void
	{
		FlxG.collide(enemy, level);
		FlxG.collide(enemy, Reg.projectiles, onHit);
		FlxG.collide(player, level);
		FlxG.collide(Reg.projectiles, Reg.projectiles, arrowOnArrow);
		super.update();
	}	
	private function onHit(enemyRef:FlxBasic, arrowRef:FlxBasic):Void
	{
		cast(enemyRef, Slime).hurt(1);
		cast(arrowRef, Arrow).hurt(1);
	}

	private function arrowOnArrow(targetRef:FlxBasic, otherRef:FlxBasic):Void
	{
		cast(targetRef, Arrow).hurt(1);
	}
}