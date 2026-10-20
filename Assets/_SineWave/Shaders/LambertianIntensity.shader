Shader "LambertianIntensity"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Length ("Length", Float) = 1.0
        _Amplitude ("Amplitude", Float) = 1.0
        _Speed ("Speed", Float) = 10.0
        _Direction("Direction", Vector) = (1,0,1,0)
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
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            #define PI 3.14159265359

            float4 _Color;
            float _Length;
            float _Amplitude;
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

                float2 directionVector = _Direction.xz;
                directionVector = normalize(directionVector);

                float waveLength = 2.0 / _Length;
                float phaseConstant = _Speed * waveLength;
                worldPos.y += _Amplitude * sin(dot(worldPos.xz, directionVector) * waveLength + _Time.y * phaseConstant);

                o.pos = mul(UNITY_MATRIX_VP, float4(worldPos,1));
                o.worldPos = float4(worldPos, 1.0);

                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float2 directionVector = _Direction.xz;
                float2 direction = normalize(directionVector);
                float waveLength = 2.0 / _Length;
                float phaseConstant = _Speed * waveLength;

                float theta = dot(direction, i.worldPos.xz) * waveLength + _Time.y * phaseConstant;
                float tangentDerivative = _Amplitude * direction.x * waveLength * cos(theta);
                float biNormalDerivative = _Amplitude * direction.y * waveLength * cos(theta);
                float3 tangent = float3(1, tangentDerivative, 0);
                float3 biNormal = float3(0, biNormalDerivative, 1);
                float3 normal = normalize(cross(biNormal, tangent));

                Light mainLight = GetMainLight();
                float3 lightDir = mainLight.direction;
                float NdotL = max(dot(normal, lightDir), 0.0);

                return float4(_Color.rgb * NdotL * mainLight.color, _Color.a);
            }

            ENDHLSL
        }
    }
}
