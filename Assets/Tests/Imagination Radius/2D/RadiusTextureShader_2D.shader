﻿Shader "Unlit/RadiusTextureShader_2D"
{
	Properties
	{
		_MainTex("Imaginary Texture", 2D) = "white" {}
		_ReTex("Real Texture", 2D) = "white" {}
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

				sampler2D _MainTex;
				float4 _MainTex_TexelSize;
				sampler2D _ReTex;
				float4 _ReTex_TexelSize;

				// Spherical Mask
				float4 _AuraCenter;
				half _AuraRadius;
				half _AuraSoftness;

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
					half4 col_im = tex2D(_MainTex, i.uv);
					half4 col_re = tex2D(_ReTex, i.uv);

					half d = distance(i.pos, _AuraCenter);
					half sum = saturate((d - _AuraRadius) / - _AuraSoftness);
					half4 lerpColor = lerp(col_im, col_re, sum);

					return lerpColor;
				}
				ENDCG
			}
		}
}
