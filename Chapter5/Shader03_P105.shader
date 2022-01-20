// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shader Book/Chapter 5/Simple Shader" {
//5.2.3 ������ɫ����ƬԪ��ɫ��֮�����ͨ��

	SubShader {
		Pass {
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			struct a2v {
			//�ṹ��a2v���嶥����ɫ��������
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};
			//���ʶ������꣬���ߣ��������������

			struct v2f {
			//�ṹ��v2f���嶥����ɫ�������
				float4 pos : SV_POSITION;
				//����һ������pos��float4���ͣ�= �ü��ռ��λ����Ϣ��SV_POSITION��
				fixed3 color : COLOR0;
				//����һ������color��fixed3���ͣ�������ɫ��Ϣ
			};

			v2f vert(a2v v) {
			//��������ṹ
			//ɾ����ԭ���еģ�SV_POSITION
			//��Ϊv2f�����pos���ǲü��ռ䶥�����꣬������v2f�������Բ����ٸ�vert����ָ���������
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.color = v.normal * 0.5 + fixed3(0.5, 0.5, 0.5);
				//v.normal�����˶���ķ��߷��򣬷�Χ[-1,1]
				//������Χ�������㴦��ӳ�䵽[0,1]
				//�洢��o.color���ݸ�ƬԪ��ɫ��
				//����ʵ���ǰѷ���(float3)ӳ�䵽[0,1]��Χ����ת������ɫ���
				return o;
			}

			fixed4 frag(v2f i) : SV_Target {
				return fixed4(i.color, 1.0);
				//���ڶ�����ɫ�����𶥵���õģ�ƬԪ��ɫ������ƬԪ���õģ�����ƬԪ��ɫ���е�����ʵ���ǰѶ�����ɫ����������в�ֵ��õ��Ľ��
				//����ֵ��� i.color ��ʾ����Ļ��
			}

			ENDCG
		}
	}
}