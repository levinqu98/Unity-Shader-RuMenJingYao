Shader "Unity Shaders Book/Chapter5/SimpleShader" {
//5.2.1��һ��shader
	SubShader{
		Pass{
			CGPROGRAM

			#pragma vertex vert 
			#pragma fragment frag
			//����������ɫ������ĺ�������Ϊvert
            //����ƬԪ��ɫ������ĺ�������Ϊfrag
			
			float4 vert(float4 v:POSITION) : SV_POSITION //���嶥����������
			//������ɫ������������������float4������Ϊ����v
			//��ģ�͵Ķ�������꣨POSITION����ֵ��v
			//������ɫ��������ǲü��ռ��еĶ������꣨SV_POSITION��
				{ return UnityObjectToClipPos (v); }
				//�м���㣺�Ѷ��������ģ�Ϳռ�ת�����ü��ռ�
				//ԭ���� mul (UNITY_MATRIX_MVP, v);MVP �� Model View Projection����
 
			fixed4 frag() : SV_TARGET //ƬԪ������������
			//fixed4���͵�ƬԪ��ɫ����frag��û������
			//ƬԪ��ɫ��������� Render Target�����ｫ�����Ĭ�ϵ�֡������
				{ return fixed4(1.0,1.0,1.0,1.0); }
				// �м���㣺����fixed4���͵ı�����RGB(1,1,1)��Ϊ��ɫ
 
			ENDCG
		}
	}
}