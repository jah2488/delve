package;

import flixel.effects.FlxFlicker;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

class Slime extends FlxSprite {
	
	var moveTimer:FlxTimer;

	static public inline var timeBetweenSteps = 2;
	static public inline var speed = 5;

	function new() {
		super();
		this.makeGraphic(16,16, flixel.util.FlxColor.AZURE);

		health = 5;
		moveTimer = FlxTimer.start(timeBetweenSteps);
	}

	override public function hurt(damage:Float):Void {
		FlxFlicker.flicker.bind(this, 1.0);
		super.hurt(damage);
	}

	override public function update():Void {
		if(moveTimer.finished) {
			if(x > Reg.player.x) { x -= speed; }
			if(x < Reg.player.x) { x += speed; }
			if(y > Reg.player.y) { y -= speed; }
			if(y < Reg.player.y) { y += speed; }
			moveTimer.reset();
		}

	}
}