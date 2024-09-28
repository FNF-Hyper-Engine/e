package funkin.scripting;

import hscript.Parser;
import hscript.Interp;

class HScript
{
	var parser:Parser;
	var interp:Interp;

	public function new(path:String, name:String, byte:Bool = false)
	{
		var expr:String;
		#if sys
		if (byte)
			expr = sys.io.File.read(path).readAll().toString();
		else
			expr = Assets.getText(path);
		#else
		expr = Assets.getText(path);
		#end
		parser = new hscript.Parser();
		parser.allowTypes = true;
		parser.allowMetadata = true;
		parser.allowJSON = true;
		parser.resumeErrors = true;
		var ast = parser.parseString(expr);

		interp = new hscript.Interp();

		set('game', PlayState.instance);
		set('FlxTween', flixel.tweens.FlxTween);
		set('iconP1', PlayState.instance.iconP1);
		set('iconP2', PlayState.instance.iconP2);
		set('dad', PlayState.instance.dad);
		set('bf', PlayState.instance.bf);
		set('boyfriend', PlayState.instance.bf);
		set('gf', PlayState.instance.gf);
		set('girlfriend', PlayState.instance.iconP1);
		set('opponent', PlayState.instance.dad);
		set('enemy', PlayState.instance.dad);

		set('setBotplay', PlayState.instance.sebotplay);

		interp.execute(ast);
	}

	public function call(func:String, ?var1, ?var2, ?var3)
	{
		if (interp.variables.exists(func))
			interp.variables.get(func)(var1, var2, var3);
		else
			return;
	}

	public function set(obj:String, val:Dynamic)
	{
		interp.variables.set(obj, val);
	}
}
