package funkin.converters;

class ChartConvertUtil
{
	/**
	 * Converts V-Slice charts to be compatible with this Engine or pre FNF-0.2.7.1.
	 * @param song The Songs name.
	 * @param jsoninput The name of the json File.
	 * @param diff Difficulty. [defaults to 'Normal or normal'.]
	 */
	public static inline function newToLegacy(song:String, jsoninput:String)
	{
		try
		{
			// Load an FNF (VSLICE) chart and set the difficulty level to "normal" if not specified
			var funkinVSlice = new FNFVSlice().fromFile("assets/vslicedata/" + song + '/' + jsoninput + '.json');

			// Convert the FNF (Vslice) chart format to the FNF (this) format
			var funkinLegacy = new FNFLegacy();
			var json = funkinLegacy.fromFormat(funkinVSlice);

			return json;
		}
		catch (e:Dynamic)
		{
			trace(e);
			return Assets.getText('assets/data/tutorial/tutorial-hard.json');
		}
	}
}
