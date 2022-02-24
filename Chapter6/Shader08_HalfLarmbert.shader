// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shader Book/Chapter 6/Diffuse Vertex-Level" {  // 给咱Shader起个名儿，找个地址存放
	
	Properties {
		_Diffuse ("Diffuse", Color) = (1, 1, 1, 1)  // 声明Color类型的属性，初始值设置为白色
	}

	Subshader {
		Pass {
			Tags { "LightMode" = "ForwardBase" } // LightMode标签是Pass标签中的一种，用于定义该Pass在Unity光照流水线中的角色
		
		CGPROGRAM
		#pragma vertex vert 
		#pragma fragment frag
		#include "Lighting.cginc"

		fixed4 _Diffuse;  // 为Properties中声明的属性定义一个与它类型匹配的变量

		struct a2v {  // 顶点着色器的输入结构体
			float4 vertex : POSITION;
			float3 normal : NORMAL; // 把模型顶点法线信息存储到normal中
		}; 

		struct v2f { // 顶点着色器的输出结构体,顶点着色器的输出结构体，
			float4 pos : SV_POSITION;
			float3 worldNormal : TEXCOORD0; 
		}; 

		v2f vert(a2v v) { // 逐像素着色，顶点着色器不需要计算光照模型
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex); // 将顶点坐标从模型空间转换到世界空间
			o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject); // 将法线从模型空间转换到世界空间

			return o;
		}

		fixed4 frag(v2f i) : SV_Target {
			fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz; // 获取环境光
			fixed3 worldNormal = normalize(i.worldNormal); // 获取世界空间中的法线信息
			fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz); // 获取世界空间的光源方向

			fixed halfLarmbert = dot(worldNormal, worldLightDir) * 0.5 + 0.5; // 处理成半兰伯特
			fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * halfLarmbert; // 漫反射完整计算

			fixed3 color = ambient + diffuse;

			return fixed4(color, 1.0);
		} // 实际上计算是和逐顶点完全相同的，只是把顶点着色器中的计算挪到了片元着色器中

		ENDCG
		}
	}
}