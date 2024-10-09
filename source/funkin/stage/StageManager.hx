package funkin.stage;

import flixel.group.FlxSpriteGroup;

class StageManager
{
	public static var stageBack:FlxSpriteGroup;
	public static var curStage:String;

	public static function init(curSong:String, camGame:FlxCamera)
	{
		#if sys
		Sys.println('[Stage/PlayState]: Initialzing Stage for Song "$curSong" for camera $camGame for state ${Type.getClass(FlxG.state)}.');
		#else
		trace('[Stage/PlayState]: Initialzing Stage "$curStage" for camera $camGame for state ${Type.getClass(FlxG.state)}');
		#end
		stageBack = new FlxSpriteGroup();
		switch curSong
		{
			case 'triple-trouble':
				curStage = 'trioStage';

				var sky:BGSprite = new BGSprite('Phase3/normal/glitch', -621.1, -395.65, 1.0, 1.0);
				sky.active = false;
				stageBack.add(sky);

				var backbush:BGSprite = new BGSprite('Phase3/normal/BackBush', -621.1, -395.65, 1.0, 1.0);
				backbush.active = false;
				stageBack.add(backbush);

				var treeback:BGSprite = new BGSprite('Phase3/normal/TTTrees', -621.1, -395.65, 1.0, 1.0);
				treeback.active = false;
				stageBack.add(treeback);

				var topbushes:BGSprite = new BGSprite('Phase3/normal/TopBushes', -621.1, -395.65, 1.0, 1.0);
				topbushes.active = false;
				stageBack.add(topbushes);

				var fgTree1 = new BGSprite('Phase3/normal/FGTree1', -621.1, -395.65, 0.7, 0.7);
				fgTree1.active = false;

				var fgTree2 = new BGSprite('Phase3/normal/FGTree2', -621.1, -395.65, 0.7, 0.7);
				fgTree2.active = false;

				var p3staticbg = new FlxSprite(0, 0).loadGraphic(Paths.image("Phase3/NewTitleMenuBg"));
				p3staticbg.frames = Paths.getSparrowAtlas('NewTitleMenuBG');
				p3staticbg.animation.addByPrefix('idle', "TitleMenuSSBG instance 1", 24);
				p3staticbg.animation.play('idle');
				p3staticbg.screenCenter();
				p3staticbg.scale.x = 4.5;
				p3staticbg.scale.y = 4.5;
				p3staticbg.visible = false;
				stageBack.add(p3staticbg);

				var backtreesXeno = new BGSprite('Phase3/xeno/BackTrees', -621.1, -395.65, 1.0, 1.0);
				backtreesXeno.active = false;
				backtreesXeno.visible = false;
				stageBack.add(backtreesXeno);

				var grassXeno = new BGSprite('Phase3/xeno/Grass', -621.1, -395.65, 1.0, 1.0);
				grassXeno.active = false;
				grassXeno.visible = false;
				stageBack.add(grassXeno);
			default:
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stage/default/stageback'));
				// bg.setGraphicSize(Std.int(bg.width * 2.5));
				// bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				stageBack.add(bg);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stage/default/stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				stageBack.add(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stage/default/stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				// stageCurtains.active = false;
				stageBack.add(stageCurtains);
		}
	}

	public static function reset()
	{
		stageBack.kill();
	}

	public static function charposcrap(dad:Character, gf:Character, bf:Character)
	{
		switch curStage
		{
			case 'trioStage':
				dad.y -= 100;
				gf.x -= 400;
				gf.y -= 130;
				bf.x -= 100;
				bf.y -= 100;
				PlayState.instance.defaultCamZoom = 0.9;
				gf.kill();
			default:
				trace("");	
		}
	}
}
