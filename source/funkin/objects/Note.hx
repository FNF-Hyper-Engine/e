package funkin.objects;

class Note extends FunkinSprite
{
	public var strumTime:Float;
	public var noteData:Int;
	public var sustainLength:Int;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public var noteType:Int = 0;
	public var mustPress:Bool;
	public var pressed:Bool = false;
	public var prevNote:Note;
	public var isSustainNote:Bool;
	public var wasGoodHit:Bool = false;
	public var tooLate:Bool = false;
	public var canBeHit:Bool = false;
	public var eventVal2:String;
	public var eventVal1:String;
	public var eventName:String;

	public var hitHealth:Float = 0.02;
	public var missHealth:Float = 0.1;

	public function new(strumTime:Float, noteData, prevNote, isSustainNote = false)
	{
		super(x, y);

		this.strumTime = strumTime;
		this.noteData = noteData;
		this.prevNote = prevNote;
		this.isSustainNote = isSustainNote;
		ID = noteData;
		frames = Paths.getSparrowAtlas('notes');
		setGraphicSize(width * 0.7);
		addAnimations();

		updateHitbox();
	}

	@:noCompletion
	function addAnimations()
	{
		addByPrefix('0', 'pruiple');
		addByPrefix('1', 'blueee');
		addByPrefix('2', 'greennn');
		addByPrefix('3', 'reddd');
		addByPrefix('0hold', 'purple hold piece');
		addByPrefix('1hold', 'blue hold piece');
		addByPrefix('2hold', 'green hold piece');
		addByPrefix('3hold', 'red hold piece');
		addByPrefix('0end', 'pruple end hold');
		addByPrefix('1end', 'blue hold end');
		addByPrefix('2end', 'green hold end');
		addByPrefix('3end', 'red hold end');

		playAnim('$ID');

		if (isSustainNote)
		{
			playAnim('$noteData' + 'hold');
			scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
			alpha = 0.7;
		}
		// trace(prevNote);

		antialiasing = false;
	}

	override function playAnim(animation, force = false, reversed = false, frame:Int = 0)
	{
		super.playAnim(animation, force, reversed, frame);
		centerOffsets();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (mustPress)
		{
			// The * 0.5 us so that its easier to hit them too late, instead of too early
			if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
			{
				canBeHit = true;
			}
			else
				canBeHit = false;

			if (strumTime < Conductor.songPosition - 173) // (Conductor.safeZoneOffset * 0.7))
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
			{
				wasGoodHit = true;
			}
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.6;
		}
	}
	/*
		@:noCompletion
		override function set_clipRect(rect:FlxRect):FlxRect
		{
			clipRect = rect;

			if (frames != null && isSustainNote)
				frame = frames.frames[animation.frameIndex];

			return rect;
		}
	 */
}
