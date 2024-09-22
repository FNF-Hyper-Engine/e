package funkin;

class PlayState extends MusicBeatState
{
	var cpuStrums:StrumLine;
	var playerStrums:StrumLine;

	public static var instance:PlayState;

	public var pixelZoom:Float = 6.0;

	private var notes:FlxTypedGroup<Note>;

	public var startingSong:Bool = false;
	public var startedCountdown:Bool = false;

	private var vocals:FlxSound;

	public static var SONG:SwagSong;

	public var progressDial:FlxPieDial;

	public static var middleScroll:Bool = false;

	public static var downScroll:Bool = false;

	private var healthHeads:FunkinSprite;
	private var unspawnNotes:Array<Note> = [];

	private var coolSections:Array<Bool> = [];

	public var defaultCamZoom:Float = 1.05;
	public var health:Float = 1;

	public var healthBar:FlxBar;

	var botplay:Bool = false;

	var textidk:FlxText;

	override public function create()
	{
		presongLoad();

		if (SONG == null)
			SONG = Song.loadFromJson('epiphany-instrumental-hard', 'epiphany-instrumental');

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
					sustainNote.offset.x -= sustainNote.width / 2;
					sustainNote.offset.y -= 2.5;
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
				s.offset.y += 5;
				s.scale.y = 1;
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
		super.create();
		startCountdown();
	}

	function startCountdown(skin:String = 'funkin')
	{
		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.inst(SONG.song.toLowerCase(), 'Voices'));
		else
			vocals = new FlxSound();

		var ct:CountdownHandler;
		ct = new CountdownHandler(startSong);
		add(ct);
		startingSong = true;
		startedCountdown = true;
		ct.startass();
	}

	function startSong()
	{
		startingSong = false;
		FlxG.sound.playMusic(Paths.inst(SONG.song.toLowerCase()), 1, false);
		FlxG.sound.music.pitch = 1;
		vocals.play();
	}

	override function destroy()
	{
		vocals.stop();
		vocals.destroy();
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

		keyShit(elapsed);
		FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
		if (health > 2)
			health = 2;
		else if (health < 0)
			health = 0;

		if (playerStrums != null)
			playerStrums.botStrum = botplay;
		super.update(elapsed);

		//////////////////////trace(getSongPercent(Conductor.songPosition, FlxG.sound.music.endTime));

		healthHeads.setGraphicSize(FlxMath.lerp(200, healthHeads.width, 0.5));

		healthHeads.updateHitbox();
		healthHeads.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (healthHeads.width / 2);
	}

	function presongLoad()
	{
		instance = this;

		cpuStrums = new StrumLine(60, 50, 0);
		cpuStrums.scale.set(1, 1);
		if (!middleScroll)
		{
			add(cpuStrums.strumNotes);
			add(cpuStrums.notes);
			add(cpuStrums);
		}
		Conductor.songPosition = -5000;
		playerStrums = new StrumLine(FlxG.width * 0.6, 50, 1);
		playerStrums.scale.set(1, 1);
		add(playerStrums.strumNotes);
		add(playerStrums.notes);
		add(playerStrums);

		healthBar = new FlxBar(0, 0, RIGHT_TO_LEFT, 600, 19, this, 'health', 0.0, 2.0);

		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33, true, FlxColor.BLACK);
		healthBar.screenCenter(X);
		healthBar.y = FlxG.height - Note.swagWidth;
		add(healthBar);

		healthHeads = new FunkinSprite(healthBar.x, healthBar.y);
		healthHeads.antialiasing = false;
		healthHeads.atlasFrames('healthHeads');
		healthHeads.updateHitbox();
		healthHeads.setPosition(healthBar.x, healthBar.y - 75);
		add(healthHeads);
		notes = new FlxTypedGroup<Note>();
		add(notes);

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
			playerStrums.y = bottom - Note.swagWidth / 2;
			healthBar.y = top + 50;
			progressDial.y = bottom - 10;
			progressDial.x = 0;
			healthHeads.y = healthBar.y - 75;
		}
		add(progressDial);

		textidk = new FlxText(0, healthBar.y + 50, 0, "______");
		textidk.setFormat('assets/fonts/InriaSans-Bold.ttf', 20);
		add(textidk);
		sebotplay(false);
	}

	private function sebotplay(val:Bool)
	{
		var enabled:String = 'ENABLED';
		if (val == false)
			enabled = 'DISABLED';
		botplay = val;
		textidk.text = 'BOTPLAY $enabled';
		textidk.screenCenter(X);
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
		if (FlxG.keys.justPressed.B)
			sebotplay(!botplay);

		for (i in 0...keyShit.length)
		{
			var key = keyShit[i];
			var hitval = 'static';
			playerStrums.notes.forEach(function(note:Note)
			{
				if (note.canBeHit
					&& note.noteData == i
					&& key
					&& !keyShit2[i] == true
					&& !note.pressed
					|| note.strumTime <= Conductor.songPosition + 5
					&& playerStrums.botStrum
					|| note.isSustainNote
					&& note.canBeHit
					&& playerStrums.botStrum
					&& !note.pressed)
				{
					hitval = 'confirm';

					playerStrums.invalidateNote(note, true);
				    var fucker:Float = 0.005;
					
					health += 0.005;
					note.wasGoodHit = true;
					note.pressed = true;
				}
				else if (note.isSustainNote && keyShit3[note.noteData] && note.canBeHit && note.mustPress && !note.pressed)
				{
					hitval = 'confirm';
					note.wasGoodHit = true;
					health += 0.00025;
					playerStrums.invalidateNote(note, true);
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

	override function stepHit()
	{
		super.stepHit();

		// //////////////////////trace('Current Step is ${curStep * 1}.');
		notes.sort(sortNotes, FlxSort.DESCENDING);
	}

	override function beatHit()
	{
		super.beatHit();
		healthHeads.setGraphicSize(Std.int(healthHeads.width + 30));
		healthHeads.updateHitbox();

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

	override function sectionHit()
	{
		super.sectionHit();
		//////////////////////trace('Current Section is ${curSection * 1}.');
		FlxG.camera.zoom += 0.05;

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
}
