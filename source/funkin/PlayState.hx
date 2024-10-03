package funkin;

import funkin.scripting.HScript;

class PlayState extends MusicBeatState
{
	var cpuStrums:StrumLine;
	var playerStrums:StrumLine;

	public static var instance:PlayState;

	public var pixelZoom:Float = 6.0;

	var camPos:FlxPoint;

	public var camFollow:FlxObject;

	public static var prevCamFollow:FlxObject;

	public var notes:FlxTypedGroup<Note>;

	public var startingSong:Bool = false;
	public var startedCountdown:Bool = false;

	public var vocals:FlxSound;

	public static var SONG:SwagSong;

	public var progressDial:FlxPieDial;

	public static var middleScroll:Bool = false;

	public static var downScroll:Bool = false;

	public var unspawnNotes:Array<Note> = [];

	public var coolSections:Array<Bool> = [];

	public var coolAnims:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];

	public var defaultCamZoom:Float = 0.9;
	public var health:Float = 1;
	public var combo:Int = 0;
	public var gfSpeed:Int = 0;

	public var healthBar:FlxBar;

	public static var botplay:Bool = false;

	var textidk:FlxText;
	var scoreTxt:FlxText;

	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;

	public var bf:Character;
	public var gf:Character;
	public var dad:Character;

	var camGame:FlxCamera;
	var camHUD:FlxCamera;
	var uiGroup:FlxTypedGroup<FlxBasic>;
	var curStage:String = 'default';

	public var scripts:Array<HScript>;

	var songScore:Int = 0;

	override public function create()
	{
		instance = this;

		if (SONG == null)
			SONG = Song.loadFromJson('dadbattle-hard', 'dadbattle');

		scripts = new Array<HScript>();
		if (Assets.exists('assets/data/${SONG.song.toLowerCase()}.hx'))
		{
			//	var hscript:HScript = new HScript('assets/data/${SONG.song.toLowerCase()}.hx', '${SONG.song.toLowerCase()}.hx');
			//	scripts.push(hscript);
		}
		recursiveLoop();

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		// StageManager.reset();
		StageManager.init(SONG.song.toLowerCase().trim(), camGame);
		add(StageManager.stageBack);

		uiGroup = new FlxTypedGroup();
		uiGroup.cameras = [camHUD];
		add(uiGroup);

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);
		FlxCamera.defaultCameras = [camGame];

		call('onCreate');
		presongLoad();
		// Conductor.songPosition = -Conductor.crochet  * 5;
		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		for (strums in [playerStrums, cpuStrums])
		{
			strums.scrollSpeed = SONG.speed;
		}

		var noteData:Array<SwagSection>;

		var songData = SONG;

		// NEW SHIT
		noteData = songData.notes;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);
				var height:Float = 0;
				for (susNote in 0...Math.floor(susLength))
				{
					var count:Int = Math.round(susLength);
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					height += sustainNote.height;
					sustainNote.mustPress = gottaHitNote;
					sustainNote.offset.x -= sustainNote.width;
					if (downScroll == false)
						sustainNote.offset.y -= 2.5;
					else
						sustainNote.offset.y += 2.5;
					sustainNote.makeGraphic(1, 1);
					sustainNote.visible = false;
					unspawnNotes.push(sustainNote);
				}

				var actualNote:Note = new Note(daStrumTime + 50, daNoteData, oldNote, true);
				actualNote.height = height;
				actualNote.mustPress = gottaHitNote;
				actualNote.ID = swagNote.ID;
				actualNote.setGraphicSize(Note.swagWidth / 2, Std.int(height));
				actualNote.updateHitbox();
				actualNote.offset.x -= actualNote.width / 2;
				actualNote.offset.y -= 2.5;
				actualNote.scale.x = 0.7;
				actualNote.y += actualNote.height;

				var s:Note = new Note(actualNote.strumTime + (Conductor.stepCrochet * Math.floor(susLength)) - 10, daNoteData, oldNote, true);
				s.sustainLength = songNotes[2];
				s.scrollFactor.set(0, 0);
				s.mustPress = gottaHitNote;
				s.isSustainNote = true;
				s.playAnim('${s.noteData}end');
				s.offset.x -= s.width * 1.1;
				s.offset.y += 7;
				// s.scale.y = 1;
				if (susLength > 0)
				{
					unspawnNotes.push(actualNote);
					function sortByShit(Obj1:Note, Obj2:Note):Int
					{
						return sortNotes(FlxSort.ASCENDING, Obj1, Obj2);
					}

					function sortNotes(order:Int = FlxSort.ASCENDING, Obj1:Note, Obj2:Note)
					{
						return FlxSort.byValues(order, Obj1.strumTime, Obj2.strumTime);
					}
					unspawnNotes.push(s);
				}
				swagNote.mustPress = gottaHitNote;
				// trace(section.mustHitSection);
				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else {}
			}
			daBeats += 1;
		}

		//////////////////////trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);
		// trace(coolSections);

		postCrap();

		call('onCreatePost');

		super.create();
		startCountdown();
	}

	function recursiveLoop(directory:String = "./mods/globalScripts/")
	{
		#if sys
		if (sys.FileSystem.exists(directory))
		{
			trace("directory found: " + directory);
			for (file in sys.FileSystem.readDirectory(directory))
			{
				var path = haxe.io.Path.join([directory, file]);
				if (!sys.FileSystem.isDirectory(path))
				{
					if (path.endsWith('.hx'))
					{
						var hscript:HScript = new HScript(path, 'path', true);
						scripts.push(hscript);
					}

					// do something with file
				}
				else
				{
					var directory = haxe.io.Path.addTrailingSlash(path);
					trace("directory found: " + directory);
					recursiveLoop(directory);
				}
			}
		}
		else
		{
			trace('"$directory" does not exist');
		}
		#end
	}

	function postCrap()
	{
		iconP1 = new HealthIcon(bf.jsonFile.healthIcon, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		uiGroup.add(iconP1);

		iconP2 = new HealthIcon(dad.jsonFile.healthIcon, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		uiGroup.add(iconP2);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
	}

	function shitConversion(slicefart:String)
	{
		while (!slicefart.endsWith("}"))
		{
			slicefart = slicefart.substr(0, slicefart.length - 1);
			// LOL GOING THROUGH THE BULLSHIT TO CLEAN IDK WHATS STRANGE
		}

		return Song.parseJSONshit(slicefart);
	}

	function startCountdown(skin:String = 'funkin')
	{
		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.inst(SONG.song.toLowerCase(), 'Voices'));
		else
			vocals = new FlxSound();

		var ct:CountdownHandler;
		ct = new CountdownHandler(startSong);
		uiGroup.add(ct);
		startingSong = true;
		startedCountdown = true;
		ct.startass();
	}

	function startSong():Void
	{
		startingSong = false;
		FlxG.sound.playMusic(Paths.inst(SONG.song.toLowerCase()), 1, false);
		FlxG.sound.music.onComplete = songEnd;
		FlxG.sound.music.pitch = 1;
		vocals.play();
	}

	function songEnd():Void
	{
		remove(cpuStrums.notes);
		remove(playerStrums.notes);

		camGame.fade(FlxColor.BLACK, 1);
		camHUD.fade(FlxColor.BLACK, 1);
		FlxTween.tween(this, {defaultCamZoom: 1.5});
		new FlxTimer().start(1, function(FlxTime:FlxTimer)
		{
			FlxG.switchState(new funkin.states.MainMenuState());
		});
	}

	override function destroy()
	{
		vocals.stop();
		vocals.destroy();
		FlxG.sound.music.stop();
		FlxG.sound.music.kill();
		FlxG.sound.music.destroy();
		StageManager.reset();

		super.destroy();
	}

	override public function update(elapsed:Float)
	{
		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 2000)
			{
				var dunceNote:Note = unspawnNotes[0];
				if (dunceNote.mustPress)
					playerStrums.notes.add(dunceNote);
				else
					cpuStrums.notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		vocals.volume = FlxG.sound.music.volume;

		call('onUpdate', elapsed);

		keyShit(elapsed);

		camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		camGame.zoom = FlxMath.lerp(1, camGame.zoom, 0.95);

		if (health > 2)
			health = 2;
		else if (health < 0)
			health = 0;

		if (playerStrums != null)
			playerStrums.botStrum = botplay;

		var secs = Conductor.songPosition / 1000;
		var length = FlxG.sound.music.length / 1000;

		scoreTxt.text = 'Current Scripts Running: ${scripts.length}';

		super.update(elapsed);

		if (healthBar.percent < 5)
		{
			FlxTransitionableState.skipNextTransOut = true;
			FlxTransitionableState.skipNextTransIn = true;
			FlxG.switchState(new GameOver());
		}

		//////////////////////trace(getSongPercent(Conductor.songPosition, FlxG.sound.music.endTime));
		if (iconP1 != null && iconP2 != null)
		{
			var mult:Float = FlxMath.lerp(1, iconP1.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
			iconP1.scale.set(mult, mult);
			iconP1.updateHitbox();
	
			var mult:Float = FlxMath.lerp(1, iconP2.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
			iconP2.scale.set(mult, mult);
			iconP2.updateHitbox();
	
			var iconOffset:Int = 26;
	
			iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) + (150 * iconP1.scale.x - 150) / 2 - iconOffset;
			iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (150 * iconP2.scale.x) / 2 - iconOffset * 2;

			if (healthBar.percent < 20)
				iconP1.animation.curAnim.curFrame = 1;
			else
				iconP1.animation.curAnim.curFrame = 0;

			if (healthBar.percent > 80)
				iconP2.animation.curAnim.curFrame = 1;
			else
				iconP2.animation.curAnim.curFrame = 0;
		}

		call('onUpdatePost', elapsed);
	}

	function presongLoad()
	{
		dad = new Character(SONG.player2);
		dad.setPosition(100, 100);
		add(dad);

		gf = new Character(SONG.player3);
		gf.setPosition(400, 130);
		add(gf);

		bf = new Character(SONG.player1);
		bf.setPosition(770, 450);
		add(bf);
		StageManager.charposcrap(dad, gf, bf);

		cpuStrums = new StrumLine(60, 50, 0);
		cpuStrums.scale.set(1, 1);

		if (!middleScroll)
		{
			uiGroup.add(cpuStrums.strumNotes);
			uiGroup.add(cpuStrums.notes);
			uiGroup.add(cpuStrums);
		}

		Conductor.songPosition = -5000;
		playerStrums = new StrumLine(FlxG.width * 0.6, 50, 1);
		playerStrums.scale.set(1, 1);
		uiGroup.add(playerStrums.strumNotes);
		uiGroup.add(playerStrums.notes);
		uiGroup.add(playerStrums);

		var d = dad.jsonFile.healthColors;
		var b = bf.jsonFile.healthColors;

		healthBar = new FlxBar(0, 0, RIGHT_TO_LEFT, 600, 19, this, 'health', 0.0, 2.0);

		healthBar.createFilledBar(FlxColor.fromRGB(d[0], d[1], d[2]), FlxColor.fromRGB(b[0], b[1], b[2]), true, FlxColor.BLACK);
		healthBar.screenCenter(X);
		healthBar.y = FlxG.height - Note.swagWidth;
		uiGroup.add(healthBar);

		notes = new FlxTypedGroup<Note>();
		uiGroup.add(notes);

		progressDial = new FlxPieDial(healthBar.x + healthBar.width / 2 - 25, playerStrums.y + 10, 50, FlxColor.WHITE, 200, FlxPieDialShape.CIRCLE, true, 3);
		progressDial.screenCenter(X);
		progressDial.antialiasing = false;

		if (middleScroll)
		{
			playerStrums.x = FlxG.height * 0.65 - Note.swagWidth / 2;
			progressDial.x = playerStrums.x - progressDial.width;
		}
		if (downScroll)
		{
			var top = cpuStrums.y;
			var bottom = healthBar.y;
			playerStrums.y = bottom - Note.swagWidth * 0.4;
			cpuStrums.y = bottom - Note.swagWidth * 0.4;
			healthBar.y = top + 50;
			progressDial.y = bottom - 10;
			progressDial.x = 0;
		}
		uiGroup.add(progressDial);

		textidk = new FlxText(0, healthBar.y + 50, 0, "______");
		textidk.setFormat('assets/fonts/InriaSans-Bold.ttf', 20);
		uiGroup.add(textidk);

		scoreTxt = new FlxText(0, healthBar.y + 50, 0, "Notes Alive:");
		scoreTxt.screenCenter(X);
		scoreTxt.setFormat('assets/fonts/InriaSans-Bold.ttf', 20);
		uiGroup.add(scoreTxt);

		camFollow = new FlxObject(0, 0, 1, 1);

		camPos = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);
		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		camGame.follow(camFollow, LOCKON, 0.04);

		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);

		sebotplay(false);
	}

	public function sebotplay(val:Bool)
	{
		var enabled:String = 'ENABLED';
		if (val == false)
			enabled = 'DISABLED';
		botplay = val;
		textidk.text = 'BOTPLAY $enabled';
		textidk.x = healthBar.x;

		return val;
	}

	function keyShit(elapsed:Float)
	{
		#if (!android)
		var keys = FlxG.keys.getIsDown();
		var upP = FlxG.keys.anyJustPressed([W, UP]);
		var rightP = FlxG.keys.anyJustPressed([D, RIGHT]);
		var downP = FlxG.keys.anyJustPressed([S, DOWN]);
		var leftP = FlxG.keys.anyJustPressed([A, LEFT]);

		var upR = FlxG.keys.anyJustReleased([W, UP]);
		var rightR = FlxG.keys.anyJustReleased([D, RIGHT]);
		var downR = FlxG.keys.anyJustReleased([S, DOWN]);
		var leftR = FlxG.keys.anyJustReleased([A, LEFT]);

		var left = FlxG.keys.anyPressed([A, LEFT]);
		var down = FlxG.keys.anyPressed([S, DOWN]);
		var up = FlxG.keys.anyPressed([W, UP]);
		var right = FlxG.keys.anyPressed([D, RIGHT]);
		var keyShit = [leftP, downP, upP, rightP];
		var keyShit2 = [leftR, downR, upR, rightR];
		var keyShit3 = [left, down, up, right];

		if (FlxG.keys.justPressed.SEVEN)
			FlxG.switchState(new ChartingState());
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new CharacterEditorState(SONG.player2));
		if (FlxG.keys.justPressed.B)
			sebotplay(!botplay);

		if (FlxG.sound.music.playing && SONG.notes[Std.int(curStep / 16)] != null)
		{
			cameraRightSide = SONG.notes[Std.int(curStep / 16)].mustHitSection;

			cameraMovement();
		}

		for (i in 0...keyShit.length)
		{
			var key = keyShit[i];
			var hitval = 'static';
			playerStrums.notes.forEach(function(note:Note)
			{
				if (note.strumTime <= Conductor.songPosition - 169 && !note.wasGoodHit && note.mustPress)
				{
					killCombo();
					health -= 0.03;
					note.kill();
					playerStrums.notes.remove(note, true);

					note.destroy();
				}

				if (note.canBeHit
					&& note.noteData == i
					&& key
					&& !keyShit2[i] == true
					&& !note.pressed
					|| note.strumTime <= Conductor.songPosition
					&& playerStrums.botStrum
					|| note.isSustainNote
					&& note.canBeHit
					&& playerStrums.botStrum
					&& !note.pressed
					&& !note.pressed)
				{
					hitval = 'confirm';

					playerStrums.invalidateNote(note, true);
					var fucker:Float = 0.005;
					if (!note.isSustainNote)
						popUpScore(note.strumTime);
					health += 0.025;
					note.wasGoodHit = true;
					note.pressed = true;
				}
				else if (note.isSustainNote && keyShit3[note.noteData] && note.canBeHit && note.mustPress && !note.pressed)
				{
					hitval = 'confirm';

					playerStrums.invalidateNote(note, true);
					note.wasGoodHit = true;
					note.pressed = true;
				}
			});
			if (key)
			{
				//////////////////////trace("PRESSED: " + i);
				var strum:StrumNote = playerStrums.strumNotes.members[i];

				strum.playAnim(i + hitval, true);
			}
			else if (keyShit2[i])
			{
				var strum:StrumNote = playerStrums.strumNotes.members[i];
				strum.playAnim('$i', false);
			}
		}
		#end
	}

	function killCombo()
	{
		combo = 0;

		songScore -= 10;
	}

	function cameraMovement()
	{
		if (camFollow.x != dad.getMidpoint().x + 150 && !cameraRightSide)
		{
			camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
			// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

			switch (dad.curCharacter)
			{
				case 'mom':
					camFollow.y = dad.getMidpoint().y;
				case 'senpai' | 'senpai-angry':
					camFollow.y = dad.getMidpoint().y - 430;
					camFollow.x = dad.getMidpoint().x - 100;
			}

			//	if (dad.curCharacter == 'mom')
			//		vocals.volume = 1;

			// if (SONG.song.toLowerCase() == 'tutorial')
			//	tweenCamIn();
		}

		if (cameraRightSide && camFollow.x != bf.getMidpoint().x - 100)
		{
			camFollow.setPosition(bf.getMidpoint().x - 100, bf.getMidpoint().y - 100);

			switch (curStage)
			{
				case 'limo':
					camFollow.x = bf.getMidpoint().x - 300;
				case 'mall':
					camFollow.y = bf.getMidpoint().y - 200;
				case 'school' | 'schoolEvil':
					camFollow.x = bf.getMidpoint().x - 200;
					camFollow.y = bf.getMidpoint().y - 200;
			}

			// if (SONG.song.toLowerCase() == 'tutorial')
			//	FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
		}
	}

	override function stepHit()
	{
		super.stepHit();

		// //////////////////////trace('Current Step is ${curStep * 1}.');
		notes.sort(sortNotes, FlxSort.DESCENDING);
	}

	public function call(func:String, ?var1, ?var2, ?var3)
	{
		for (i in 0...scripts.length)
		{
			var script:HScript = scripts[i];
			script.call(func, var1, var2, var3);
		}
	}

	override function beatHit()
	{
		super.beatHit();

		gf.dance();

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		call('onBeatHit', curBeat);

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);

				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);
		}

		playerStrums.notes.sort(FlxSort.byY, downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
		cpuStrums.notes.sort(FlxSort.byY, downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);

		// //////////////////////trace('Current Beat is ${curBeat * 1}.');
	}

	var cameraRightSide:Bool = false;

	override function sectionHit()
	{
		super.sectionHit();
		//////////////////////trace('Current Section is ${curSection * 1}.');
		camGame.zoom += 0.015;
		camHUD.zoom += 0.03;

		call('onSectionHit', curSection);

		if (SONG.needsVoices)
		{
			if (vocals.time > Conductor.songPosition + 20 || vocals.time < Conductor.songPosition - 20)
			{
				resyncVocals();
			}
		}
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return sortNotes(FlxSort.ASCENDING, Obj1, Obj2);
	}

	function sortNotes(order:Int = FlxSort.ASCENDING, Obj1:Note, Obj2:Note)
	{
		return FlxSort.byValues(order, Obj1.strumTime, Obj2.strumTime);
	}

	function getSongPercent(part:Float, total:Float)
	{
		part /= 1000;
		total /= 1000;
		total = Std.int(total);
		part = Std.int(total);
		return (part / total) * 0.01;
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	override function onResize(width, height)
	{
		super.onResize(width, height);

		trace('Resizing: Array:<Int> = [$width,$height]');
		resyncVocals();
	}

	override function onFocusLost()
	{
		super.onFocusLost();

		trace('Lost Focus! Pausing....');
		pause();
	}

	override function onFocus()
	{
		super.onFocusLost();

		trace('Focusing! Resyncing Vocals.......');
		resyncVocals();
	}

	function pause()
	{
		FlxG.sound.music.pause();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.pause();
	}

	private function popUpScore(strumtime:Float):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		//

		var rating:FunkinSprite = new FunkinSprite(0, 0);
		var score:Int = 350;

		var daRating:String = "sick";

		if (noteDiff > Conductor.safeZoneOffset * 0.9)
		{
			daRating = 'shit';
			score = 50;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.75)
		{
			daRating = 'bad';
			score = 100;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.2)
		{
			daRating = 'good';
			score = 200;
		}

		songScore += score;

		/* if (combo > 60)
				daRating = 'sick';
			else if (combo > 12)
				daRating = 'good'
			else if (combo > 4)
				daRating = 'bad';
		 */
		rating.loadGraphic(Paths.image(daRating.toLowerCase()));
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.setGraphicSize(Std.int(rating.width * 0.7));
		rating.updateHitbox();
		rating.antialiasing = true;
		rating.velocity.x -= FlxG.random.int(0, 10);
		rating.camera = camHUD;

		var comboSpr:FunkinSprite = new FunkinSprite(0, 0);
		comboSpr.loadGraphic(Paths.image('combo'));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.camera = camHUD;
		comboSpr.acceleration.y = 600;
		comboSpr.antialiasing = true;
		comboSpr.velocity.y -= 150;
		comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
		comboSpr.updateHitbox();
		comboSpr.velocity.x += FlxG.random.int(1, 10);
		add(comboSpr);
		add(rating);

		var seperatedScore:Array<Int> = [];

		seperatedScore.push(Math.floor(combo / 100));
		seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10));
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic('assets/images/num' + Std.int(i) + '.png');
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;
			numScore.antialiasing = true;
			numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			numScore.updateHitbox();
			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.camera = camHUD;
			numScore.velocity.x = FlxG.random.float(-5, 5);

			add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});
	}
}
