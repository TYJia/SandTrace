Shader "TJia/StepGenerator"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_StepBump ("Step Bump", 2D) = "bump" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass //Trace Generation
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			sampler2D _StepBump;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			float3 _DeltaPos;
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv + _DeltaPos.xz * 0.015);
				fixed4 stepCol = tex2D(_StepBump, (i.uv - 0.5) * 15 + 0.5);				

				
				
				fixed4 stepCol2 = tex2D(_StepBump, (i.uv - 0.5) * 10 + 0.5);
				stepCol2.rg = 1 - stepCol2.rg;
				stepCol = lerp(stepCol2, stepCol, stepCol.a);
				

				col = lerp(col, stepCol, saturate(stepCol.a - col.a));
				float cond = step(abs(i.uv.x - 0.5), 0.499) * step(abs(i.uv.y - 0.5), 0.499);
				col = lerp(float4(0.5,0.5,1,0), col, cond * 0.996);
				return col;
			}
			ENDCG
		}

		Pass //Init
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			float3 _DeltaPos;
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col;
				col = float4(0.5, 0.5, 1, 0);
				return col;
			}
			ENDCG
		}
	}
}
