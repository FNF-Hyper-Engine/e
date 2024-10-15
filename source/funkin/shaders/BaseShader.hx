package funkin.shaders;

class BaseShader extends FlxShader // https://www.shadertoy.com/view/XtBXDt
{
    public var time:Array<Float> = [0.0];
	public var canUpdate:Bool = true;
	public function new()
	{
		super();
	
	}

	public function update(elapsed:Float)
	{
		if(!canUpdate)
			return;
		time[0] += elapsed;
	}
}
