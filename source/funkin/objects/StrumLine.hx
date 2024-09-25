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
			strumNote = new StrumNote(x, y);

			strumNote.x = x + (strumNote.width * i);
			strumNote.ID = i;
			// strumNote.x += strumNote.width / 2;
			strumNote.playAnim('$i');
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
			var center:Float = strumNotes.members[daNote.noteData].y + 0 + Note.swagWidth / 2;
			if (daNote.isSustainNote
				&& daNote.strumTime <= Conductor.songPosition + 100
				&& !daNote.mustPress
				|| daNote.mustPress
				&& daNote.wasGoodHit)
			{
				var swagRect:FlxRect = daNote.clipRect;
				if (swagRect == null)
					swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
				if (daNote.y + daNote.offset.y * daNote.scale.y <= center)
				{
					swagRect.y = (center - daNote.y) / daNote.scale.y;
					swagRect.width = daNote.width / daNote.scale.x;
					swagRect.height = (daNote.height / daNote.scale.y) - swagRect.y;
				}
				else if (y - daNote.offset.y * daNote.scale.y + daNote.height >= center && PlayState.downScroll)
				{
					swagRect.height = (center - daNote.y) / daNote.scale.y;
					swagRect.y = daNote.frameHeight - swagRect.height;
					daNote.clipRect = swagRect;
				}
				daNote.clipRect = swagRect;
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
		if (strum)
		{
			var strum = strumNotes.members[note.noteData];
			if (note.mustPress) {
				strum.playAnim('${note.noteData}confirm', true);
				PlayState.instance.health += note.hitHealth;
			}
			

			if (strum.animation.curAnim.finished)
				strum.playAnim('${note.noteData}', false);
		}
	}
}
