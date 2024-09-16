/*
 * Copyright (c) 2024 // 494kd
 */

/**
 * flixel doo doo
 */
#if (!macro)
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxSprite;

import flixel.addons.display.FlxPieDial;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.*;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import funkin.debug.*;
import funkin.helpers.*;
import funkin.objects.*;
import funkin.song.*;
import funkin.song.Section.SwagSection;
import funkin.song.Song.SwagSong;
import funkin.song.music.MusicBeatState;
import funkin.sprites.*;
import funkin.states.*;
import haxe.Json;
import haxe.Timer;
import haxe.format.JsonParser;
import lime.utils.Assets;
import lime.utils.Assets;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.display.StageScaleMode;
import openfl.events.DataEvent;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

using StringTools;

#if flxanimate
import flxanimate.FlxAnimate;
#end
#end
