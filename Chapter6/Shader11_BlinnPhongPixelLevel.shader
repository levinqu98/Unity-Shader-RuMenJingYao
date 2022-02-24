// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 6/Specular Vertex-Level" {
	Properties {
		_Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
		_Specular ("Specular", Color) = (1, 1, 1, 1)
		_Gloss ("Gloss", Range(8.0, 256)) = 20
	}

	SubShader {
		Pass {
			Tags { "LightMode" = "ForwardBase" }

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "Lighting.cginc"

		fixed4 _Diffuse;
		fixed4 _Specular;
		float _Gloss; // _Gloss的范围很大，用float精度来存储

		struct a2v {
			float4 vertex : POSITION;
			float3 normal : NORMAL;
		}; // 定义顶点着色器的输入结构体

		struct v2f {
			float4 pos : SV_POSITION;
			float3 worldNormal : TEXCOORD0;
			float3 worldPos : TEXCOORD1;
		}; // 定义顶点着色器的输出结构体，同时也是片元着色器的输入结构体

		v2f vert(a2v v) {
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex); // 顶点位置信息从模型空间转换到投影空间
			o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject); // 顶点法线从模型空间转到世界空间
			o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz; // 顶点位置信息从模型空间转换到世界空间
			
			return o;
		}

		fixed4 frag(v2f i) : SV_Target {
			fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz; // 获取环境光

			fixed3 worldNormal = normalize(i.worldNormal); // 世界空间下的法线方向从顶点着色器传递到片元着色器
			fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz); // 获取世界空间的光源方向

			fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir)); // 计算完整漫反射

			fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal)); 
			// 获取反射光向量
			// CG的reflect函数的入射方向要求由光源指向交点出，所以要对worldLightDir取反

			fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
			// _WorldSpaceCameraPos是世界空间中的摄像机位置
			// i.worldPos.xyz是从顶点着色器传递给片元着色器的
			// 两者相减得到的就是世界空间下的视角方向！（叹为观止）

			fixed3 halfDir = normalize(worldLightDir + viewDir); // 计算获得观察视角向量和反射光线向量的中间向量

			fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);
			// pow(x,y) = x的y次方
			// 这里套用了Blinn-Phong高光部分的计算公式
			// _Gloss是材质的光泽度，用于控制高光的范围大小
			// 高光反射的计算 = 入射光线的颜色和强度 * 材质的高光反射系数 * max(0，视角方向和反射方向的点积)的_GLoss次方

			return fixed4 (ambient + diffuse + specular, 1.0);
		}

		ENDCG
		}
	}
}

// Blinn-Phong光照模型的高光反射部分看起来更大
// 实际渲染中，绝大多数情况会选择Blinn-Phong光照模型
// Phong和Blinn-Phong都是经验模型