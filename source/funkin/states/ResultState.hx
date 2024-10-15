package funkin.states;

class ResultState extends MusicBeatState
{
	var parsedString:String;

	var flxText:FlxText;

	var bgCrap:FunkinSprite;

	var confirm:FlxButton;

    







	public function new(resStuff:SongRating)
	{
		super();

		parsedString = 'Song: ${resStuff.SongResults.song}\nDifficulty: ${resStuff.SongResults.diff}\nWeek: ${resStuff.SongResults.week}\nSicks: ${resStuff.SongResults.sicks}';
		parsedString += '\nGoods: ${resStuff.SongResults.goods}\nBads: ${resStuff.SongResults.bads}\nShits: ${resStuff.SongResults.shits}\nScore: ${resStuff.SongResults.score}\nSpeed: ${resStuff.SongResults.songSpeed}\nPlayers: ${resStuff.SongResults.players}';
	}

	override function create()
	{
		setCameraTransform(null, {zoom: 1, angle: 0});
		FlxG.sound.playMusic(Paths.sound('synthloop'), 1, true);
		// trace(parsedString); // old trace gone ;(

		bgCrap = new FunkinSprite(0, 0);
		bgCrap.loadGraphic(Paths.image('menunshit/menuDesat'));
		add(bgCrap);

		flxText = new FlxText(0, 0);
		flxText.text = parsedString;
		flxText.setFormat('assets/fonts/InriaSans-Bold.ttf', 20);
		add(flxText);

		confirm = new FlxButton(0, 0, 'Confirm/Exit to Menu', () -> endShit());
		add(confirm);

		super.create();
	}

	var dur:Float = 0.4;

	function endShit():Void
	{
		FlxG.sound.play('assets/sounds/confirmMenu.ogg');

		FlxTween.tween(FlxG.camera, {angle: 1, alpha: 0, zoom: 1.4}, dur * 2, {ease: FlxEase.sineInOut});

		new FlxTimer().start(dur * 2, (timer:FlxTimer) ->
		{
			FlxG.switchState(new funkin.states.MainMenuState());
		});
	}

	override function destroy()
	{
		FlxG.sound.music.stop();

		FlxG.sound.music.destroy();
		super.destroy();
	}
}
