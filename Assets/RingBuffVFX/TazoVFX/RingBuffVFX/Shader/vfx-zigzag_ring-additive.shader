Shader "Tazo/vfx/zigzag_ring-additive"
{
	Properties
	{
		[HDR]_TintColor  ("Color", Color)   = (1,1,1,1)
		[NoScaleOffset]_MainTex    ("NoiseTexture(R)", 2D)         = "white" {}
		_N_effect("Noise Effect", range(0.0,1.0)) = 0
		_Gain       ("Gain", Range(1,100))    = 2 
		_CircleCut("CircleCut", Range(-0.01,1)) = 0.5
		
			[Header(Wave1)]
		_WaveLen("WaveLen 1", range(0.0,5000.0)) = 6.283
		_Speed("Speed 1", range(0.0,100.0)) = 10
		_Amptitude("Amptitude 1", range(0.0,1.0)) = 0.556

		[Header(Wave2)]
		_WaveLen2("WaveLen 2", range(0.0,5000.0)) = 12.5
		_Speed2("Speed 2", range(0.0,10.0)) = 9.72
		_Amptitude2("Amptitude 2", range(0.0,1.0)) = 0.27

			[PowerSlider(2)]_Z_scale("Strength ", range(0.0,10)) = 1.0
	}
	SubShader
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
		Blend SrcAlpha One
		Cull Off Lighting Off ZWrite Off Fog { Color (0,0,0,0) }
		LOD 100
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv     : TEXCOORD0;
				fixed4 color  : COLOR;
			};
			struct v2f
			{
				float4 uv     : TEXCOORD0;
				float4 vertex : SV_POSITION;
				fixed4 color  : COLOR;  
			};
			fixed4      _TintColor;
			sampler2D   _MainTex;
			float4      _MainTex_ST;
			fixed       _Gain;
			fixed  _CircleCut;
			fixed _Speed;
			fixed _WaveLen;
			fixed _Amptitude;
			fixed _Z_scale;
			fixed _Speed2;
			fixed _WaveLen2;
			fixed _Amptitude2;
			fixed _N_effect;
			v2f vert (appdata v)
			{
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f, o);
				float4 object_vertex = v.vertex;
			
				o.uv.xy = v.uv;
				o.uv.r = tex2Dlod(_MainTex, float4(v.uv + _Time.z, 0, 0)).r;

				o.uv.w = ((atan2(v.uv.x - 0.5, v.uv.y - 0.5).r / 6.283185) + 0.5);
				float new_y = (o.uv.w * _WaveLen + _Time.z * _Speed);
				float hh = sin(new_y) * _Amptitude;
				float new_y2 = (o.uv.w * _WaveLen2 + _Time.z * _Speed2);
				float hh2 = sin(new_y2) * _Amptitude2;
				object_vertex.z += (_Z_scale)*lerp(1, o.uv.r, _N_effect) * (hh + hh2);

				o.vertex = UnityObjectToClipPos(object_vertex);
			
				o.color  = v.color;
				return o;
			}
			fixed4 frag (v2f i) : SV_Target
			{
				

				fixed4 Mycolor = i.color * _TintColor * _Gain;
				Mycolor.a     = i.color.a   * _TintColor.a * smoothstep(_CircleCut, _CircleCut+0.01, i.uv.w);
				return Mycolor;
			}
			ENDCG
		}
	}
}
