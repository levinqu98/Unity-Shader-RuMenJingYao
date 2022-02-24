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
			fixed3 color : COLOR;
		}; // ���嶥����ɫ��������ṹ�壬ͬʱҲ��ƬԪ��ɫ��������ṹ��

		v2f vert(a2v v) {
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex); // ����λ����Ϣ��ģ�Ϳռ�ת����ͶӰ�ռ�

			fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz; // ��ȡ������

			fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject)); // ���㷨�ߴ�ģ�Ϳռ�ת��������ռ�
			fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz); // ��ȡ����ռ�ⷽ��

			fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir)); // ��������������

			fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal)); 
			// ��ȡ���������
			// CG��reflect���������䷽��Ҫ���ɹ�Դָ�򽻵��������Ҫ��worldLightDirȡ��

			fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz);
			// _WorldSpaceCameraPos������ռ��е������λ��
			// �ٰѶ���λ�ô�ģ�Ϳռ�任������ռ�
			// ��������õ��ľ�������ռ��µ��ӽǷ��򣡣�̾Ϊ��ֹ��

			fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir, viewDir)), _Gloss);
			// pow(x,y) = x��y�η�
			// �������������Phong����ģ�͵ļ��㹫ʽ
			// _Gloss�ǲ��ʵĹ���ȣ����ڿ��Ƹ߹�ķ�Χ��С
			// �߹ⷴ��ļ��� = ������ߵ���ɫ��ǿ�� * ���ʵĸ߹ⷴ��ϵ�� * �ӽǷ���ͷ��䷽��ĵ����_GLoss�η�

			o.color = ambient + diffuse + specular;
			// ������ɫΪ������+������+�߹ⷴ��

			return o;
		}

		fixed4 frag(v2f i) : SV_Target {
			return fixed4 (i.color, 1.0);
		}

		ENDCG
		}
	}
}