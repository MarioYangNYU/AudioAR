Shader "Tazo/vfx/intestines-additive_LWRP"
{
	Properties
	{
		_TintColor  ("_TintColor", Color)   = (1,1,1,1)
		[NoScaleOffset]_MainTex    ("Texture(R)", 2D)         = "white" {}
		_Gain       ("Gain", Range(1,50))    = 2     
		_FresnelThreshold("_Fresnel Threshold",  Range(-10, 10)) = 2.62
		_thick("thick",  Range(-2, 2)) = 0
		_deform_power("deform stregth",  Range(0, 10)) = 0
		_deform_speed("deform speed",  Range(0, 10)) = 0
		_deform_tiling("Tiling",  Range(0, 10)) = 0

		_TintColor2("_TintColor 2", Color) = (1,1,1,1)
		[NoScaleOffset]_MainTex2("Texture(R) 2", 2D) = "white" {}
		_Gain2("Gain 2", Range(1,50)) = 2
		_FresnelThreshold2("_Fresnel Threshold 2",  Range(-10, 10)) = -0.8
		_thick2("thick",  Range(-2, 2)) = 0
		_deform_power2("deform stregth 2",  Range(0, 10)) = 0
		_deform_speed2("deform speed 2",  Range(-10, 10)) = 0
		_deform_tiling2("Tiling 2",  Range(0, 10)) = 0
		[Header(CutOff)]
		_CircleCut("CircleCut", Range(-0.01,1)) = -0.01
	}
	SubShader
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
		
		Blend SrcAlpha One
		Lighting Off ZWrite Off Fog { Color (0,0,0,0) }
		LOD 100
		Pass
		{
			//Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
			//Tags{ "LightMode" = "SRPDefaultUnlit" }
			Tags {"LightMode" = "LightweightForward"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv     : TEXCOORD0;
				fixed4 color  : COLOR;
				fixed3 normal : NORMAL;
			};
			struct v2f
			{
				float2 uv     : TEXCOORD0;
				float4 vertex : SV_POSITION;
				fixed4 color  : COLOR;  
				fixed3 worldNormal : NORMAL;
				fixed3 viewDir : TEXCOORD1;
			};
			fixed4      _TintColor;
			sampler2D   _MainTex;
	
			fixed       _Gain;
			fixed _FresnelThreshold;
			fixed  _CircleCut;
			fixed _deform_power;
			fixed _deform_speed;
			fixed _deform_tiling;
			fixed _thick;
			v2f vert (appdata v)
			{
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f, o);
				o.viewDir = normalize(ObjSpaceViewDir(v.vertex));
				o.worldNormal = v.normal;
				//o.worldNormal = UnityObjectToWorldNormal(v.normal);
				//o.viewDir = WorldSpaceViewDir(v.vertex);
				
				fixed p = ((tex2Dlod(_MainTex, float4(v.uv * _deform_tiling + _Time.z * _deform_speed , 0, 0)).r) )* _deform_power;
				float3 after_v = v.vertex + v.normal * p + v.normal * _thick;
				o.vertex = UnityObjectToClipPos(after_v);
				o.color  = v.color;
				o.uv = v.uv;
				return o;
			}
			fixed4 frag (v2f i) : SV_Target
			{
				fixed rimDot = abs(dot(i.viewDir, i.worldNormal));
				fixed fresnel = (pow(rimDot, _FresnelThreshold));
				
				fixed4 col = fixed4(1,1,1,1);
				col.rgb   = i.color.rgb * _TintColor.rgb * _Gain;
				col.a     *= i.color.a   * _TintColor.a*(fresnel)*smoothstep(_CircleCut, _CircleCut + 0.01, i.uv.y);
				return col;
			}
			ENDCG
		}

			Pass
				{
				
					Tags{ "LightMode" = "SRPDefaultUnlit" }
					CGPROGRAM
					#pragma vertex vert
					#pragma fragment frag
					#include "UnityCG.cginc"
					struct appdata
					{
						float4 vertex : POSITION;
						float2 uv     : TEXCOORD0;
						fixed4 color : COLOR;
						fixed3 normal : NORMAL;
					};
					struct v2f
					{
						float2 uv     : TEXCOORD0;
						float4 vertex : SV_POSITION;
						fixed4 color : COLOR;
						fixed3 worldNormal : NORMAL;
						fixed3 viewDir : TEXCOORD1;
					};
					fixed4      _TintColor2;
					sampler2D   _MainTex2;

					fixed       _Gain2;
					fixed _FresnelThreshold2;
					fixed  _CircleCut;
					fixed _deform_power2;
					fixed _deform_speed2;
					fixed _deform_tiling2;
					fixed _thick2;
					v2f vert(appdata v)
					{
						v2f o;
						UNITY_INITIALIZE_OUTPUT(v2f, o);
						o.viewDir = normalize(ObjSpaceViewDir(v.vertex));
						o.worldNormal = v.normal;
						//o.worldNormal = UnityObjectToWorldNormal(v.normal);
						//o.viewDir = WorldSpaceViewDir(v.vertex);

						fixed p = ((tex2Dlod(_MainTex2, float4(v.uv * _deform_tiling2 + _Time.z * _deform_speed2 , 0, 0)).r)) * _deform_power2;
						float3 after_v = v.vertex + v.normal * p + v.normal * _thick2;
						o.vertex = UnityObjectToClipPos(after_v);
						o.color = v.color;
						o.uv =v.uv ;
						return o;
					}
					fixed4 frag(v2f i) : SV_Target
					{
						fixed rimDot = abs(dot(i.viewDir, i.worldNormal));
						fixed fresnel = (pow(rimDot, _FresnelThreshold2));

						fixed4 col = fixed4(1,1,1,1);
						col.rgb = i.color.rgb * _TintColor2.rgb * _Gain2;
						col.a *= i.color.a * _TintColor2.a * (fresnel) *smoothstep(_CircleCut, _CircleCut + 0.01, i.uv.y);
						return col;
					}
					ENDCG
				}


	}
		
				
		
}
