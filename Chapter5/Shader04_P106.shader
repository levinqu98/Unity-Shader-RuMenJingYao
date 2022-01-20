// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shader Book/Chapter 5/Simple Shader" {
//如何使用属性

	Properties {
		_Color ("Color Tint", Color) = (1.0, 1.0, 1.0, 1.0)
		//声明一个Color类型的属性
	}

	SubShader {
		Pass {
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			fixed4 _Color;
			//在CF代码中，我们需要定义一个与属性名称和类型都匹配的变量

			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float3 texcoord : TEXCOORD0;
			};
			//结构体a2v定义顶点着色器的输入
			//访问顶点坐标，法线，纹理坐标的数据

			struct v2f {
				float4 pos : SV_POSITION;
				fixed3 color : COLOR0;
			};
			//结构体v2f定义顶点着色器的输出
			//获取顶点的颜色和裁剪空间中的位置信息

			v2f vert(a2v v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.color = v.normal * 0.5 + fixed3(0.5, 0.5, 0.5);
				return o;
			}
			//将法线输出为顶点颜色

			fixed4 frag(v2f i) : SV_Target {
				fixed3 c = i.color;
				c *= _Color.rgb;
				//使用_Color属性来控制输出颜色
				return fixed4(c, 1.0);
			}

			ENDCG
		}
	}
}