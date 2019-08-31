Shader "Unlit/RadiusTextureShader"
{
    Properties
    {
        _ImTex ("Imaginary Texture", 2D) = "white" {}
		_ReTex("Real Texture", 2D) = "white" {}
		_Position("World Position", Vector) = (0,0,0,0)
		_Radius("Radius", Range(0, 100)) = 0
		_Softness("Softness", Range(0, 100)) = 0
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 100

		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _ImTex;
            float4 _ImTex_ST;
			sampler2D _ReTex;
			float4 _ReTex_ST;

			// Spherical Mask
			float4 _Position;
			half _Radius;
			half _Softness;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _ImTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col_im = tex2D(_ImTex, i.uv);
				fixed4 col_re = tex2D(_ReTex, i.uv);
				
				
				half d = distance(i.vertex, _Position);
				half sum = saturate((d - _Radius) / -_Softness);
				fixed4 lerpColor = lerp(col_im, col_re, sum);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return lerpColor;
            }
            ENDCG
        }
    }
}
