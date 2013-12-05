package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

class Arrow extends FlxSprite {


	static public inline var speed = 100;
	public var damage = 1;

	var arrowLife:FlxTimer;
	var boxWidthOffset = 7;

	function new() {
		super();
		loadGraphic("assets/images/arrow.png", true, true, 16, 16);
		exists = false;
		width  = 3;
		offset.x = boxWidthOffset;
        maxVelocity.x   = maxVelocity.y = 500;
        drag.x = drag.y = maxVelocity.y / 4;
        mass = 0.1;

        arrowLife = FlxTimer.start(2, fadeOut);
	}

	private function fadeOut(timer:FlxTimer):Void {
		kill();
	}

	override function kill():Void {
		angle = 0;
		exists = false;
		velocity.x = velocity.y = 0;
		animation.frameIndex = 0;	
		super.kill();
	}

	override function reset(bx:Float, by:Float) {
		angle = 0;
		exists = false;
		velocity.x = velocity.y = 0;
		animation.frameIndex = 0;
		super.reset(bx, by);
	}

	public function fire(bx:Float, by:Float, direction:String):Void {
		x = bx;
		y = by;
		exists = true;
		if(direction == Dir.N || direction == Dir.S) {
			offset.x = boxWidthOffset;
			offset.y = 2;
			height = 14;
			width  = 3;
		} else {
			offset.x = 2;
			offset.y = boxWidthOffset;
			height = 3;
			width  = 14;
		}
		switch (direction) {
			case Dir.N:
				velocity.y -= maxVelocity.y;
				angle = 0;
			case Dir.S:
				velocity.y += maxVelocity.y;
				angle = 180;
			case Dir.E:
				velocity.x += maxVelocity.x;
				angle = 90;
			case Dir.W:
				velocity.x -= maxVelocity.x;
				angle = -90;
			default:
		}
	}


	override public function update():Void {
		super.update();
	}
}