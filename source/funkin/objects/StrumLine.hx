package funkin.objects;

import openfl.display3D.Context3DTextureFilter;

class StrumLine extends FunkinSprite
{
	public var strumNotes:FlxTypedGroup<StrumNote>;
	public var botStrum:Bool = true;
	public var notes:FlxTypedGroup<Note>;
	public var scrollSpeed:Float = 1;

	public function new(x, y, player:Int = 1, lanes:Int = 4)
	{
		super(x, y);

		strumNotes = new FlxTypedGroup<StrumNote>();
		notes = new FlxTypedGroup<Note>();

		// if (player == 0)
		//	botStrum = true;
		for (i in 0...lanes)
		{
			var strumNote:StrumNote;
			strumNote = new StrumNote(x, y, i);

			strumNote.x = x + (strumNote.width * i);
			strumNote.ID = i;
			// strumNote.x += strumNote.width / 2;
			strumNote.playAnim('static');

			strumNotes.add(strumNote);
		}
		makeGraphic(FlxG.width * 4, 1);
		updateHitbox();
	}

	override function update(elapsed:Float)
	{
		strumNotes.forEach(function(strumNote:StrumNote)
		{
			strumNote.x = x + (strumNote.width * scale.x * strumNote.ID);
			strumNote.scale.set(scale.x * 0.7, scale.y * 0.7);
			strumNote.y = y;
		});

		notes.forEach(function(daNote:Note)
		{
			var roundedSpeed:Float = FlxMath.roundDecimal(scrollSpeed, 2);
			var fakeCrochet:Float = (60 / PlayState.SONG.bpm) * 1000;

			if (!PlayState.downScroll)
				daNote.y = (strumNotes.members[daNote.noteData].y + 0.45 - (Conductor.songPosition - daNote.strumTime) * (0.45 * roundedSpeed));
			else
			{
				daNote.y = (strumNotes.members[daNote.noteData].y + 0.45 + (Conductor.songPosition - daNote.strumTime) * (0.45 * roundedSpeed));
				if (daNote.isSustainNote)
				{
					daNote.flipY = true;
				}
			}
			daNote.x = strumNotes.members[daNote.noteData].x;

			// daNote.y -= daNote.height;
			var center:Float = strumNotes.members[daNote.noteData].y + Note.swagWidth / 2;
			if (daNote.isSustainNote
				&& daNote.strumTime <= Conductor.songPosition + 100
				&& !daNote.mustPress
				|| daNote.mustPress
				&& daNote.wasGoodHit
				&& !PlayState.downScroll)
			{
				if (daNote.y + daNote.offset.y * daNote.scale.y <= center)
				{
					var swagRect:FlxRect;

					swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
					swagRect.y = (center - daNote.y) / daNote.scale.y;
					swagRect.width = daNote.width / daNote.scale.x;
					swagRect.height = (daNote.height / daNote.scale.y) - swagRect.y;
					daNote.clipRect = swagRect;
				}
				else if (daNote.isSustainNote
					&& daNote.strumTime <= Conductor.songPosition + 100
					&& !daNote.mustPress
					|| daNote.mustPress
					&& daNote.wasGoodHit
					&& PlayState.downScroll)
				{
					if (daNote.isSustainNote)
					{
						if (daNote.animation.curAnim.name.endsWith("end") && daNote.prevNote != null)
							daNote.y += daNote.prevNote.height;
						else
							daNote.y += daNote.height / 2;

						// clipRect is applied to graphic itself so use frame Heights
						var swagRect:FlxRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);

						swagRect.height = (center - daNote.y) / daNote.scale.y;
						swagRect.y = daNote.frameHeight - swagRect.height;
						daNote.clipRect = swagRect;
					}
				}
			}

			if (PlayState.downScroll && daNote.isSustainNote)
			{
				if (daNote.animation.curAnim.name.endsWith('end'))
				{
					daNote.y += 10.5 * (fakeCrochet / 400) * 1.5 * scrollSpeed + (46 * (scrollSpeed - 1));
					daNote.y -= 46 * (1 - (fakeCrochet / 600)) * scrollSpeed;

					daNote.y -= 19;
				}
				daNote.y += (Note.swagWidth / 2) - (60.5 * (scrollSpeed - 1));
				daNote.y += 27.5 * ((PlayState.SONG.bpm / 100) - 1) * (scrollSpeed - 1);
			}

			if (daNote.y > FlxG.height)
			{
				daNote.active = false;
				daNote.visible = false;
			}
			else
			{
				daNote.visible = true;
				daNote.active = true;
			}

			if (!daNote.mustPress && daNote.wasGoodHit)
				invalidateNote(daNote, true);
			if (daNote.tooLate)
				invalidateNote(daNote);
		});
		super.update(elapsed);
	}

	public function invalidateNote(note:Note, strum:Bool = false)
	{
		if (!note.pressed)
		{
			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
			else
			{
				if (note.y <= y - note.height)
				{
					note.kill();
					notes.remove(note, true);
					note.destroy();
				}
			}
			//	Sys.println("[NOTE DESTROYING]: AUTO-NOTE DESTROYED AT: " + (Conductor.songPosition / 1000) + ' SECONDS');
			if (!note.mustPress)
			{
				var convertedString:String = PlayState.instance.coolAnims[note.noteData];
				var dad:Character = PlayState.instance.dad;
				dad.playAnim(convertedString, true);
				// trace('Opponent likes to sing $convertedString' + '.');
			}
			else if (note.mustPress)
			{
				var convertedString:String = PlayState.instance.coolAnims[note.noteData];
				var boyfriend:Character = PlayState.instance.bf;
				boyfriend.playAnim(convertedString, true);
			}

			if (strum)
			{
				var s = strumNotes.members[note.noteData];

				if (note.mustPress)
				{
					if (!note.isSustainNote)
						PlayState.instance.health += note.hitHealth;
				}

				if (!note.mustPress || note.mustPress && PlayState.botplay)
				{
					s.resetAnim = (Conductor.stepCrochet * 1.25 / 1000 / 1);
				}
				s.playAnim('confirm', true);

				// if (s.animation.curAnim.finished) // shitted away in favor of dear old resetanim
				//	s.playAnim('static', true);
			}
		}
		note.pressed = true;
	}
}
