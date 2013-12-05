package;

import flixel.FlxSprite;
import flixel.effects.particles.FlxParticle;

class Gem extends FlxParticle
{
	public var level = 1;

	public function new()
	{
		super();
		loadGraphic("assets/images/gem.png", true, true, 16, 16);
		animation.add("flicker", [0,0,0,0,0,0,0,2,1], 8, true);
		width  = 12;
		height = 12;
		offset.x = offset.y = 2;
	}

	override public function update():Void {
		if(x > Reg.player.x) x -= 0.1;
		if(x < Reg.player.x) x += 0.1;
		if(y < Reg.player.y) y += 0.1;
		if(y > Reg.player.y) y -= 0.1;
		super.update();
	}

	override public function onEmit():Void
	{
		color = 0xFFF2B121;//NESGOLD;
		acceleration.y = 100;
		elasticity = 0.8;
		drag.x = drag.y = 10000;
		animation.play("flicker");
		super.onEmit();
	}
}