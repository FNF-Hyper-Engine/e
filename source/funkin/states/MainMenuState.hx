package funkin.states;

import flixel.effects.FlxFlicker;
import lime.app.Application;

class MainMenuState extends MusicBeatState
{
	var instant = false;
	var selectables:FlxTypedGroup<FunkinSprite>;
	var menuItems:Array<String> = ['storymode', 'freeplay', 'credits', 'merch', 'options'];
	var camFollow:FlxObject;

	var bgCrap:FunkinSprite;

	var selectedSomethin:Bool = false;
	var curSelected:Int = 0;

	override function create()
	{
		
	

		instant = false;

		bgCrap = new FunkinSprite(0, 0);
		bgCrap.loadGraphic(Paths.image('menunshit/menuDesat'));
		add(bgCrap);

		bgCrap.scrollFactor.set(0, 0.2);
		bgCrap.scale.set(1.3, 1.3);

		selectables = new FlxTypedGroup<FunkinSprite>();
		for (i in 0...menuItems.length)
		{
			var string:String = menuItems[i];
			var menuCrap:FunkinSprite;
			menuCrap = new FunkinSprite(0, 60 + (i * 160));
			menuCrap.atlasFrames('mainmenu/$string');
			menuCrap.addByPrefix('idle', '$string idle', 30, true);
			menuCrap.ID = i;
			menuCrap.addByPrefix('selected', '$string selected', 30, true);
			menuCrap.playAnim('idle');
			menuCrap.screenCenter(X);
			menuCrap.offset.x += menuCrap.width / 4 * i;
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
		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, 'v${Application.current.meta.get('version')} | Git Commit: NAN', 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("assets/fonts/InriaSans-BoldItalic.ttf", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			#if (!android)
			if (FlxG.keys.justPressed.UP)
			{
				changeItem(-1);
			}

			var scrollShit:Int = FlxG.mouse.wheel;

			switch (scrollShit)
			{
				case -1:
					changeItem(1);
				case 1:
					changeItem(-1);
			}

			if (FlxG.keys.justPressed.DOWN)
			{
				FlxG.sound.play('assets/sounds/scrollMenu.ogg');
				changeItem(1);
			}

			if (FlxG.keys.justPressed.BACKSPACE)
			{
				FlxG.switchState(new TitleState());
			}

			if (FlxG.keys.justPressed.ENTER)
			{
				selectedSomethin = true;
				FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);

				// FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				selectables.forEach(function(spr:FlxSprite)
				{
					FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
					{
						var daChoice:String = menuItems[curSelected];

						switch (daChoice)
						{
							case 'storymode':
								switchState(new funkin.PlayState());

							default:
								resetState();
						}
					});
				});
			}
			#end
		}

		super.update(elapsed);

		selectables.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		FlxG.sound.play('assets/sounds/scrollMenu.ogg');

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		selectables.forEach(function(spr:FlxSprite)
		{
			if (spr.ID == curSelected)
			{
				FlxTween.tween(spr, {alpha: 1,"offset.x":0}, 0.3);
				spr.animation.play('selected');
				FlxG.camera.follow(camFollow, null, 0.06);
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}
			else
			{
				spr.animation.play('idle');
				FlxTween.tween(spr, {alpha: 0.5,"offset.x":2}, 0.3);
			}

			//spr.updateHitbox();
		});
	}
}
