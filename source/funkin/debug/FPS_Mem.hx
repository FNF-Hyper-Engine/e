package funkin.debug;

import openfl.text.Font;

/**

	* FPS class extension to display memory usage.

	* @author Kirill Poletaev

 */
@:font('assets/fonts/InriaSans-Bold.ttf') class A extends Font {}

@:font('assets/fonts/InriaSans-BoldItalic.ttf') class B extends Font {}
@:font('assets/fonts/InriaSans-Italic.ttf') class C extends Font {}
@:font('assets/fonts/InriaSans-Light.ttf') class D extends Font {}
@:font('assets/fonts/InriaSans-LightItalic.ttf') class E extends Font {}
@:font('assets/fonts/InriaSans-Regular.ttf') class F extends Font {}
@:font('assets/fonts/Inter Regular.ttf') class G extends Font {}

class FPS_Mem extends TextField
{
	public var currentFPS(default, null):Int;
	public var currentMemory(default, null):Int;

	@:noCompletion private var currentTime:Float;
	@:noCompletion private var lastStamp:Float;
	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 4, y:Float = 4, color:Int = 0xFFFFFF) {
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new openfl.text.TextFormat("Inter Regular", 10, color);
		autoSize = LEFT;
		text = "FPS:\nMEM:";
		blendMode = SCREEN;

		currentTime = 0;
		lastStamp = 0;
		times = [];
	}

	@:noCompletion
	private override function __enterFrame(deltaTime:Float):Void {
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
			times.shift();

		currentFPS = Math.floor(Math.min(times.length, flixel.FlxG.drawFramerate));

		if (currentTime < lastStamp + 500)
			return;
		lastStamp += 500;

		#if windows
		currentMemory = funkin.externs.WinAPI.get_process_memory();
		#else
		currentMemory = openfl.system.System.totalMemory;
		#end
		htmlText = '<font size="+4">'
			+ currentFPS
			+ '</font> FPS\n<font size="+4">'
			+ Math.floor(currentMemory / 104857.6) * .1
			+ '</font> MB\nHyper Engine v0.1.0-alpha' #if debug + ' Debug Build' #end;
	}
}
