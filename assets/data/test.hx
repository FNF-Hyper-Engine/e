var bool:Bool = false;

function onBeatHit(curBeat:Int)
{
	if (bool)
		game.iconP1.angle = 20;
	else
		game.iconP1.angle = -20;
	bool = !bool;

	FlxTween.tween(game.iconP1, {angle: 0}, 0.3);
}

function onUpdate(elapsed:Float) {}

function onUpdatePost(elapsed:Float)
{
	game.iconP2.angle = game.iconP1.angle;
    

}

function onSectionHit(curSection:Int) {}
function onCreatePost() {}
function onCreate() {}
