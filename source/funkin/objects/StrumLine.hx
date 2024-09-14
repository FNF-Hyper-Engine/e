package funkin.objects;

class StrumLine extends FunkinSprite
{
	public var strumNotes:FlxTypedGroup<StrumNote>;

	public function new(x, y, player:Int = 1, lanes:Int = 4)
	{
		super(x, y);
		strumNotes = new FlxTypedGroup<StrumNote>();
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
		super.update(elapsed);
		strumNotes.forEach(function(strumNote:StrumNote)
		{
			strumNote.x = x + (strumNote.width * strumNote.ID);
			strumNote.y = y;
		});
	}
}
