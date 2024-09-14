package funkin;

import lime.utils.Assets;

class PlayState extends FlxState
{
	var cpuStrums:StrumLine;
	var playerStrums:StrumLine;

	override public function create()
	{
		super.create();

		cpuStrums = new StrumLine(60, 50, 0);
		add(cpuStrums.strumNotes);
		add(cpuStrums);

		playerStrums = new StrumLine(FlxG.width * 0.6, 50, 1);
		add(playerStrums.strumNotes);
		add(playerStrums);
	}

	override public function update(elapsed:Float)
	{
		keyShit(elapsed);
		super.update(elapsed);
	}

	function keyShit(elapsed:Float)
	{
		var keys = FlxG.keys.getIsDown();
		var upP = FlxG.keys.anyJustPressed([W, UP]);
		var rightP = FlxG.keys.anyJustPressed([D, RIGHT]);
		var downP = FlxG.keys.anyJustPressed([S, DOWN]);
		var leftP = FlxG.keys.anyJustPressed([A, LEFT]);

		var upR = FlxG.keys.anyJustReleased([W, UP]);
		var rightR = FlxG.keys.anyJustReleased([D, RIGHT]);
		var downR = FlxG.keys.anyJustReleased([S, DOWN]);
		var leftR = FlxG.keys.anyJustReleased([A, LEFT]);
		var keyShit = [leftP, downP, upP, rightP];
		var keyShit2 = [leftR, downR, upR, rightR];
		for (i in 0...keyShit.length)
		{
			var key = keyShit[i];
			if (key)
			{
				trace("PRESSED: " + i);
				var strum:StrumNote = playerStrums.strumNotes.members[i];
				strum.playAnim(i + 'static', true);
			}
			else if (keyShit2[i])
			{
				var strum:StrumNote = playerStrums.strumNotes.members[i];
				strum.playAnim('$i', false);
			}
		}
	}
}
