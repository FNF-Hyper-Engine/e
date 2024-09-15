package funkin.sprites;

class FunkinSprite extends FlxSprite
{
	var hitbox:FlxSprite;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		hitbox = new FlxSprite();
	}

	public function playAnim(Animation:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0)
	{
		animation.play(Animation, Force, Reversed, Frame);
	}

	function addByPrefix(Name:String, Prefix:String, FrameRate:Float = 27, Looped:Bool = false, FlipX = false, FlipY = false)
	{
		animation.addByPrefix(Name, Prefix, 24, Looped, FlipX, FlipY);
	}

	public function atlasFrames(path:String):Void
	{
		frames = Paths.getSparrowAtlas(path);
	}
}
