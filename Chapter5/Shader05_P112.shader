// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shader Book/Chapter 5/False Color" {
//5.5.1 ʹ�üٲ�ɫͼ��
	Properties {
		//ȥCSDN�ϳ��Ŀ��صĴ���
		// Toggle displays a **float** as a toggle. 
        // The property value will be 0 or 1, depending on the toggle state. 
        // When it is on, a shader keyword with the uppercase property name +"_ON" will be set, 
        // or an explicitly specified shader keyword.
		[Toggle] _Normal ("Visualize Normal", Float) = 0
		[Toggle] _Tangent ("Visualize Tangent", Float) = 0
		[Toggle] _Bionormal ("Visualize Bionormal", Float) = 0
		[Toggle] _Texcoord ("Visualize Texcoord", Float) = 0
		[Toggle] _Texcoord1 ("Visualiza Texcoord1", Float) = 0
		[Toggle] _FracTexcoord ("Visualiza FracTexcoord", Float) = 0
		[Toggle] _FracTexcoord1 ("Visualize FracTexcoord1", Float) = 0
		[Toggle] _VertexColor ("Visualize VertexColor", Float) = 0
	}

	SubShader {
		Pass {
			CGPROGRAM

			//���忪�صĹؼ���
			// Need to define shader keyword
            #pragma shader_feature _NORMAL_ON
			#pragma shader_feature _TANGENT_ON
			#pragma shader_feature _BIONORMAL_ON
			#pragma shader_feature _TEXCOORD_ON
			#pragma shader_feature _TEXCOORD1_ON
			#pragma shader_feature _FRACTEXCOORD_ON
			#pragma shader_feature _FRACTEXCOORD1_ON
			#pragma shader_feature _VERTEXCOLOR_ON

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct v2f {
				float4 pos : SV_POSITION;
				fixed4 color : COLOR0;
			};

			v2f vert(appdata_full v) {
			//ʹ��Unity���ýṹ�壬��UnityCG.cginc���ҵ�appdata_full�Ķ��壺
			//struct appdata_full {
			//	float4 vertex : POSITION;
			//	float4 tangent : TANGENT;
			//	float3 normal : NORMAL;
			//	float4 texcoord : TEXCOORD0;
			//	float4 texcoord1 : TEXCOORD1;
			//	float4 texcoord2 : TEXCOORD2;
			//	float4 texcoord3 : TEXCOORD3;
			// #if defined(SHADER_API_XBOX360)
			//	half4 texcoord4 : TEXCOORD4;
			//	half4 texcoord5 : TEXCOORD5;
			// #endif
			//	fixed4 color : COLOR;
			//}��
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

				#if _NORMAL_ON
				o.color = fixed4(v.normal * 0.5 + fixed3(0.5, 0.5, 0.5), 1.0);
				#endif
				//���ӻ����߷���

				#if _TANGENT_ON
				o.color = fixed4(v.tangent * 0.5 + fixed3(0.5, 0.5, 0.5), 1.0);
				#endif
				//���ӻ����߷���

				#if _BIONORMAL_ON
				fixed3 binormal = cross(v.normal, v.tangent.xyz) * v.tangent.w;
				o.color = fixed4(binormal * 0.5 + fixed3(0.5, 0.5, 0.5), 1.0);
				#endif
				//���ӻ������߷���
				//�����ߣ���ֱ�ڷ���-����ƽ���ֱ�ߣ���˿����÷��ߺ����߲��
				//TBN�����߸����ߺͷ�����ɵ�����ϵ
				//ĳ�����������������һ����ģ��UVչ����ͬ�ķ�����Ϊ���߷���
				//v.tangent.w��ֵΪ-1��+1��w������һ��������ȡ��˽�����������Ƿ�����

				#if _TEXCOORD_ON
				o.color = fixed4(v.texcoord.xy, 0.0, 1.0);
				#endif
				//���ӻ���һ����������
				//��ʱ��ɫӦ����RGBA(v.texcoord.x, v.texcoord.y, 0, 1)

				#if _TEXCOORD1_ON
				o.color = fixed4(v.texcoord1.xy, 0.0, 1.0);
				#endif
				//���ӻ��ڶ�����������
				//��ʱ��ɫӦ����RGBA(v.texcoord.x, v.texcoord.y, 0, 1)

				#if _FRACTEXCOORD_ON
				o.color = frac(v.texcoord);
				if (any(saturate(v.texcoord) - v.texcoord)) {
					o.color.b = 0.5;
				}
				o.color.a = 1.0;
				#endif
				//���ӻ���һ�����������С������

				#if _FRACTEXCOORD1_ON
				o.color = frac(v.texcoord1);
				if (any(saturate(v.texcoord1) - v.texcoord1)) {
					o.color.b = 0.5;
				}
				o.color.a = 1.0;
				#endif
				//���ӻ��ڶ������������С������

				#if _VERTEXCOLOR_ON
				o.color = v.color;
				#endif
				//���ӻ�������ɫ

				return o;
			}

			fixed4 frag(v2f i) : SV_Target {
				return i.color;
			}

			ENDCG
		}
	}
}