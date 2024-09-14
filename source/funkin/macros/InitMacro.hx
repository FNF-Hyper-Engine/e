package funkin.macros;

class InitMacro
{
	macro static function init()
	{
		trace(Sys.args()[1]);
		return macro {};
	}
}
