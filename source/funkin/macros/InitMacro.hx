package funkin.macros;

class InitMacro
{
	macro static function init()
	{
		trace('Macro Started, OS: ${lime.system.System.deviceModel} ');

		return macro {};
	}
}
