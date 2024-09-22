package funkin;

class Main extends Sprite
{
	public function new()
	{
		super();
		#if (!android)
		addChild(new FlxGame(0, 0, TitleState #if (!html5), 240, 240 #end));
		#else
		addChild(new FlxGame(0, 0, PlayState));
		#end
		var fps_mem:FPS_Mem = new FPS_Mem(10, 10, 0xffffff);

		addChild(fps_mem);
	}
}
