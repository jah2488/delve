package;

import flixel.effects.FlxFlicker;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class Player extends FlxSprite {
	
	var speed = 15;
	var direction = Dir.N;

	public function new()
	{
		super();
		health = 6;

		loadGraphic("assets/images/pink.png", true, false, 16, 16, true);

        maxVelocity.x = maxVelocity.y = 100;
        drag.x = maxVelocity.x*5;
        drag.y = maxVelocity.y*5;

        width  = 12;
        height = 14;
        offset.x = 2.5;
        offset.y = 1.5;

        direction = Dir.N;
        facing = FlxObject.UP;

        var walkSpeed = 6;

        animation.add("idle",           [0,1], 1, true);
        animation.add("walk-left",      [6,7], walkSpeed, true);
        animation.add("walk-right",     [8,9], walkSpeed, true);
        animation.add("walk-down",    [0,1,2], walkSpeed, true);
        animation.add("walk-up",      [4,3,5], walkSpeed, true);
        animation.play("idle");
	}

	override public function hurt(damage:Float):Void {
		if(FlxFlicker.isFlickering(this)) return;
		FlxFlicker.flicker(this, 1.0);
		openfl.Assets.getSound("assets/sounds/hurt.wav").play();
		super.hurt(damage);
	}

	override public function kill():Void {
		FlxG.switchState(new GameOverState());
	}


	override public function update()
	{
	    animation.pause();

		if(FlxG.keyboard.justPressed("SPACE")) {
			fireArrow();
		}

		if(FlxG.keyboard.justPressed("SHIFT", "E")) {
			swingSword();
		} else if(FlxG.keyboard.pressed("LEFT", "A")) {
			this.velocity.x -= speed;
			direction = Dir.W;
			facing = FlxObject.LEFT;
			animation.play("walk-right");
		} else if(FlxG.keyboard.pressed("RIGHT", "D")) {
			this.velocity.x += speed;
			direction = Dir.E;
			facing = FlxObject.RIGHT;
			animation.play("walk-left");
		} else if(FlxG.keyboard.pressed("UP", "W")) {
			this.velocity.y -= speed;
			direction = Dir.N;
			facing = FlxObject.UP;
			animation.play("walk-up");
		} else if(FlxG.keyboard.pressed("DOWN", "S")) {
			this.velocity.y += speed;
			direction = Dir.S;
			facing = FlxObject.DOWN;
			animation.play("walk-down");
		} else {
		}

		var dis = 4;
		var correction = 0.1;
		if(velocity.x != 0) {
			if(x % 32 < dis /2) x += correction;
			if(x % 32 > dis *2) x -= correction;
		}

		if(velocity.y != 0) {
			if(y % 32 < dis /2) y += correction;
			if(y % 32 > dis *2) y -= correction;
		}

		super.update();
	}

	function swingSword():Void {
		if(direction == Dir.N)
			Reg.swingSword(x - width * 0.8, y - height * 1.65, -90);
		if(direction == Dir.E)
			Reg.swingSword(x + width, y - height * 1.4, 0);
	 	if(direction == Dir.S)
			Reg.swingSword(x + width * 0.8, y + 5, 90);
		if(direction == Dir.W)
			Reg.swingSword(x - width * 1.3, y, 180);
	}

	function fireArrow():Void
	{
		Reg.projectiles.fire(x + width / 2, y + height / 4, direction);
		openfl.Assets.getSound("assets/sounds/arrow.wav").play();

	}
}