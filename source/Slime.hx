package;

import flixel.effects.FlxFlicker;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

class Slime extends FlxSprite {
	
	var moveTimer:FlxTimer;

	static public inline var baseTimeBetweenSteps = 2;
	static public inline var baseSpeed = 10;
	static public inline var baseHealth = 1;

	public var payout = 2;
	public var level  = 1;

	var hurtSound:Dynamic;
	function new() {

		level = Reg.level;
		var levelMod = Math.log(level);

		super();
		loadGraphic("assets/images/slime.png", true, true, 16, 16);

		health = levelMod / 2 + baseHealth;
		moveTimer = FlxTimer.start(Math.abs(baseTimeBetweenSteps - levelMod));

		animation.add("Walk", [0,1,2,1,3,2,3,3,3,0], 5, true);
		animation.play("Walk")	;

		this.color = flixel.util.FlxColor.CHARTREUSE;
		hurtSound = openfl.Assets.getSound("assets/sounds/hurt.wav");

		maxVelocity.x = maxVelocity.y = baseSpeed*5;
		drag.x = drag.y = maxVelocity.x/2;
		width = height = 12;
		offset.x = offset.y = 2;
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
		return Std.random(payout + level) + 1;
	}

	override public function update():Void {
		facing = velocity.x > 0 ? FlxObject.RIGHT : FlxObject.LEFT;
		if(moveTimer.finished) {
			if(x > Reg.player.x) { velocity.x -= baseSpeed; }
			if(x < Reg.player.x) { velocity.x += baseSpeed; }
			if(y > Reg.player.y) { velocity.y -= baseSpeed; }
			if(y < Reg.player.y) { velocity.y += baseSpeed; }
			moveTimer.reset();
		}
		super.update();
	}
}