package funkin.substates;

import flixel.effects.FlxFlicker;
import lime.app.Application;

class PauseSubState extends FlxSubState
{
	var instant = false;
	var selectables:FlxTypedGroup<Alphabet>;
	var menuItems:Array<String> = ['resume', 'exit'];
	var camFollow:FlxObject;

	var selectedSomethin:Bool = false;
	var curSelected:Int = 0;

	override function create()
	{
		instant = false;
		selectables = new FlxTypedGroup<Alphabet>();
		for (i in 0...menuItems.length)
		{
			var string:String = menuItems[i];
			var menuCrap:Alphabet;
			menuCrap = new Alphabet(0, 60 + (i * 160), string);

			menuCrap.ID = i;

			menuCrap.screenCenter(X);
			//	menuCrap.y += menuCrap.height * i;

			selectables.add(menuCrap);
			menuCrap.scrollFactor.set(0.1, 0.5);
			menuCrap.antialiasing = true;
		}
		add(selectables);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		FlxG.camera.follow(camFollow, null, 0.06);

		changeItem();
		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		#if (!android)
		if (FlxG.keys.justPressed.UP)
		{
			FlxG.sound.play('assets/sounds/scrollMenu.ogg');
			changeItem(-1);
		}

		if (FlxG.keys.justPressed.DOWN)
		{
			FlxG.sound.play('assets/sounds/scrollMenu.ogg');
			changeItem(1);
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			// selectedSomethin = true;
			// FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);

			// FlxFlicker.flicker(magenta, 1.1, 0.15, false);

			var daChoice:String = menuItems[curSelected];

			switch (daChoice.toLowerCase())
			{
				case 'resume':
					close();
				case 'exit':
					#if sys
					Sys.exit(0);
					#else
					close();
					#end
			}
		}
		#end

		super.update(elapsed);

		selectables.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		selectables.forEach(function(spr:FlxSprite)
		{
			spr.alpha = 0.5;
			if (spr.ID == curSelected)
			{
				spr.alpha = 0.9;
				FlxG.camera.follow(camFollow, null, 0.06);
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
