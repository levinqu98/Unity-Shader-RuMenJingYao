// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shader Book/Chapter 6/Diffuse Vertex-Level" {  // ����Shader����������Ҹ���ַ���
	
	Properties {
		_Diffuse ("Diffuse", Color) = (1, 1, 1, 1)  // ����Color���͵����ԣ���ʼֵ����Ϊ��ɫ
	}

	Subshader {
		Pass {
			Tags { "LightMode" = "ForwardBase" } // LightMode��ǩ��Pass��ǩ�е�һ�֣����ڶ����Pass��Unity������ˮ���еĽ�ɫ
		
		CGPROGRAM
		#pragma vertex vert 
		#pragma fragment frag
		#include "Lighting.cginc"

		fixed4 _Diffuse;  // ΪProperties�����������Զ���һ����������ƥ��ı���

		struct a2v {
			float4 vertex : POSITION;
			float3 normal : NORMAL; // ��ģ�Ͷ��㷨����Ϣ�洢��normal��
		}; // ������ɫ��������ṹ��

		struct v2f {
			float4 pos : SV_POSITION;
			fixed3 color : COLOR; // �Ѷ�����ɫ���м���õ��Ĺ�����ɫ���ݸ�ƬԪ��ɫ��
		}; // ������ɫ��������ṹ�壬ͬʱҲ��ƬԪ��ɫ��������ṹ��

		v2f vert(a2v v) {
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex); // �������λ����Ϣ��ģ�Ϳռ�ת����ͶӰ�ռ�

			fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz; // ��ȡ������Ϣ

			fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject)); 
			// a2v�õ��Ķ��㷨����λ��ģ�Ϳռ��µģ���Ҫ��������Ϣ��ģ�Ϳռ�ת��������ռ�
			// ����ʹ�ö���任�������ת�þ���Է��߽�����ͬ�ı任
			// _World2Object��ģ�Ϳռ䵽����ռ�ı任����������
			// ����_World2Object��mul�����е�λ�ã��õ���ת�þ�����ͬ�ľ���˷�
			// ���ڷ�����һ����άʸ�������ֻ��Ҫ��ȡ_World2Object��ǰ��������
			fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz); // ��ȡ����ռ��еĹ��շ���
			fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight)); 
			// ���������䣺����ռ�ⷽ��������ռ��еķ��߷��򣬿��Ʒ�Χ[0-1]���ٳ��Ϲ�Դ����ɫ��������ĳ�ʼ��ɫ
			// _LightColor0��Unity�ṩ��һ�����ñ��������ڷ��ʸ�Pass����Ĺ�Դ����ɫ��ǿ����Ϣ��ǰ�����ȶ�����ʵ�LightMode��ǩ
			// _WorldSpaceLightPos0Ҳ��Unity�����ñ��������ڸ�����Դ����ʹ������ǰ���ǳ�����ֻ��һ����Դ����������ƽ�й⣬�����������UE4�е�SkyAtmosphereLightDirection��ע������ڵ����ʹ�ù�Դ����
			// ���㷨�ߺ͹�Դ����֮��ĵ��ʱ����Ҫ�����ߴ���ͳһ����ռ��µ���������壬����ѡ��������ռ�����

			o.color = ambient + diffuse; // ����������ɫ�Ǽ���õ���������ӻ����⹲ͬ����

			return o;
		}

		fixed4 frag(v2f i) : SV_Target {
			return fixed4(i.color, 1.0);
		}  // ���м��㶼�ڶ�����ɫ������ɣ����ƬԪ��ɫ��ֻ��Ҫ�Ѷ�����ɫ���

		ENDCG
		}
	}
}