package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;

import flash.Lib;
import flash.net.URLRequest;
import haxe.Http;

class GameOverState extends FlxState {
    var buttons:Array<Array<Dynamic>>;
    var currentButton:FlxButton;
    var buttonSelector:Int = 0;	
    var buttonPadding = 5;

	override public function create():Void
	{
		FlxG.cameras.bgColor = 0xff444444;
		FlxG.mouse.show();

	    var title = new FlxText(0, FlxG.height * 0.1, FlxG.width, "GAME OVER", 30);
	    title.alignment = "center";
	    add(title);

        buttons = new Array<Array<Dynamic>>();

        var startButton = new FlxButton(FlxG.width / 2, FlxG.height * 0.4, "Play Again", loadGame);
        startButton.makeGraphic(Math.ceil(startButton.width), Math.ceil(startButton.height), 0x00000000);
        startButton.label.color = FlxColor.WHITE;
        startButton.x -= startButton.width / 2;		

        var shareButtontw = new FlxButton(FlxG.width / 2, startButton.y + 45, "Twitter", twShare);
        shareButtontw.makeGraphic(Math.ceil(shareButtontw.width), Math.ceil(shareButtontw.height), 0x00000000);
        shareButtontw.label.color = FlxColor.WHITE;
        shareButtontw.x -= shareButtontw.width / 2;		

        buttons.push([startButton, loadGame]);
        buttons.push([shareButtontw, twShare]);
        currentButton = buttons[buttonSelector][0];
	    for(button in buttons) { add(button[0]); }

		super.create();
	}

	function loadGame():Void
	{
		FlxG.switchState(new PlayState());
	}

	function twShare():Void {
		var link  = "http://justinherrick.com/games/delve";
		var tweet = 'I survived ${Std.string(Reg.level)} level\'s in Delve.\n ${link}  #NESjam #1gam #gamedev +@jah2488';
		var url   = StringTools.urlEncode('https://twitter.com/home?status=${tweet}');
		Lib.getURL(new URLRequest('http://twitter.com/intent/tweet?text=${StringTools.urlEncode(tweet)}'));
	}
	
	override public function update():Void
	{

	    var currentMethod = buttons[buttonSelector][1];


	    if(FlxG.keyboard.justReleased("TAB", "J", "DOWN")) { 
	      // FlxG.sound.play(Audio.Beep, 0.4);
	      if(buttonSelector == buttons.length - 1) { buttonSelector  = 0; }
	      else                                     { buttonSelector += 1; }
	    }
	    if(FlxG.keyboard.justReleased("UP", "K")) {
	      // FlxG.sound.play(Audio.Beep, 0.4);
	      if(buttonSelector == 0) { buttonSelector  = buttons.length - 1; }
	      else                    { buttonSelector -= 1; }     
	    }
	    if(FlxG.keyboard.justReleased("ENTER")) { Reflect.callMethod(null, currentMethod, []); }

		super.update();
	}	

	override public function destroy():Void
	{
		super.destroy();
	}	
}