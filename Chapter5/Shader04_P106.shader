// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shader Book/Chapter 5/Simple Shader" {
//���ʹ������

	Properties {
		_Color ("Color Tint", Color) = (1.0, 1.0, 1.0, 1.0)
		//����һ��Color���͵�����
	}

	SubShader {
		Pass {
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			fixed4 _Color;
			//��CF�����У�������Ҫ����һ�����������ƺ����Ͷ�ƥ��ı���

			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float3 texcoord : TEXCOORD0;
			};
			//�ṹ��a2v���嶥����ɫ��������
			//���ʶ������꣬���ߣ��������������

			struct v2f {
				float4 pos : SV_POSITION;
				fixed3 color : COLOR0;
			};
			//�ṹ��v2f���嶥����ɫ�������
			//��ȡ�������ɫ�Ͳü��ռ��е�λ����Ϣ

			v2f vert(a2v v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.color = v.normal * 0.5 + fixed3(0.5, 0.5, 0.5);
				return o;
			}
			//���������Ϊ������ɫ

			fixed4 frag(v2f i) : SV_Target {
				fixed3 c = i.color;
				c *= _Color.rgb;
				//ʹ��_Color���������������ɫ
				return fixed4(c, 1.0);
			}

			ENDCG
		}
	}
}