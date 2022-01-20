// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shader Book/Chapter 5/Simple Shader" {
//5.2.2ģ�����ݴ�������
	SubShader {
		Pass {
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			struct a2v {
			//����һ���ṹ�壬����Ϊ a2v (application to vertex Shader�������ݴ�Ӧ�ý׶δ��ݵ�������ɫ����)
				float4 vertex : POSITION;
				//����һ������vertex��float4���ͣ�= ģ�Ϳռ�Ķ������꣨POSITION��
				float3 normal : NORMAL;
				//����һ������normal��float3���ͣ�= ģ�Ϳռ�ķ��߷���NORMAL��
				float4 texcoord : TEXCOORD0;
				//����һ������texcoord��float4���ͣ� = ģ�͵ĵ�һ���������꣨TEXTURE0��
			};
			//POSITION, TANGENT, NORMAL��Щ�����е�������Դ��Unity�� Mesh Render ���
			//����ͨ�����ַ����������ڶ�����ɫ���з��ʶ������Щ����

			float4 vert (a2v v) : SV_POSITION {
			//������ɫ��vert��������a2v������ǲü��ռ��еĶ�������
				return UnityObjectToClipPos (v.vertex);
				//ʹ��v.Vertex������ģ�Ϳռ�Ķ�������
			}

			fixed4 frag() : SV_Target {
			//ƬԪ��ɫ��û������
			//ƬԪ��ɫ������� Render Target
				return fixed4(1.0, 1.0, 1.0, 1.0);
				//����fixed4����ֵ��RGB(1,1,1)Ϊ��ɫ
			}

			ENDCG
		}
	}
}