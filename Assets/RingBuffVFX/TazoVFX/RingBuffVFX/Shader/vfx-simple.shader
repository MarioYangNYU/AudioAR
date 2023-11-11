Shader "Tazo/vfx/simple"
{
	Properties
	{
		_TintColor  ("_TintColor", Color)   = (1,1,1,1)
		_MainTex    ("Texture", 2D)         = "white" {}
		_Gain       ("Gain", Range(1,50))    = 2              
	}
	SubShader
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
		Blend SrcAlpha OneMinusSrcAlpha
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
				float2 uv     : TEXCOORD0;
				float4 vertex : SV_POSITION;
				fixed4 color  : COLOR;  
			};
			fixed4      _TintColor;
			sampler2D   _MainTex;
			float4      _MainTex_ST;
			fixed       _Gain;
			v2f vert (appdata v)
			{
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f, o);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv     = TRANSFORM_TEX(v.uv, _MainTex);
				o.color  = v.color;
				return o;
			}
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				col.rgb   *= i.color.rgb * _TintColor.rgb * _Gain;
				col.a     *= i.color.a   * _TintColor.a;
				return col;
			}
			ENDCG
		}
	}
}
