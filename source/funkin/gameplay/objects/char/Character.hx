package funkin.gameplay.objects.char;

import tjson.TJSON;

typedef CharacterFile =
{
	// Name of the Character.
	var char:String;

	// Scale of the Character (represented by Array).
	var scale:Array<Int>;

	// Health icon and health bar color of the Character.
	var healthIcon:String;
	var healthColors:Array<Int>;

	// Animation offsets: Array of animations with their respective offsets.
	var animations:Array<AnimArray>;

	// Camera offsets: Array with x and y offset.
	var camOffsets:Array<Float>;
}

typedef AnimArray =
{
	var anim:String;
	var name:String;
	var fps:Int;
	var loop:Bool;
	var indices:Array<Int>;
	var offsets:Array<Int>;
}

class Character extends FunkinSprite
{
	public var jsonFile:CharacterFile;

	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var dancer:Bool = false;
	public var danced:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public var animationNotes:Array<Dynamic> = [];

	public function new(?char:String = 'bf')
	{
		super(0, 0);

		jsonFile = parseCharacterFile(char);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = jsonFile.char;

		if (Assets.exists(Paths.image('characters/${jsonFile.char}')))
			atlasFrames('characters/${jsonFile.char}');
		else
		{
			trace('Warning: ${Paths.image('characters/${jsonFile.char}')} doesnt exist. loading Default File: Boyfriend. ');
		}
		// trace(jsonFile.scale[0], jsonFile.scale[1]);

		var animationsArray = jsonFile.animations;
		for (i in 0...animationsArray.length)
		{
			var anim = animationsArray[i];
			var animName:String = anim.anim;
			var animfps = anim.fps;
			var prefix:String = anim.name;
			var offsets = anim.offsets;
			var looped = anim.loop;

			addByPrefix(animName, prefix, animfps, looped);
			addOffset(animName, offsets[0], offsets[1]);
			// playAnim('idle');
		}

		switch jsonFile.char
		{
			case 'gf':
				dancer = true;
				addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				playAnim('danceRight');
			case 'xeno':
				addByPrefix('idle', 'Beast_IDLE');
				playAnim("idle");

			case 'dad':
				addByPrefix('idle', 'Dad idle dance', 24, true);
				addByPrefix('singLEFT', 'dad sing note right', 24);
				addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				addByPrefix('singUP', 'Dad Sing note UP', 24);
				addByPrefix('singRIGHT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');

			case 'deadbf':
				addByPrefix('dies', 'BF dies', 24);
				addByPrefix('loop', 'BF Dead Loop', 24, true);
				addByPrefix('confirm', 'BF Dead confirm', 24);

				playAnim('dies');

			case 'bf':
				/*
					addByPrefix('idle', 'BF idle dance', 24, true);
					addByPrefix('singLEFT', 'BF NOTE LEFT', 24);
					addByPrefix('singDOWN', 'BF NOTE DOWN', 24);
					addByPrefix('singUP', 'BF NOTE UP', 24);
					addByPrefix('singRIGHT', 'BF NOTE RIGHT', 24);

					addOffset('idle', -5);
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -38, -7);
					addOffset("singLEFT", 12, -6);
					addOffset("singDOWN", -10, -50);
					addOffset("singUPmiss", -29, 27);
					addOffset("singRIGHTmiss", -30, 21);
					addOffset("singLEFTmiss", 12, 24);
					addOffset("singDOWNmiss", -11, -19);
					addOffset("hey", 7, 4);
					addOffset('firstDeath', 37, 11);
					addOffset('deathLoop', 37, 5);
					addOffset('deathConfirm', 37, 69);
					addOffset('scared', -4);
				 */
				playAnim('idle');
		}

		screenCenter();
	}

	public static function parseCharacterFile(json:String = 'bf'):CharacterFile
	{
		var fat = '';
		if (Assets.exists('assets/shared/characters/$json.json'))
			fat = Assets.getText('assets/shared/characters/$json.json');
		else
			fat = Assets.getText('assets/shared/characters/empty.json');

		var data = Json.parse(fat);

		// Extract the fields from the JSON data
		var hoe:CharacterFile = cast data;
		// trace('Returning: ${hoe}');
		return hoe;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (!dancer && animation.curAnim != null)
		{
			if (animation.curAnim.name.contains('sing')
				&& animation.curAnim.finished
				|| animation.curAnim.name.contains('idle')
				&& animation.curAnim.finished)
				playAnim('idle');
		}
	}

	public static function parseJSONshit(rawJson:String):CharacterFile
	{
		var swagShit:CharacterFile = cast rawJson;

		return swagShit;
	}

	override public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}

	public function dance()
	{
		danced = !danced;
		if (danced)
			playAnim('danceLeft');
		else
			playAnim('danceRight');
	}
}
