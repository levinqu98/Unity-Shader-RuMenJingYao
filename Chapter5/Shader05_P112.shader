// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shader Book/Chapter 5/False Color" {
//5.5.1 使用假彩色图像
	Properties {
		//去CSDN上抄的开关的代码
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

			//定义开关的关键词
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
			//使用Unity内置结构体，在UnityCG.cginc里找到appdata_full的定义：
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
			//}；
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

				#if _NORMAL_ON
				o.color = fixed4(v.normal * 0.5 + fixed3(0.5, 0.5, 0.5), 1.0);
				#endif
				//可视化法线方向

				#if _TANGENT_ON
				o.color = fixed4(v.tangent * 0.5 + fixed3(0.5, 0.5, 0.5), 1.0);
				#endif
				//可视化切线方向

				#if _BIONORMAL_ON
				fixed3 binormal = cross(v.normal, v.tangent.xyz) * v.tangent.w;
				o.color = fixed4(binormal * 0.5 + fixed3(0.5, 0.5, 0.5), 1.0);
				#endif
				//可视化副法线方向
				//副法线：垂直于法线-切线平面的直线，因此可以用法线和切线叉乘
				//TBN即切线副法线和法线组成的坐标系
				//某点的切线有无数方向，一般用模型UV展开相同的方向作为切线方向
				//v.tangent.w的值为-1或+1，w分量进一步决定了取叉乘结果的正方向还是反方向

				#if _TEXCOORD_ON
				o.color = fixed4(v.texcoord.xy, 0.0, 1.0);
				#endif
				//可视化第一组纹理坐标
				//这时颜色应该是RGBA(v.texcoord.x, v.texcoord.y, 0, 1)

				#if _TEXCOORD1_ON
				o.color = fixed4(v.texcoord1.xy, 0.0, 1.0);
				#endif
				//可视化第二组纹理坐标
				//这时颜色应该是RGBA(v.texcoord.x, v.texcoord.y, 0, 1)

				#if _FRACTEXCOORD_ON
				o.color = frac(v.texcoord);
				if (any(saturate(v.texcoord) - v.texcoord)) {
					o.color.b = 0.5;
				}
				o.color.a = 1.0;
				#endif
				//可视化第一组纹理坐标的小数部分

				#if _FRACTEXCOORD1_ON
				o.color = frac(v.texcoord1);
				if (any(saturate(v.texcoord1) - v.texcoord1)) {
					o.color.b = 0.5;
				}
				o.color.a = 1.0;
				#endif
				//可视化第二组纹理坐标的小数部分

				#if _VERTEXCOLOR_ON
				o.color = v.color;
				#endif
				//可视化顶点颜色

				return o;
			}

			fixed4 frag(v2f i) : SV_Target {
				return i.color;
			}

			ENDCG
		}
	}
}