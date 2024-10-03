package funkin.states;

import flixel.effects.FlxFlicker;
import lime.app.Application;

class MainMenuState extends MusicBeatState
{
	var instant = false;
	var selectables:FlxTypedGroup<FunkinSprite>;
	var menuItems:Array<String> = ['storymode', 'freeplay', 'credits', 'merch', 'options'];
	var camFollow:FlxObject;

	var selectedSomethin:Bool = false;
	var curSelected:Int = 0;

	override function create()
	{
		instant = false;
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

		if (!selectedSomethin)
		{
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
								FlxG.switchState(new funkin.PlayState());
								trace("Story Menu Selected");
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

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;

			selectables.forEach(function(spr:FlxSprite)
			{
				spr.animation.play('idle');

				if (spr.ID == curSelected)
				{
					spr.animation.play('selected');
					FlxG.camera.follow(camFollow, null, 0.06);
					camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
				}

				spr.updateHitbox();
			});
		}
	}
