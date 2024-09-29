package funkin.states;

class GameOver extends MusicBeatState
{
	var overChar:Character;
	var sound:FlxSound;
	var instant:Bool = true;
	var ass:FlxSound;

	override function create()
	{
		sound = new FlxSound();
		sound.loadEmbedded('assets/sounds/fnf_loss_sfx.ogg', false, true);
		ass = new FlxSound();
		ass.loadEmbedded('assets/music/gameOverEnd.ogg', false, true);
		overChar = new Character('deadbf');
		add(overChar);

		super.create();
		sound.play();
		sound.onComplete = function()
		{
			FlxG.sound.playMusic("assets/music/gameOver.ogg");
			overChar.playAnim('loop');
		};

		ass.onComplete = function()
		{
			FlxG.switchState(new funkin.PlayState());
		};
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		overChar.x = FlxMath.lerp((FlxG.width - overChar.width) / 2, overChar.x, 0.95);
		overChar.y = FlxMath.lerp((FlxG.height - overChar.height) / 2, overChar.y, 0.95);
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

		overChar.playAnim('confirm');
		FlxG.camera.fade(FlxColor.BLACK, ass.length / 1000 * 0.5);
		ass.endTime = ass.length * 0.5;
		ass.play();
	}
}
