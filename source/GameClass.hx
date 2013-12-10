package;

import flash.Lib;
import flixel.FlxGame;
	
class GameClass extends FlxGame
{	

	static public inline var VERSION = "v0.1.1";

	static public inline var WIDTH  = 256;
	static public inline var HEIGHT = 240;
	public function new()
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		
		var ratioX:Float = stageWidth / WIDTH;
		var ratioY:Float = stageHeight / HEIGHT;
		var ratio:Float = Math.min(ratioX, ratioY);
		
		var fps:Int = 60;
		
		super(Math.ceil(stageWidth / ratio), Math.ceil(stageHeight / ratio), MenuState, ratio, fps, fps);
    }

}
