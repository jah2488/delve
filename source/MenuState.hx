package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;


class MenuState extends FlxState
{
    var buttons:Array<Array<Dynamic>>;
    var buttonArrow:FlxSprite;
    var currentButton:FlxButton;
    var buttonSelector:Int = 0;	
    var buttonPadding = 5;

	override public function create():Void
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		FlxG.mouse.hide();

	    var title = new FlxText(0, FlxG.height * 0.1, FlxG.width, En.title, 30);
	    title.alignment = "center";
	    add(title);

        buttons = new Array<Array<Dynamic>>();

        var startButton = new FlxButton(FlxG.width / 2, FlxG.height * 0.4, En.start, loadGame);
        startButton.makeGraphic(Math.ceil(startButton.width), Math.ceil(startButton.height), 0x00000000);
        startButton.label.color = FlxColor.WHITE;
        startButton.x -= startButton.width / 2;		

        buttons.push([startButton, loadGame]);
        currentButton = buttons[buttonSelector][0];
	    for(button in buttons) { add(button[0]); }

	    buttonArrow = new FlxSprite();
	    buttonArrow.loadGraphic(Graphic.arrow, false, false, 8, 8);
        buttonArrow.x = currentButton.x - 8;
        buttonArrow.y = currentButton.y + buttonPadding;
        add(buttonArrow);


        var versionText = new FlxText(10, FlxG.height - 20, 50, GameClass.VERSION, 8);
        add(versionText);
		super.create();
	}

	function loadGame():Void
	{
		FlxG.switchState(new PlayState());
	}
	
	override public function update():Void
	{

	    var currentMethod = buttons[buttonSelector][1];

	    buttonArrow.y = currentButton.y + buttonPadding;

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