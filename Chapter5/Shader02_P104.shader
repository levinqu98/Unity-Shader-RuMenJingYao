// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shader Book/Chapter 5/Simple Shader" {
//5.2.2模型数据从哪里来
	SubShader {
		Pass {
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			struct a2v {
			//定义一个结构体，命名为 a2v (application to vertex Shader，把数据从应用阶段传递到顶点着色器中)
				float4 vertex : POSITION;
				//定义一个变量vertex（float4类型）= 模型空间的顶点坐标（POSITION）
				float3 normal : NORMAL;
				//定义一个变量normal（float3类型）= 模型空间的法线方向（NORMAL）
				float4 texcoord : TEXCOORD0;
				//定义一个变量texcoord（float4类型） = 模型的第一套纹理坐标（TEXTURE0）
			};
			//POSITION, TANGENT, NORMAL这些语义中的数据来源与Unity的 Mesh Render 组件
			//我们通过这种方法，可以在顶点着色器中访问顶点的这些数据

			float4 vert (a2v v) : SV_POSITION {
			//顶点着色器vert的输入是a2v，输出是裁剪空间中的顶点坐标
				return UnityObjectToClipPos (v.vertex);
				//使用v.Vertex来访问模型空间的顶点坐标
			}

			fixed4 frag() : SV_Target {
			//片元着色器没有输入
			//片元着色器输出是 Render Target
				return fixed4(1.0, 1.0, 1.0, 1.0);
				//返回fixed4类型值，RGB(1,1,1)为白色
			}

			ENDCG
		}
	}
}