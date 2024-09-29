package funkin.objects;

class EventNote extends FunkinSprite
{
	public var strumTime:Float;

	public var eventVal2:String;
	public var noteData:Int = -1;
	public var eventVal1:String;
	public var eventName:String;

	public function new(strumTime:Float, ?eventVal1, ?eventVal2, eventName:String = 'none')
	{
		super(x, y);

		this.strumTime = strumTime;
		this.eventVal1 = eventVal1;
		this.eventVal2 = eventVal2;
		this.eventName = eventName;
		loadGraphic(Paths.image('eventNote'));
	}

	@:noCompletion
	override function set_clipRect(rect:FlxRect):FlxRect
	{
		

		if (frames != null)
			frame = frames.frames[animation.frameIndex];

		return rect;
	}
}
