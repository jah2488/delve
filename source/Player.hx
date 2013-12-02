package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class Player extends FlxSprite {
	
	var speed = 25;
	var direction = Dir.N;

	public function new()
	{
		super();
		this.makeGraphic(16,16, FlxColor.CHARTREUSE);
        maxVelocity.x = 200;
        maxVelocity.y = 200;
        drag.x = maxVelocity.x*3;
        drag.y = maxVelocity.y*3;

	}

	override public function update()
	{

		if(FlxG.keyboard.justPressed("SPACE")) {
			fireArrow();
		}

		if(FlxG.keyboard.pressed("LEFT", "A")) {
			this.velocity.x -= speed;
			direction = Dir.W;
			facing = FlxObject.LEFT;
		}
		if(FlxG.keyboard.pressed("RIGHT", "D")) {
			this.velocity.x += speed;
			direction = Dir.E;
			facing = FlxObject.RIGHT;
		}
		if(FlxG.keyboard.pressed("UP", "W")) {
			this.velocity.y -= speed;
			direction = Dir.N;
			facing = FlxObject.UP;
		}
		if(FlxG.keyboard.pressed("DOWN", "S")) {
			this.velocity.y += speed;
			direction = Dir.S;
			facing = FlxObject.DOWN;
		}

		super.update();
	}

	function fireArrow():Void
	{
		Reg.projectiles.fire(x - 2, y - 2, direction);
	}
}