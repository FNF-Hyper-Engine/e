package funkin.states;

class TitleState extends MusicBeatState
{
	#if flxanimate
	var character:FlxAnimate;
	#end

	override public function create()
	{
		#if flxanimate
		character = new FlxAnimate(FlxG.width - 580, FlxG.height - 350, 'assets/images/characters/gf');
		character.antialiasing = true;
		character.anim.addBySymbolIndices('left', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], 24, false);
		character.anim.addBySymbolIndices('right', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], 24, false);

		add(character);
		#end
		Conductor.changeBPM(102);
		FlxG.sound.playMusic('assets/music/freakyMenu.ogg');

		var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
		diamond.persist = true;
		diamond.destroyOnNoUse = false;

		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
			new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1), {asset: diamond, width: 32, height: 32},
			new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		super.create();
	}

	var danceLeft:Bool = false;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, 0.95);

		#if (!android)
		if (FlxG.keys.justPressed.ENTER)
		{
			FlxG.sound.music.stop();
			FlxG.sound.music.time = 0;
			FlxTransitionableState.skipNextTransIn = true;
			FlxG.switchState(new PlayState());
		}
		#end
	}

	override function beatHit()
	{
		super.beatHit();
		#if flxanimate
		if (character != null)
		{
			danceLeft = !danceLeft;
			if (danceLeft)
				character.anim.play('left', true);
			else
				character.anim.play('right', true);
			super.beatHit();
			FlxG.camera.zoom += 0.05;
		}
		#end
	}
}
