Shader "Unity Shaders Book/Chapter5/SimpleShader" {
//5.2.1第一个shader
	SubShader{
		Pass{
			CGPROGRAM

			#pragma vertex vert 
			#pragma fragment frag
			//包含顶点着色器代码的函数命名为vert
            //包含片元着色器代码的函数命名为frag
			
			float4 vert(float4 v:POSITION) : SV_POSITION //定义顶点输入和输出
			//顶点着色器的输入数据类型是float4，定义为参数v
			//把模型的顶点的坐标（POSITION）赋值给v
			//顶点着色器的输出是裁剪空间中的顶点坐标（SV_POSITION）
				{ return UnityObjectToClipPos (v); }
				//中间计算：把顶点坐标从模型空间转换到裁剪空间
				//原版是 mul (UNITY_MATRIX_MVP, v);MVP 即 Model View Projection矩阵
 
			fixed4 frag() : SV_TARGET //片元定义输入和输出
			//fixed4类型的片元着色器（frag）没有输入
			//片元着色器的输出到 Render Target，这里将输出到默认的帧缓存中
				{ return fixed4(1.0,1.0,1.0,1.0); }
				// 中间计算：返回fixed4类型的变量，RGB(1,1,1)即为白色
 
			ENDCG
		}
	}
}