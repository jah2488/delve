package;

import flixel.effects.FlxFlicker;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

class Slime extends FlxSprite {
	
	var moveTimer:FlxTimer;

	static public inline var timeBetweenSteps = 2;
	static public inline var speed = 10;

	static public inline var LOOT  = 5;
	static public inline var LEVEL = 2;

	var hurtSound:Dynamic;
	function new() {
		super();
		loadGraphic("assets/images/slime.png", true, true, 16, 16);

		health = 5;
		moveTimer = FlxTimer.start(timeBetweenSteps);

		animation.add("Walk", [0,1,2,1,3,2,3], 5, true);
		animation.play("Walk");
		this.color = flixel.util.FlxColor.CHARTREUSE;
		hurtSound = openfl.Assets.getSound("assets/sounds/hurt.wav");
	}

	override public function hurt(damage:Float):Void {
		FlxFlicker.flicker(this, 1.0);
		hurtSound.play();
		super.hurt(damage);
	}

	override public function kill():Void {
		Reg.effects.explode(x, y, loot());
		hurtSound.play();
		super.kill();
	}

	private function loot():Int {
		return Std.random(LOOT * LEVEL);
	}

	override public function update():Void {
		facing = velocity.x > 0 ? FlxObject.RIGHT : FlxObject.LEFT;
		if(moveTimer.finished) {
			if(x > Reg.player.x) { velocity.x -= speed; }
			if(x < Reg.player.x) { velocity.x += speed; }
			if(y > Reg.player.y) { velocity.y -= speed; }
			if(y < Reg.player.y) { velocity.y += speed; }
			moveTimer.reset();
		}
		super.update();
	}
}