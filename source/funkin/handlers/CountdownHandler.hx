package funkin.handlers;

/**
 * The Handler responsible for the Countdown.
 */
class CountdownHandler extends FlxTypedGroup<CountdownSprite>
{
	public var onCompleteCallBack:Void->Void;

	public function new(END:Void->Void)
	{
		super();

		if (END != null)
			onCompleteCallBack = END;
		else
			onCompleteCallBack = throw 'Callback required.';
	}

	public function startass()
	{
		attemptCountdown(onCompleteCallBack);
	}

	function attemptCountdown(END:Void->Void)
	{
		var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
		introAssets.set('default', ['go', 'go', 'ready', "set", "go"]);
		trace(introAssets);

		var introAlts:Array<String> = introAssets.get('default');
		var altSuffix:String = "";
		var loopsleft = 4;
		var countDown:CountdownSprite;
		var count:Int = 0;
		var fatarray = ['ready', "set", "go"];
	
		new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			loopsleft--;
			count += 1;
			trace("The Countdown has been ran " + count + ' times.');
			countDown = new CountdownSprite(0, 0, 'go');
			countDown.alpha = 0;
			add(countDown);

			switch (loopsleft)
			{
				case 3:
					FlxG.sound.play('assets/sounds/countdown/funkin/introTHREE.ogg');
				case 2:
					FlxG.sound.play('assets/sounds/countdown/funkin/introTWO.ogg');

					countDown.ass('ready');
					countDown.alpha = 1;
					countDown.screenCenter();

					FlxTween.tween(countDown, {alpha: 0}, Conductor.crochet / 1000 * 0.7);

				case 1:
					FlxG.sound.play('assets/sounds/countdown/funkin/introONE.ogg');

					countDown.ass('set');
					countDown.alpha = 1;
					countDown.screenCenter();

					FlxTween.tween(countDown, {alpha: 0}, Conductor.crochet / 1000 * 0.7);
				case 0:
					FlxG.sound.play('assets/sounds/countdown/funkin/introGO.ogg');

					//	countDown.kill();
					// remove(countDown);
					//	countDown.destroy();
			}

			if (loopsleft < 1)
			{
				countDown.ass('go');
				countDown.alpha = 1;
				countDown.screenCenter();

				FlxTween.tween(countDown, {alpha: 0}, Conductor.crochet / 1000 * 0.7, {
					onComplete: function(T:FlxTween)
					{
						END();
						kill();
						destroy();
					}
				});
			}
		}, loopsleft);
	}
}
