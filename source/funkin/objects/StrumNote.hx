package funkin.objects;

class StrumNote extends FunkinSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);
		frames = Paths.getSparrowAtlas('notes');
		setGraphicSize(width * 0.7);
		addAnimations();
		updateHitbox();
	}

	@:noCompletion
	function addAnimations()
	{
		addByPrefix('0', 'arrowLEFT');
		addByPrefix('1', 'arrowDOWN');
		addByPrefix('2', 'arrowUP');
		addByPrefix('3', 'arrowRIGHT');
		addByPrefix('0confirm', 'left confirm');
		addByPrefix('1confirm', 'down confirm');
		addByPrefix('2confirm', 'up confirm');
		addByPrefix('3confirm', 'right confirm');
		addByPrefix('0static', 'left press');
		addByPrefix('1static', 'down press');
		addByPrefix('2static', 'up press');
		addByPrefix('3static', 'right press');
		antialiasing = true;
	}

	override function playAnim(animation, force = false, reversed = false, frame:Int = 0)
	{
		super.playAnim(animation, force, reversed, frame);
		centerOffsets();
	}

	override function update(elapsed:Float)
	{
		if (animation.curAnim.name == '$ID' + 'confirm')
		{
			updateConfirmOffset();
		}
		super.update(elapsed);
	}

	function updateConfirmOffset()
	{ // TODO: Find a calc to make the offset work fine on other angles
		centerOffsets();
		offset.x -= 13;
		offset.y -= 10;

		// centerOffsets();
	}
}
