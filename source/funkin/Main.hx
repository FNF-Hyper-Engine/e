package funkin;

import openfl.display.DisplayObject;
import funkin.modding.Mods;

#if windows
@:headerCode("
	#include <windows.h>
	#include <winuser.h>
")
#end
class Main extends Sprite
{
	public function new()
	{
		super();
		#if (!android)
		addChild(new FlxGame(0, 0, TitleState #if (!html5),120,120 #end));
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

	#if windows
	@:functionCode('
	SetProcessDPIAware();
')
	#end
	public static function registerAsDPICompatible() {}

	function setFlxDefines()
	{
		FlxG.mouse.visible = false;
		FlxG.cameras.useBufferLocking = true;
		FlxG.autoPause = false;
		FlxG.fixedTimestep = false;
		FlxG.mouse.useSystemCursor = true;
	}

	@:noCompletion override function __hitTest(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool
		return false;

	@:noCompletion override function __hitTestHitArea(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool,
			hitObject:DisplayObject):Bool
		return false;

	@:noCompletion override function __hitTestMask(x:Float, y:Float):Bool
		return false;
}
