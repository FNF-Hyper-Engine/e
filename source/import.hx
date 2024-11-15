/*
 * Copyright (c) 2024 // 494kd
 */

/**
 * flixel doo doo
 */
#if (!macro)
import flixel.FlxCamera;
import funkin.objects.countdown.*;
import flixel.system.FlxAssets.FlxShader;
import openfl.filters.ShaderFilter;
import funkin.params.*;
import funkin.shaders.*;
import funkin.gameplay.*;
import funkin.gameplay.objects.*;
import funkin.gameplay.objects.char.*;
import flixel.util.FlxSave;
import funkin.states.editors.CharacterEditorState;
import funkin.scripting.HScript;
import flixel.util.*;
import funkin.stage.StageManager;
import flixel.FlxBasic;
import funkin.backend.*;
import funkin.states.editors.*;
import flixel.FlxObject;
import funkin.gameplay.objects.char.Character.CharacterFile;
import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxSprite;
import flixel.addons.display.FlxPieDial;
import flixel.group.FlxGroup;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.system.FlxSound;
import flixel.graphics.FlxGraphic;
import flixel.text.FlxText;
import funkin.handlers.CountdownHandler;
import flash.geom.Rectangle;
import flixel.addons.ui.interfaces.IFlxUIClickable;
import flixel.addons.ui.interfaces.IFlxUIWidget;
import flixel.addons.ui.interfaces.IHasParams;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxStringUtil;
import flixel.addons.ui.FlxUIGroup;
import flixel.addons.ui.FlxUIText;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUISpriteButton;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUIAssets;
import flixel.addons.ui.StrNameLabel;
import flixel.addons.ui.FlxUI;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import funkin.ui.*;
import openfl.display.BitmapData;
import funkin.backend.CoolUtil;
import haxe.ui.backend.flixel.CursorHelper;
import funkin.song.Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUITooltip.FlxUITooltipStyle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;
import flixel.util.FlxColor;
import haxe.Json;
import lime.utils.Assets;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.media.Sound;
import openfl.net.FileReference;
import openfl.utils.ByteArray;
import openfl.utils.Assets as OpenFlAssets;
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
import flixel.addons.text.FlxTypeText;

import openfl.display.StageScaleMode;
import flixel.addons.text.FlxTypeText;
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
