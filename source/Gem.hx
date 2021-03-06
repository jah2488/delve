package;

import flixel.FlxSprite;
import flixel.effects.particles.FlxParticle;

class Gem extends FlxParticle
{
	public var level = 1;
	var attractionSpeed = 01;

	public function new()
	{
		super();
		loadGraphic("assets/images/objects/orb1.png", true, true, 16, 16);
		animation.add("flicker", [0,0,0,0,0,0,0,2,1], 8, true);
		width  = 10;
		height = 10;
		offset.x = 2;
		offset.y = 7;
	}

	override public function update():Void {
		if(x > Reg.player.x) acceleration.x -= attractionSpeed;
		if(x < Reg.player.x) acceleration.x += attractionSpeed;
		if(y < Reg.player.y) acceleration.y += attractionSpeed;
		if(y > Reg.player.y) acceleration.y -= attractionSpeed;
		super.update();
	}

	override public function onEmit():Void
	{
//		color = 0xFFF2B121;//NESGOLD;
		scale.x = scale.y = 0.75;
		acceleration.y = 100;
		elasticity = 0.8;
		drag.x = drag.y = 10000;
		animation.play("flicker");
		super.onEmit();
	}
}