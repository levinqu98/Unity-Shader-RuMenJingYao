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
			fixed3 color : COLOR;
		}; // 定义顶点着色器的输出结构体，同时也是片元着色器的输入结构体

		v2f vert(a2v v) {
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex); // 顶点位置信息从模型空间转换到投影空间

			fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz; // 获取环境光

			fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject)); // 顶点法线从模型空间转换到世界空间
			fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz); // 获取世界空间光方向

			fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir)); // 计算完整漫反射

			fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal)); 
			// 获取反射光向量
			// CG的reflect函数的入射方向要求由光源指向交点出，所以要对worldLightDir取反

			fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz);
			// _WorldSpaceCameraPos是世界空间中的摄像机位置
			// 再把顶点位置从模型空间变换到世界空间
			// 两者相减得到的就是世界空间下的视角方向！（叹为观止）

			fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir, viewDir)), _Gloss);
			// pow(x,y) = x的y次方
			// 这里就是套用了Phong光照模型的计算公式
			// _Gloss是材质的光泽度，用于控制高光的范围大小
			// 高光反射的计算 = 入射光线的颜色和强度 * 材质的高光反射系数 * 视角方向和反射方向的点积的_GLoss次方

			o.color = ambient + diffuse + specular;
			// 最终着色为环境光+漫反射+高光反射

			return o;
		}

		fixed4 frag(v2f i) : SV_Target {
			return fixed4 (i.color, 1.0);
		}

		ENDCG
		}
	}
}