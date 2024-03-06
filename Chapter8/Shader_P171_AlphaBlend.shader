// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "P171_AlphaBlend"
{
	Properties
	{
		_MainTex("Main Tex", 2D) = "white" {}
		_MainTint("Main Tint", Color) = (0,0,0,0)
		_AlphaScale("Alpha Scale", Float) = 0.5

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		BlendOp Add
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite Off
		ZTest LEqual
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			//This is a late directive
			
			uniform float4 _MainTint;
			uniform sampler2D _MainTex;
			uniform float _AlphaScale;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 texCoord4 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DNode3 = tex2D( _MainTex, texCoord4 );
				float3 temp_output_12_0 = ( ( (_MainTint).rgb * (tex2DNode3).rgb ) * (UNITY_LIGHTMODEL_AMBIENT).rgb );
				float3 ase_worldNormal = i.ase_texcoord2.xyz;
				float3 normalizedWorldNormal = normalize( ase_worldNormal );
				float3 worldSpaceLightDir = UnityWorldSpaceLightDir(WorldPosition);
				float dotResult18 = dot( normalizedWorldNormal , worldSpaceLightDir );
				#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
				float4 ase_lightColor = 0;
				#else //aselc
				float4 ase_lightColor = _LightColor0;
				#endif //aselc
				float4 appendResult24 = (float4(( temp_output_12_0 + ( temp_output_12_0 * max( dotResult18 , 0.0 ) * ase_lightColor.rgb ) ) , ( tex2DNode3.a * _AlphaScale )));
				
				
				finalColor = appendResult24;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18935
0;0;3440;1379;1326.234;-24.32438;1.355139;True;False
Node;AmplifyShaderEditor.CommentaryNode;23;-776.4863,151.8082;Inherit;False;2315.181;1355.887;diffuse = _LightColor0.rgb * albe * max(0, dot(worldNormal, worldLightDir));6;20;17;21;22;28;30;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;17;-726.4863,201.8082;Inherit;False;1983.969;662.1301;ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo ;3;16;15;12;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;16;-676.4863,251.8082;Inherit;False;1108.486;612.1301;albedo = texColor.rgb * _Color.rgb ;3;14;13;6;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;13;-641.0793,571.5811;Inherit;False;853;280;texColor.rgb;3;4;5;3;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;14;-643.5463,300.1053;Inherit;False;523.5453;262;_Color.rgb;2;8;9;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-593.2258,651.6161;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;8;-593.5463,350.1053;Inherit;False;Property;_MainTint;Main Tint;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;20;612.0488,897.5425;Inherit;False;646.3333;418.0001;max(0,dot(worldNormal, worldLightDir));4;1;2;18;19;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;15;495.4824,515.0732;Inherit;False;556;169;UNITY_LIGHTMODEL_AMBIENT.xyz;2;10;11;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;3;-339.9102,621.5813;Inherit;True;Property;_MainTex;Main Tex;0;0;Create;True;0;0;0;False;0;False;-1;e9c4642eaa083a54ab91406d8449e6ac;e9c4642eaa083a54ab91406d8449e6ac;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;9;-343.001,351.7905;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;1;665.0488,947.5427;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;2;662.0488,1132.544;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;10;545.4821,565.0732;Inherit;False;UNITY_LIGHTMODEL_AMBIENT;0;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;5;-14.79507,618.5353;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;11;828.4824,568.0732;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;262.2993,359.5602;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;18;947.1713,1056.518;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;21;1117.244,1348.695;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;1095.482,362.2002;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-168.2168,985.0048;Inherit;False;Property;_AlphaScale;Alpha Scale;2;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;19;1106.381,1058.76;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;55.05162,966.6371;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;27;1692.379,744.8549;Inherit;False;202;185;ambient + diffuse;1;25;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;1376.695,819.7345;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;31;457.5811,1505.858;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;1742.379,794.8547;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;1999.319,1482.683;Inherit;False;COLOR;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;2208.897,1482.802;Float;False;True;-1;2;ASEMaterialInspector;100;1;P171_AlphaBlend;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;True;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;True;2;False;-1;True;0;False;-1;True;False;0;False;-1;0;False;-1;True;1;RenderType=Transparent=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.CommentaryNode;32;-218.2168,916.6371;Inherit;False;435.2684;185;texColor.a * _AlphaScale;0;;1,1,1,1;0;0
WireConnection;3;1;4;0
WireConnection;9;0;8;0
WireConnection;5;0;3;0
WireConnection;11;0;10;0
WireConnection;6;0;9;0
WireConnection;6;1;5;0
WireConnection;18;0;1;0
WireConnection;18;1;2;0
WireConnection;12;0;6;0
WireConnection;12;1;11;0
WireConnection;19;0;18;0
WireConnection;28;0;3;4
WireConnection;28;1;30;0
WireConnection;22;0;12;0
WireConnection;22;1;19;0
WireConnection;22;2;21;1
WireConnection;31;0;28;0
WireConnection;25;0;12;0
WireConnection;25;1;22;0
WireConnection;24;0;25;0
WireConnection;24;3;31;0
WireConnection;0;0;24;0
ASEEND*/
//CHKSM=48D6583905D72139073082D3B7C45C2A1A4A5D33