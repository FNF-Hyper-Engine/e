package funkin.stage;

import flixel.group.FlxSpriteGroup;

class StageManager
{
	public static var stageBack:FlxSpriteGroup;

	public static function init(curStage:String, camGame:FlxCamera)
	{
		#if sys
		Sys.println('[Stage/PlayState]: Initialzing Stage "$curStage" for camera $camGame for state ${Type.getClass(FlxG.state)}.');
		#else
		trace('[Stage/PlayState]: Initialzing Stage "$curStage" for camera $camGame for state ${Type.getClass(FlxG.state)}');
		#end
		stageBack = new FlxSpriteGroup();
		switch curStage
		{
			default:
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stage/$curStage/stageback'));
				// bg.setGraphicSize(Std.int(bg.width * 2.5));
				// bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				stageBack.add(bg);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stage/$curStage/stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				stageBack.add(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stage/$curStage/stagecurtains'));
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
}
