package;

import flixel.group.FlxGroup;

class ProjectileManager extends FlxGroup {

	public function new(poolSize:Int = 50) {
		super();
		for(i in 0...poolSize) {
			add(new Arrow());
		}
	}

	public function fire(bx:Float, by:Float, dir:String):Void {
		if(getFirstAvailable() != null) {
			cast(getFirstAvailable(), Arrow).fire(bx, by, dir);
		}
	}
}