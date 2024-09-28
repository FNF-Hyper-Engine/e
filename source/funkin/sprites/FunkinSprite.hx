package funkin.sprites;

class FunkinSprite extends FlxSprite
{
	var hitbox:FlxSprite;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		hitbox = new FlxSprite();
		antialiasing = true;
	
	}

	public function playAnim(Animation:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0)
	{
		animation.play(Animation, Force, Reversed, Frame);
		antialiasing = true;
	}

	public	function addByPrefix(Name:String, Prefix:String, FrameRate:Float = 27, Looped:Bool = false, FlipX = false, FlipY = false)
	{
		animation.addByPrefix(Name, Prefix, 24, Looped, FlipX, FlipY);
	}

	public function atlasFrames(path:String):Void
	{
		frames = Paths.getSparrowAtlas(path);
	}

	public override function destroy():Void
	{
		frames = null;
		// Cancel all tweens so they don't continue to run on a destroyed sprite.
		// This prevents crashes.
		FlxTween.cancelTweensOf(this);

		super.destroy();
	}
}
