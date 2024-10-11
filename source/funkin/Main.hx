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
		var game = new FlxGame(0, 0,  funkin.Init);
		
		@:privateAccess
		game._customSoundTray = FunkinSoundTray;
		#if (!android)
		addChild(game);
		#else
		addChild(new FlxGame(0, 0, PlayState));
		#end
	//	FlxG.sound.cacheAll();
		Mods.pushGlobalMods();
		var fps_mem:FPS_Mem = new FPS_Mem(10, 10, 0xffffff);
		CursorLoader.skin = 'default';

		addChild(fps_mem);

		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		registerAsDPICompatible();
		setFlxDefines();
	}


	public static function registerAsDPICompatible() {}

	function setFlxDefines()
	{

		FlxG.cameras.useBufferLocking = true;
		FlxG.autoPause = false;
		FlxG.fixedTimestep = false;

	}

}
