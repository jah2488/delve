package;

import flixel.group.FlxGroup;
import flixel.effects.particles.FlxEmitter;

class Effects extends FlxGroup {

    private var emitter:FlxEmitter;
	static private inline var EMITTER_SIZE  = 2;
	static private inline var EXPLODE = true;

	var gem:Gem;

	public function new() { 
		super();
	}

	public function explode(x:Float, y:Float, amount:Int = EMITTER_SIZE) {
		emitter = new FlxEmitter(x, y, amount);
		add(emitter);
		for(i in 0...(emitter.maxSize)) {
			gem = new Gem();
			emitter.add(gem);
		}

		emitter.start(EXPLODE);
	}
}

