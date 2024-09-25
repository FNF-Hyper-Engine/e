package funkin;

import funkin.modding.Mods;

class Main extends Sprite
{
	public function new()
	{
		super();
		#if (!android)
		addChild(new FlxGame(0, 0, TitleState #if (!html5), 100, 100 #end));
		#else
		addChild(new FlxGame(0, 0, PlayState));
		#end
		Mods.pushGlobalMods();
		var fps_mem:FPS_Mem = new FPS_Mem(10, 10, 0xffffff);

		addChild(fps_mem);
	}
}
