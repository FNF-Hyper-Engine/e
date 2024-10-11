package funkin.shaders;

class BaseShader extends FlxShader // https://www.shadertoy.com/view/XtBXDt
{
    public var time:Array<Float> = [0.0];
	public function new()
	{
		super();
	
	}

	public function update(elapsed:Float)
	{
		time[0] += elapsed;
	}
}
