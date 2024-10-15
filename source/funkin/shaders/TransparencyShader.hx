package funkin.shaders;

class TransparencyShader extends BaseShader // https://www.shadertoy.com/view/XtBXDt
{
	@:glFragmentSource("
         // Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel
#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define iChannel1 bitmap
#define iChannel2 bitmap
#define iChannel3 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

void mainImage()
{
	vec4 originalColor = texture(iChannel0, uv);
	originalColor.a = originalColor.a != 0.0 ? 0.6 : originalColor.a;
	fragColor = originalColor;
}
    ")
	public function new()
	{
		super();
		canUpdate = true;
       // iTimeDelta.value = [0.0];
       // iTime.value = [0.0];
	}
    override  function update(elapsed:Float) {
        super.update(elapsed);
       // iTime.value[0] += time[0];
       // iTimeDelta.value = time;
    } 
}
