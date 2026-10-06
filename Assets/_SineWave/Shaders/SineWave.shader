Shader "SineWave"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Amplitude ("Amplitude", Float) = 1.0
        _Wavelength ("Wavelength", Float) = 1.0
        _Speed ("Speed", Float) = 1.0
        _Direction ("Direction", Vector) = (1,0,0,0)
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
            float _Amplitude;
            float _Wavelength;
            float _Speed;
            float4 _Direction;

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

                float k = 2.0 * PI / _Wavelength;
                float phase = _Speed * k;

                float2 dir = normalize(_Direction.xz);

                float waveDir = dot(dir, worldPos.xz);

                float wave = _Amplitude * sin(waveDir*k + _Time.y * phase);

                worldPos.y += wave;

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
