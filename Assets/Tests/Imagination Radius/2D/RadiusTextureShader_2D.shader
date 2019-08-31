Shader "Unlit/RadiusTextureShader_2D"
{
	Properties
	{
		_ImTex("Imaginary Texture", 2D) = "white" {}
		_ReTex("Real Texture", 2D) = "white" {}
		_Position("World Position", Vector) = (0,0,0,0)
		_Radius("Radius", Range(0, 100)) = 0
		_Softness("Softness", Range(0, 100)) = 0
	}
		SubShader
		{
			Cull Off

			Pass
			{
				CGPROGRAM
				#pragma vertex vertexFunc
				#pragma fragment fragmentFunc
				#include "UnityCG.cginc"


				struct v2f
				{
					half2 uv : TEXCOORD0;
					float4 pos : SV_POSITION;
				};

				sampler2D _ImTex;
				float4 _ImTex_TexelSize;
				sampler2D _ReTex;
				float4 _ReTex__TexelSize;

				// Spherical Mask
				float4 _Position;
				half _Radius;
				half _Softness;

				v2f vertexFunc(appdata_base v)
				{
					v2f o;
					o.pos = UnityObjectToClipPos(v.vertex);
					o.uv = v.texcoord;					
					return o;
				}

				fixed4 fragmentFunc(v2f i) : COLOR
				{
					// sample the texture
					half4 col_im = tex2D(_ImTex, i.uv);
					half4 col_re = tex2D(_ReTex, i.uv);

					half d = distance(i.pos, _Position);
					half sum = saturate((d - _Radius) / -_Softness);
					half4 lerpColor = lerp(col_im, col_re, sum);

					return lerpColor;
				}
				ENDCG
			}
		}
}
