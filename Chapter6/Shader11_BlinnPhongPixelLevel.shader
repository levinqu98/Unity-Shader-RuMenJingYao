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
		float _Gloss; // _Gloss�ķ�Χ�ܴ���float�������洢

		struct a2v {
			float4 vertex : POSITION;
			float3 normal : NORMAL;
		}; // ���嶥����ɫ��������ṹ��

		struct v2f {
			float4 pos : SV_POSITION;
			float3 worldNormal : TEXCOORD0;
			float3 worldPos : TEXCOORD1;
		}; // ���嶥����ɫ��������ṹ�壬ͬʱҲ��ƬԪ��ɫ��������ṹ��

		v2f vert(a2v v) {
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex); // ����λ����Ϣ��ģ�Ϳռ�ת����ͶӰ�ռ�
			o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject); // ���㷨�ߴ�ģ�Ϳռ�ת������ռ�
			o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz; // ����λ����Ϣ��ģ�Ϳռ�ת��������ռ�
			
			return o;
		}

		fixed4 frag(v2f i) : SV_Target {
			fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz; // ��ȡ������

			fixed3 worldNormal = normalize(i.worldNormal); // ����ռ��µķ��߷���Ӷ�����ɫ�����ݵ�ƬԪ��ɫ��
			fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz); // ��ȡ����ռ�Ĺ�Դ����

			fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir)); // ��������������

			fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal)); 
			// ��ȡ���������
			// CG��reflect���������䷽��Ҫ���ɹ�Դָ�򽻵��������Ҫ��worldLightDirȡ��

			fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
			// _WorldSpaceCameraPos������ռ��е������λ��
			// i.worldPos.xyz�ǴӶ�����ɫ�����ݸ�ƬԪ��ɫ����
			// ��������õ��ľ�������ռ��µ��ӽǷ��򣡣�̾Ϊ��ֹ��

			fixed3 halfDir = normalize(worldLightDir + viewDir); // �����ù۲��ӽ������ͷ�������������м�����

			fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);
			// pow(x,y) = x��y�η�
			// ����������Blinn-Phong�߹ⲿ�ֵļ��㹫ʽ
			// _Gloss�ǲ��ʵĹ���ȣ����ڿ��Ƹ߹�ķ�Χ��С
			// �߹ⷴ��ļ��� = ������ߵ���ɫ��ǿ�� * ���ʵĸ߹ⷴ��ϵ�� * max(0���ӽǷ���ͷ��䷽��ĵ��)��_GLoss�η�

			return fixed4 (ambient + diffuse + specular, 1.0);
		}

		ENDCG
		}
	}
}

// Blinn-Phong����ģ�͵ĸ߹ⷴ�䲿�ֿ���������
// ʵ����Ⱦ�У�������������ѡ��Blinn-Phong����ģ��
// Phong��Blinn-Phong���Ǿ���ģ��