// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shader Book/Chapter 5/Simple Shader" {
//5.2.3 顶点着色器和片元着色器之间如何通信

	SubShader {
		Pass {
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			struct a2v {
			//结构体a2v定义顶点着色器的输入
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};
			//访问顶点坐标，法线，纹理坐标的数据

			struct v2f {
			//结构体v2f定义顶点着色器的输出
				float4 pos : SV_POSITION;
				//定义一个变量pos（float4类型）= 裁剪空间的位置信息（SV_POSITION）
				fixed3 color : COLOR0;
				//定义一个变量color（fixed3类型）储存颜色信息
			};

			v2f vert(a2v v) {
			//声明输出结构
			//删掉了原文中的：SV_POSITION
			//因为v2f里面的pos才是裁剪空间顶点坐标，而不是v2f自身。所以不能再给vert函数指定这个语义
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.color = v.normal * 0.5 + fixed3(0.5, 0.5, 0.5);
				//v.normal包含了顶点的法线方向，范围[-1,1]
				//分量范围经过计算处理，映射到[0,1]
				//存储到o.color传递给片元着色器
				//这里实际是把法线(float3)映射到[0,1]范围并且转换成颜色输出
				return o;
			}

			fixed4 frag(v2f i) : SV_Target {
				return fixed4(i.color, 1.0);
				//由于顶点着色器是逐顶点调用的，片元着色器是逐片元调用的，所以片元着色器中的输入实际是把顶点着色器的输出进行插值后得到的结果
				//将插值后的 i.color 显示到屏幕上
			}

			ENDCG
		}
	}
}