package funkin.helpers;

import flixel.graphics.frames.FlxAtlasFrames;

class Paths
{
	public static var level = '';

	inline public static function setPathLevel(lvl:String = '')
	{
		level = lvl;
		// trace('[INFO]: Folder-Path-Level set to "$level".');
	}

	inline public static function getPath(fileName:String, ext:String)
	{
		// //trace('Loading "assets/images/$fileName$ext".');
		return 'assets/images/$fileName$ext';
	}

	inline public static function ui(file:String)
	{
		return 'assets/shared/ui/$file.xml';
	}

	inline public static function getSharedPath(file:String = '')
	{
		return 'assets/shared/$file';
	}

	inline public static function image(fileName:String, ext:String = '.png')
	{
		return getPath(fileName, ext);
	}

	inline public static function inst(song:String = 'tutorial', inst:String = 'Inst', ext:String = '.ogg')
	{
		return 'assets/songs/$song/$inst$ext';
	}

	inline public static function xml(fileName:String, ext:String = '.xml')
	{
		return getPath(fileName, ext);
	}

	inline public static function getSparrowAtlas(fileName:String)
	{
		// //trace('Loading  SparrowAtlas: "$fileName".');
		return FlxAtlasFrames.fromSparrow(image(fileName), xml(fileName));
	}

	public static function sound(s:String) {
		return 'assets/sounds/$s.ogg';
	}
}
