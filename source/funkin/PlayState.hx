package funkin;

class PlayState extends MusicBeatState
{
	var cpuStrums:StrumLine;
	var playerStrums:StrumLine;

	public var pixelZoom:Float = 6.0;

	private var notes:FlxTypedGroup<Note>;

	public static var SONG:SwagSong;

	private var healthHeads:FunkinSprite;
	private var unspawnNotes:Array<Note> = [];

	public var defaultCamZoom:Float = 1.05;
	public var health:Float = 1;

	public var healthBar:FlxBar;

	override public function create()
	{
		cpuStrums = new StrumLine(60, 50, 0);
		add(cpuStrums.strumNotes);
		add(cpuStrums.notes);
		add(cpuStrums);

		playerStrums = new StrumLine(FlxG.width * 0.6, 50, 1);
		add(playerStrums.strumNotes);
		add(playerStrums.notes);
		add(playerStrums);

		healthBar = new FlxBar(0, 0, RIGHT_TO_LEFT, 600, 19, this, 'health', 0.0, 2.0);

		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33, true, FlxColor.BLACK);
		healthBar.screenCenter(X);
		healthBar.y = FlxG.height - Note.swagWidth;
		add(healthBar);

		healthHeads = new FunkinSprite(healthBar.x, healthBar.y);
		healthHeads.atlasFrames('healthHeads');
		healthHeads.updateHitbox();
		healthHeads.setPosition(healthBar.x, healthBar.y - 75);
		add(healthHeads);
		notes = new FlxTypedGroup<Note>();
		add(notes);

		if (SONG == null)
			SONG = Song.loadFromJson('bopeebo-hard', 'bopeebo');

		FlxG.sound.playMusic(Paths.inst(SONG.song.toLowerCase()), 1, false);
		FlxG.sound.music.pitch = 1;
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

				for (susNote in 0...Math.floor(susLength))
				{
					var count:Int = Math.round(susLength);
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					if (susNote == count - 1)
					{
						sustainNote.playAnim('${daNoteData}end');
						sustainNote.scale.y = 1;
						sustainNote.strumTime -= Conductor.stepCrochet * 0.1;
						// sustainNote.offset.y += sustainNote.height * 0.1;
					}
					sustainNote.alpha = 0.6;

					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;
					sustainNote.offset.x -= sustainNote.width;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else {}
			}
			daBeats += 1;
		}

		trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 4000)
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

		super.update(elapsed);

		healthHeads.setGraphicSize(FlxMath.lerp(200, healthHeads.width, 0.95));
		healthHeads.updateHitbox();
		healthHeads.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (healthHeads.width / 2);
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

		for (i in 0...keyShit.length)
		{
			var hitval = 'static';

			var key = keyShit[i];

			playerStrums.notes.forEach(function(note:Note)
			{
				if (note.canBeHit && note.noteData == i && key && !keyShit2[i] == true)
				{
					hitval = 'confirm';

					playerStrums.invalidateNote(note, true);
					note.wasGoodHit = true;
				}
				else if (note.isSustainNote && keyShit3[note.noteData] && note.canBeHit && note.mustPress)
				{
					hitval = 'confirm';
					note.wasGoodHit = true;
					playerStrums.invalidateNote(note, true);
				}
			});
			if (key)
			{
				trace("PRESSED: " + i);
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
		// trace('Current Step is ${curStep * 1}.');
	}

	override function beatHit()
	{
		super.beatHit();
		healthHeads.setGraphicSize(Std.int(healthHeads.width + 30));
		healthHeads.updateHitbox();

		// trace('Current Beat is ${curBeat * 1}.');
	}

	override function sectionHit()
	{
		super.sectionHit();
		trace('Current Section is ${curSection * 1}.');
		FlxG.camera.zoom += 0.05;
	}

	override function destroy()
	{
		super.destroy();
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}
}
