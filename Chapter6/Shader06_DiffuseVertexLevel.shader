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

		struct a2v {
			float4 vertex : POSITION;
			float3 normal : NORMAL; // 把模型顶点法线信息存储到normal中
		}; // 顶点着色器的输入结构体

		struct v2f {
			float4 pos : SV_POSITION;
			fixed3 color : COLOR; // 把顶点着色器中计算得到的光照颜色传递给片元着色器
		}; // 顶点着色器的输出结构体，同时也是片元着色器的输入结构体

		v2f vert(a2v v) {
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex); // 将顶点的位置信息从模型空间转换到投影空间

			fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz; // 获取环境信息

			fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject)); 
			// a2v得到的顶点法线是位于模型空间下的，需要将法线信息从模型空间转换到世界空间
			// 可以使用顶点变换矩阵的逆转置矩阵对法线进行相同的变换
			// _World2Object是模型空间到世界空间的变换矩阵的逆矩阵
			// 调换_World2Object在mul函数中的位置，得到和转置矩阵相同的矩阵乘法
			// 由于法线是一个三维矢量，因此只需要截取_World2Object的前三行三列
			fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz); // 获取世界空间中的光照方向
			fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight)); 
			// 计算漫反射：世界空间光方向点乘世界空间中的法线方向，控制范围[0-1]，再乘上光源的颜色和漫反射的初始颜色
			// _LightColor0是Unity提供的一个内置变量，用于访问该Pass处理的光源的颜色和强度信息，前提是先定义合适的LightMode标签
			// _WorldSpaceLightPos0也是Unity的内置变量，用于给出光源方向。使用它的前提是场景中只有一个光源，并且它是平行光，这个变量类似UE4中的SkyAtmosphereLightDirection，注意这个节点可以使用光源索引
			// 计算法线和光源方向之间的点积时，需要让两者处于统一坐标空间下点积才有意义，这里选择了世界空间坐标

			o.color = ambient + diffuse; // 最终像素颜色是计算得到的漫反射加环境光共同作用

			return o;
		}

		fixed4 frag(v2f i) : SV_Target {
			return fixed4(i.color, 1.0);
		}  // 所有计算都在顶点着色器中完成，因此片元着色器只需要把顶点颜色输出

		ENDCG
		}
	}
}