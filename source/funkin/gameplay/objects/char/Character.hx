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
	var animOffsets:Array<{name:String, offsetx:Float, offsety:Float}>;

	// Camera offsets: Array with x and y offset.
	var camOffsets:Array<Float>;
}

class Character extends FunkinSprite
{
	public var jsonFile:CharacterFile;

	public function new(?char:String = 'bf')
	{
		super(0, 0);
		jsonFile = parseCharacterFile(char);
	}

	public static function parseCharacterFile(json:String = 'bf'):CharacterFile
	{
		var fat = '';
		if (Assets.exists('assets/shared/characters/$json.json'))
			fat = Assets.getText('assets/shared/characters/$json.json')
		else
			fat = Assets.getText('assets/shared/characters/bf.json');

		var data = Json.parse(fat);

		// Extract the fields from the JSON data
		var hoe:CharacterFile = {
			char: data.char,
			scale: [data.scale[0], data.scale[1]],
			healthIcon: data.healthIcon,
			healthColors: data.healthColors,
			animOffsets: data.animOffsets.map(function(anim)
			{
				return {name: anim.name, offsetx: anim.offsetx, offsety: anim.offsety};
			}),
			camOffsets: [data.camOffsets[0], data.camOffsets[1]]
		};
		trace('Returning: ${hoe}');
		return hoe;
	}

	public static function parseJSONshit(rawJson:String):CharacterFile
	{
		var swagShit:CharacterFile = cast rawJson;

		return swagShit;
	}
}
