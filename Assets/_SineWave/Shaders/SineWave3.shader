Shader "SineWave3"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Length ("Length", Float) = 1.0
        _Amplitude ("Amplitude", Float) = 1.0
        _Speed ("Speed", Float) = 10.0
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
            "RenderPipeline"="UniversalRenderPipeline"
        }
        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            #define PI 3.14159265359

            float4 _Color;
            float _Length;
            float _Amplitude;
            float _Speed;

            struct appdata
            {
                float4 vertex: POSITION;
            };

            struct v2f
            {
                float4 pos: SV_POSITION;
                float4 worldPos: TEXCOORD0;
            };

            v2f vert(appdata v)
            {
                v2f o;

                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                float waveLength = 2.0 / _Length;
                float phaseConstant = _Speed * waveLength;
                worldPos.y += _Amplitude * sin(worldPos.x * waveLength + _Time.y * phaseConstant);

                o.pos = mul(UNITY_MATRIX_VP, float4(worldPos,1));
                o.worldPos = float4(worldPos, 1.0);

                return o;
            }

            float4 frag(v2f i) : SV_Target
            {

                return _Color;
            }

            ENDHLSL
        }
    }
}
