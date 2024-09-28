package funkin.helpers;

class CursorLoader
{
	public static var skin(default, set):String;

	static function set_skin(value:String):String
	{
		var crs:FunkinSprite;
        crs = new FunkinSprite(0,0);
		crs.loadGraphic(Paths.image('cursor/cursor-$value'));
		var pixels = crs.pixels;

		FlxG.mouse.load(pixels);
		crs.kill();
		return skin;
	}
}
