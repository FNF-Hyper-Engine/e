package funkin.shaders;

class BlurShader extends BaseShader // https://www.shadertoy.com/view/XtBXDt
{
	@:glFragmentSource('
 #pragma header

            uniform float sigma = 2;

            void main()
            {
                vec2 uv = openfl_TextureCoordv*openfl_TextureSize/vec3(openfl_TextureSize, 0.).xy;
                
                vec4 texCol = flixel_texture2D(bitmap, uv);

                
                int radius = 5;
                float pi = 3.1415926;
                
                
                vec4 gaussSum = vec4(0.);
                
                for(int x = -radius; x <= radius; x++){
                    for(int y = -radius; y <= radius; y++){
                        vec2 newUV = (openfl_TextureCoordv*openfl_TextureSize + vec2(x,y))/vec3(openfl_TextureSize, 0.).xy;
                        vec4 newTexCol = flixel_texture2D(bitmap, newUV);
                        gaussSum += flixel_texture2D(bitmap, newUV) * (exp(-(pow(float(x), 2.) + pow(float(y), 2.)) / (2. * pow(sigma, 2.))) / (2. * pi * pow(sigma, 2.)));
                    }   
                }
                

                
                gl_FragColor = vec4(gaussSum);
            }

    ')
	public function new()
	{
		super();
		canUpdate = false;
	}


}
