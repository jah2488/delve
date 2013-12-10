package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;

class ScoreText extends FlxGroup {
	
	var text:FlxText;
	var shadow:FlxText;
	var lifeTimer:FlxTimer;
	public var lifetime = 3;

	public function new(msg = "", fontSize = 7) {
		super();
		text   = new FlxText(0,0, 50, msg, fontSize);
		shadow = new FlxText(0,0, 50, msg, fontSize);
		shadow.color = 0x00000000;

		this.add(shadow);
		this.add(text);
	}

	public function color(c:Int):Void {
		text.color = c;
	}

	public function getText():String {
		return text.text;
	}
	public function setText(msg:String):Void {
		text.text = shadow.text = msg;
	}

	public function place(x:Float, y:Float, msg:String) {
		visible = true;
		text.text = shadow.text = msg;
		text.x = x;
		text.y = y;
		shadow.x = text.x + 1;
		shadow.y = text.y + 1;
		text.alpha = shadow.alpha = x;
		lifeTimer = FlxTimer.start(lifetime, function(timer:FlxTimer) { visible = false; });
	}

	override public function update():Void {
		if(visible) {
			var floatAmount = 12.0 + FlxRandom.intRanged(-2, 3);
			var fadeAmount  = 1.00;
			text.alpha   -= fadeAmount  * FlxG.elapsed;
			shadow.alpha -= fadeAmount  * FlxG.elapsed;
			text.y       -= floatAmount * FlxG.elapsed;
			shadow.y     -= floatAmount * FlxG.elapsed;
		}

		if(text.alpha < 0.20) visible = false;
		super.update();
	}
}