/*
 * Copyright (c) 2024 // 494kd
 */

/**
 * The Beathit Function.
 * @param curBeat  The current beat.
 */
function onBeatHit(curBeat:Int)
{
	FlxTween.tween(game.camHUD, {zoom: camHUD.zoom + 0.03}, 0.1);
}

/**
 * Update Function.
 * @param elapsed  MS between frames.
 */
function onUpdate(elapsed:Float) {}

/**
 * Like update, but after  super.update();.
 * @param elapsed 
 */
function onUpdatePost(elapsed:Float) {}

/**
 * Fires every section.
 * @param curSection  Current Srction.
 */
function onSectionHit(curSection:Int) {}

/**
 * Before super.create(); .
 */
function onCreate() {}

/**
 * After super.create(); .
 */
function onCreatePost()
{
	game.camGame.visible = false;
}

/**
 * Fires every step.
 * @param curStep  Current Stephit.
 */
function onStepHit(curStep:Int)
{
	if (curStep == 144)
		game.camHUD.visible = true;
	trace(curStep);
}
