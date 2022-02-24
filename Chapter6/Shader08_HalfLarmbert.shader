// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

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

		struct a2v {  // ������ɫ��������ṹ��
			float4 vertex : POSITION;
			float3 normal : NORMAL; // ��ģ�Ͷ��㷨����Ϣ�洢��normal��
		}; 

		struct v2f { // ������ɫ��������ṹ��,������ɫ��������ṹ�壬
			float4 pos : SV_POSITION;
			float3 worldNormal : TEXCOORD0; 
		}; 

		v2f vert(a2v v) { // ��������ɫ��������ɫ������Ҫ�������ģ��
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex); // �����������ģ�Ϳռ�ת��������ռ�
			o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject); // �����ߴ�ģ�Ϳռ�ת��������ռ�

			return o;
		}

		fixed4 frag(v2f i) : SV_Target {
			fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz; // ��ȡ������
			fixed3 worldNormal = normalize(i.worldNormal); // ��ȡ����ռ��еķ�����Ϣ
			fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz); // ��ȡ����ռ�Ĺ�Դ����

			fixed halfLarmbert = dot(worldNormal, worldLightDir) * 0.5 + 0.5; // ����ɰ�������
			fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * halfLarmbert; // ��������������

			fixed3 color = ambient + diffuse;

			return fixed4(color, 1.0);
		} // ʵ���ϼ����Ǻ��𶥵���ȫ��ͬ�ģ�ֻ�ǰѶ�����ɫ���еļ���Ų����ƬԪ��ɫ����

		ENDCG
		}
	}
}