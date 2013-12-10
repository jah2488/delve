package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;

class Weapon extends FlxSprite {

	public var damage = 1;

	public function new()
	{
		super();
		loadGraphic("assets/images/sword.png", true, true, 16, 32, true);
		animation.add("swing", [0,1,2,3], 20, false);
		visible = false;
	}


	public function place(x:Float, y:Float, angle:Int = 0):Void
	{
		this.revive();
		this.x = x;
		this.y = y;
		this.angle = angle;
		visible = true;
		animation.play("swing");
	}

	override public function update():Void {
		super.update();

		if(animation.frameIndex == 3) {
			kill();
		}
	}

}
