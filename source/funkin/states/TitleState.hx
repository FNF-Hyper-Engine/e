package funkin.states;



class TitleState extends MusicBeatState
{
	#if flxanimate
	var character:FlxAnimate;
	#end

	static var initialized:Bool = false;
	static public var soundExt:String = ".ogg";

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;




	var logo:FunkinSprite;
	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;
	var skippedIntro:Bool = false;

	override public function create()
	{
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

		var loopsleft = 4;

		FlxG.sound.cache('assets/sounds/countdown/funkin/introTHREE.ogg');

		FlxG.sound.cache('assets/sounds/countdown/funkin/introTWO.ogg');

		FlxG.sound.cache('assets/sounds/countdown/funkin/introONE.ogg');

		FlxG.sound.cache('assets/sounds/countdown/funkin/introGO.ogg');

		curWacky = FlxG.random.getObject(getIntroTextShit());

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();

			var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			// bg.antialiasing = false;
			// bg.setGraphicSize(Std.int(bg.width * 0.6));
			// bg.updateHitbox();
			add(bg);

			#if flxanimate
			character = new FlxAnimate(FlxG.width - 580, FlxG.height - 350, 'assets/images/characters/gf');
			character.antialiasing = false;
			character.anim.addBySymbolIndices('left', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], 24, false);
			character.anim.addBySymbolIndices('right', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], 24, false);

			add(character);
			#end

			logo = new FunkinSprite(-150, -100);
			logo.loadGraphic(Paths.image('logo'));
			logo.screenCenter();
			logo.antialiasing = false;
			add(logo);

			credGroup = new FlxGroup();
			add(credGroup);
			textGroup = new FlxGroup();

			blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			credGroup.add(blackScreen);

			credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
			credTextShit.screenCenter();

			// credTextShit.alignment = CENTER;

			credTextShit.visible = false;

			ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic('assets/images/newgrounds_logo.png');
			add(ngSpr);
			ngSpr.visible = false;
			ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
			ngSpr.updateHitbox();
			ngSpr.screenCenter(X);
			ngSpr.antialiasing = false;

			FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

			// FlxG.mouse.visible = false;

			if (initialized)
				skipIntro();
			else
				initialized = true;
		});
	}

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			skippedIntro = true;
		}
	}

	function startIntro()
	{
		persistentUpdate = true;
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText('assets/data/introText.txt');

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var danceLeft:Bool = false;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, 0.95);

		#if (!android)
		if (FlxG.keys.justPressed.ENTER && skippedIntro)
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

		FlxG.log.add(curBeat);

		switch (curBeat)
		{
			case 1:
				createCoolText(['ninjamuffin99', 'phantomArcade', 'kawaisprite', 'evilsk8er']);
			// credTextShit.visible = true;
			case 3:
				addMoreText('present');
			// credTextShit.text += '\npresent...';
			// credTextShit.addText();
			case 4:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = 'In association \nwith';
			// credTextShit.screenCenter();
			case 5:
				createCoolText(['In association', 'with']);
			case 7:
				addMoreText('newgrounds');
				ngSpr.visible = true;
			// credTextShit.text += '\nNewgrounds';
			case 8:
				deleteCoolText();
				ngSpr.visible = false;
			// credTextShit.visible = false;

			// credTextShit.text = 'Shoutouts Tom Fulp';
			// credTextShit.screenCenter();
			case 9:
				createCoolText([curWacky[0]]);
			// credTextShit.visible = true;
			case 11:
				addMoreText(curWacky[1]);
			// credTextShit.text += '\nlmao';
			case 12:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = "Friday";
			// credTextShit.screenCenter();
			case 13:
				addMoreText('Friday');
			// credTextShit.visible = true;
			case 14:
				addMoreText('Night');
			// credTextShit.text += '\nNight';
			case 15:
				addMoreText('Funkin'); // credTextShit.text += '\nFunkin';

			case 16:
				skipIntro();
		}
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}
}
