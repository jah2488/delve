package;

import flixel.FlxSprite;
import flixel.util.FlxTimer;

class Arrow extends FlxSprite {


	static public inline var speed = 100;
	function new() {
		super();
		loadGraphic("assets/images/arrow.png", true, true, 16, 16);
		exists = false;
		width  = 3;
		this.offset.x = 8;
        maxVelocity.x = 1000;
        maxVelocity.y = 1000;
        drag.x = maxVelocity.x*3;
        drag.y = maxVelocity.y*3;

        FlxTimer.start(5, fadeOut);
	}

	private function fadeOut(timer:FlxTimer):Void{
		kill();
	}

	public function fire(bx:Float, by:Float, direction:String):Void {
		x = bx;
		y = by;
		exists = true;
		switch (direction) {
			case Dir.N:
				velocity.y -= maxVelocity.y;
			case Dir.NE:
				velocity.y -= maxVelocity.y;
				velocity.x += maxVelocity.x;
				angle = 45;
			case Dir.E:
				velocity.x += maxVelocity.x;
				angle = 90;
			case Dir.SE:
			case Dir.S:
				velocity.y += maxVelocity.y;
				angle = 180;
			case Dir.SW:
			case Dir.W:
				velocity.x -= maxVelocity.x;
				angle = -90;
			case Dir.NW:
			default:
		}
	}


	override public function update():Void {
		super.update();
	}
}