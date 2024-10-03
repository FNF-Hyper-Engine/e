package funkin;

import haxe.ui.Toolkit;
import funkin.modding.Mods;

class Main extends Sprite
{
	public function new()
	{
		super();
		Toolkit.theme = 'dark';
		Toolkit.init();
		
		#if (!android)
		addChild(new FlxGame(0, 0, TitleState));
		#else
		addChild(new FlxGame(0, 0, PlayState));
		#end
		Mods.pushGlobalMods();
		var fps_mem:FPS_Mem = new FPS_Mem(10, 10, 0xffffff);
		CursorLoader.skin = 'default';

		addChild(fps_mem);
	}
}
