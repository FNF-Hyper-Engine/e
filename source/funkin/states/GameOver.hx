package funkin.states;

import flixel.addons.text.FlxTypeText;

class GameOver extends MusicBeatState
{

	var sound:FlxSound;
	var instant:Bool = true;
	var ass:FlxSound;
	var overChar:FlxTypeText;

	override function create()
	{
		sound = new FlxSound();
		sound.loadEmbedded('assets/sounds/fnf_loss_sfx.ogg', false, true);
		ass = new FlxSound();
		ass.loadEmbedded('assets/music/gameOverEnd.ogg', false, true);

		overChar = new FlxTypeText(500,500,400,'Score: ${PlayState.instance.songScore}',32);
	    overChar.screenCenter();
		overChar.sounds = [FlxG.sound.load('assets/sounds/pixelText.ogg', 0.6)];
		overChar.start(0.1, true);
		//overChar.resetText('Combo: ${PlayState.instance.combo}');
	
		add(overChar);


		super.create();
		sound.play();
		sound.onComplete = function()
		{
			FlxG.sound.playMusic("assets/music/gameOver.ogg");
		
		};

		ass.onComplete = function()
		{
			FlxG.switchState(new funkin.PlayState());
		};
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		#if (!android)
		if (FlxG.keys.justPressed.ENTER && instant)
		{
			exit();
		}
		#else
		if (FlxG.touches.getFirst() != null)
		{
			if (FlxG.touches.getFirst().justPressed)
				exit();
		}
		#end
	}

	public function exit():Void
	{
		instant = false;
		FlxG.sound.music.stop();


		FlxG.camera.fade(FlxColor.WHITE, ass.length / 1000 * 0.5);
		ass.endTime = ass.length * 0.5;
		ass.play();
	}
}
