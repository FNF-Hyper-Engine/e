package funkin.objects;

import funkin.objects.StrumNote;

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

	public static var globalRgbShaders:Array<RGBPalette> = [];

	public var rgbShader:RGBShaderReference;

	public var useRGBShader:Bool = true;

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
		rgbShader = new RGBShaderReference(this, Note.initializeGlobalRGBShader(noteData));
		rgbShader.enabled = true;

		super(x, y);

		this.strumTime = strumTime;
		this.noteData = noteData;
		this.prevNote = prevNote;
		this.isSustainNote = isSustainNote;
		ID = noteData;
		frames = Paths.getSparrowAtlas('noteStyles/normal');
		setGraphicSize(width * 0.7);
		addAnimations();

		antialiasing = false;

		updateHitbox();
	}

	@:noCompletion
	function addAnimations()
	{
		addByPrefix('note', 'note');
		addByPrefix('hold', 'hold');
		addByPrefix('end', 'end');
		playAnim('note');

		if (isSustainNote)
		{
			playAnim('hold');
			scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
	        alpha = 0.6;
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
		//alpha = 1;
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

		var a = 0;
		switch (ID)
		{
			case 0:
				a = 90;
			case 1:
				a = 0;
			case 2:
				a = 180;
			case 3:
				a = -90;
		}
		if (!isSustainNote)
			angle = a;
	}

	@:noCompletion
	override function set_clipRect(rect:FlxRect):FlxRect
	{
		clipRect = rect;

		if (frames != null && isSustainNote)
			frame = frames.frames[animation.frameIndex];

		return rect;
	}

	public static function initializeGlobalRGBShader(noteData:Int)
	{
		if (globalRgbShaders[noteData] == null)
		{
			var newRGB:RGBPalette = new RGBPalette();
			globalRgbShaders[noteData] = newRGB;

			var arr:Array<FlxColor> = funkin.settings.Settings.arrowRGB[noteData];
			if (noteData > -1 && noteData <= arr.length)
			{
				newRGB.r = arr[0];
				newRGB.g = arr[1];
				newRGB.b = arr[2];
			}
		}
		return globalRgbShaders[noteData];
	}
}
