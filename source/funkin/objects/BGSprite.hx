package funkin.objects;

class BGSprite extends FunkinSprite
{
	private var idleAnim:String;

	public var isGore:Bool = false;

	public function new(image:String, x:Float = 0, y:Float = 0, ?scrollX:Float = 1, ?scrollY:Float = 1, ?animArray:Array<String> = null, ?loop:Bool = false)
	{
		super(x, y);

		if (animArray != null)
		{
			frames = Paths.getSparrowAtlas(image); // fuck you shadow mario!! AAASGOUDGVASFUKLJASGVFKJ~
			for (i in 0...animArray.length)
			{
				var anim:String = animArray[i];
				animation.addByPrefix(anim, anim, 24, loop);
				if (idleAnim == null)
				{
					idleAnim = anim;
					animation.play(anim);
				}
			}
		}
		else
		{
			if (image != null)
			{
				loadGraphic(Paths.image(image));
			}
			active = false;
		}
		scrollFactor.set(scrollX, scrollY);
		antialiasing = true;
	}

	public function dance(?forceplay:Bool = false)
	{
		if (idleAnim != null)
		{
			animation.play(idleAnim, forceplay);
		}
	}

	override function draw()
	{
		//if (isGore)
		//	return; // don't draw gore
		// I do it in a draw call so that you can still do visible, etc and it STILL won't draw gore if gore is false

		super.draw();
	}
}
