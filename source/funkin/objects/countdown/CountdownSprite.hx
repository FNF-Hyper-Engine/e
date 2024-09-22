package funkin.objects.countdown;

/**
 * The Countdown class.
 * @author LeonGamerPS1
 */
class CountdownSprite extends FunkinSprite
{
	/**
	 * Constructor for the Countdown Sprite.
	 * @param x The X Position.
	 * @param y The Y Position.
	 * @param spr The sprite that should be used.
	 * @param skin The Skin (either "funkin" or "pixel") that should be used depending on PlayState.isPixel or the specified skin.
	 */
	public function new(?x, ?y, ?spr:String = 'ready', ?skin:String = 'funkin',)
	{
		super(x, y);
		loadGraphic(Paths.image('countdown/$skin/$spr'));
	}

	public function ass(?spr:String = 'ready', ?skin:String = 'funkin')
	{
		loadGraphic(Paths.image('countdown/$skin/$spr'));
        alpha = 1;
	}
}
