Shader "Yontalane/Retone"
{
    Properties
    {
        _SourceChannel ("Test Channel", Float) = 0.0
        _BlendMode ("Blend Mode", Float) = 0.0
        _BlendAmount ("Blend Amount", Float) = 1.0
        _ToneCount ("Count", Float) = 0.0
        
        [NoScaleOffset] _MainTex ("Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1, 1, 1, 1)
        [NoScaleOffset] _Tone00 ("Tone 00", 2D) = "white" {}
        [NoScaleOffset] _Tone01 ("Tone 01", 2D) = "white" {}
        _Tone01_Min ("Tone 01 Min Cutoff", Float) = 0.111
        [NoScaleOffset] _Tone02 ("Tone 02", 2D) = "white" {}
        _Tone02_Min ("Tone 02 Min Cutoff", Float) = 0.222
        [NoScaleOffset] _Tone03 ("Tone 03", 2D) = "white" {}
        _Tone03_Min ("Tone 03 Min Cutoff", Float) = 0.333
        [NoScaleOffset] _Tone04 ("Tone 04", 2D) = "white" {}
        _Tone04_Min ("Tone 04 Min Cutoff", Float) = 0.444
        [NoScaleOffset] _Tone05 ("Tone 05", 2D) = "white" {}
        _Tone05_Min ("Tone 05 Min Cutoff", Float) = 0.556
        [NoScaleOffset] _Tone06 ("Tone 06", 2D) = "white" {}
        _Tone06_Min ("Tone 06 Min Cutoff", Float) = 0.667
        [NoScaleOffset] _Tone07 ("Tone 07", 2D) = "white" {}
        _Tone07_Min ("Tone 07 Min Cutoff", Float) = 0.778
        [NoScaleOffset] _Tone08 ("Tone 08", 2D) = "white" {}
        _Tone08_Min ("Tone 08 Min Cutoff", Float) = 0.889

        [Toggle] _UsePost ("Post", Float) = 0.0
        _PostScreen ("Screen", Color) = (0, 0, 0, 1)
        _PostMultiply ("Multiply", Color) = (1, 1, 1, 1)

        _PixelScale ("Pixel Scale", Float) = 1.0

        [Toggle] _UseOutline ("Outline", Float) = 0.0
        _OutlineColor ("Color", Color) = (0, 0, 0, 1)
        _OutlineWidth ("Width", Float) = 1.0
    }

    CustomEditor "Yontalane.Shaders.RetoneGUI"

    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
            "LightMode"="ForwardBase"
        }
        LOD 100

        Pass
        {
            CGPROGRAM

            #pragma shader_feature _SOURCE_R _SOURCE_G _SOURCE_B _SOURCE_A _SOURCE_RGB
            #pragma shader_feature _ _BLEND_MODE_NORMAL _BLEND_MODE_MULTIPLY _BLEND_MODE_ADD
            #pragma shader_feature _TONE_COUNT_2 _TONE_COUNT_3 _TONE_COUNT_5 _TONE_COUNT_7 _TONE_COUNT_9
            #pragma shader_feature _ _USE_POST

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 screenUV : TEXCOORD1;
                fixed4 diff : COLOR0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;

            #if (_BLEND_MODE_NORMAL || _BLEND_MODE_MULTIPLY || _BLEND_MODE_ADD)
                float _BlendAmount;
            #endif

            #if (_TONE_COUNT_2)
                sampler2D _Tone00;
                float4 _Tone00_TexelSize;
                sampler2D _Tone08;
                float4 _Tone08_TexelSize;
                float _Tone08_Min;
            #elif (_TONE_COUNT_3)
                sampler2D _Tone00;
                float4 _Tone00_TexelSize;
                sampler2D _Tone04;
                float4 _Tone04_TexelSize;
                float _Tone04_Min;
                sampler2D _Tone08;
                float4 _Tone08_TexelSize;
                float _Tone08_Min;
            #elif (_TONE_COUNT_5)
                sampler2D _Tone00;
                float4 _Tone00_TexelSize;
                sampler2D _Tone03;
                float4 _Tone03_TexelSize;
                float _Tone03_Min;
                sampler2D _Tone04;
                float4 _Tone04_TexelSize;
                float _Tone04_Min;
                sampler2D _Tone05;
                float4 _Tone05_TexelSize;
                float _Tone05_Min;
                sampler2D _Tone08;
                float4 _Tone08_TexelSize;
                float _Tone08_Min;
            #elif (_TONE_COUNT_7)
                sampler2D _Tone00;
                float4 _Tone00_TexelSize;
                sampler2D _Tone02;
                float4 _Tone02_TexelSize;
                float _Tone02_Min;
                sampler2D _Tone03;
                float4 _Tone03_TexelSize;
                float _Tone03_Min;
                sampler2D _Tone04;
                float4 _Tone04_TexelSize;
                float _Tone04_Min;
                sampler2D _Tone05;
                float4 _Tone05_TexelSize;
                float _Tone05_Min;
                sampler2D _Tone06;
                float4 _Tone06_TexelSize;
                float _Tone06_Min;
                sampler2D _Tone08;
                float4 _Tone08_TexelSize;
                float _Tone08_Min;
            #elif (_TONE_COUNT_9)
                sampler2D _Tone00;
                float4 _Tone00_TexelSize;
                sampler2D _Tone01;
                float4 _Tone01_TexelSize;
                float _Tone01_Min;
                sampler2D _Tone02;
                float4 _Tone02_TexelSize;
                float _Tone02_Min;
                sampler2D _Tone03;
                float4 _Tone03_TexelSize;
                float _Tone03_Min;
                sampler2D _Tone04;
                float4 _Tone04_TexelSize;
                float _Tone04_Min;
                sampler2D _Tone05;
                float4 _Tone05_TexelSize;
                float _Tone05_Min;
                sampler2D _Tone06;
                float4 _Tone06_TexelSize;
                float _Tone06_Min;
                sampler2D _Tone07;
                float4 _Tone07_TexelSize;
                float _Tone07_Min;
                sampler2D _Tone08;
                float4 _Tone08_TexelSize;
                float _Tone08_Min;
            #endif

            #if (_USE_POST)
                float4 _PostScreen;
                float4 _PostMultiply;
            #endif

            float _PixelScale;

            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.screenUV = ComputeScreenPos(o.vertex);
                
                half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                o.diff = nl * _LightColor0;
                
                return o;
            }

            fixed4 ApplyTone(float2 uv, sampler2D tone, float4 toneTexel)
            {
                return tex2D(tone, uv * (_ScreenParams.xy / toneTexel.zw) * (1.0 / _PixelScale));
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 c = tex2D(_MainTex, i.uv);

                c = lerp(c, c * _Color, _Color.a);

                c *= i.diff;
                
                float test;
                
                #if (_SOURCE_R)
                	test = c.r;
                #elif (_SOURCE_G)
                	test = c.g;
                #elif (_SOURCE_B)
                	test = c.b;
                #elif (_SOURCE_A)
                	test = c.a;
                #else
                	test = (c.r + c.g + c.b) * 0.33333;
                #endif

                fixed4 tone;

                #if (_TONE_COUNT_2)
                    if (test > _Tone08_Min)
                    {
                        tone = ApplyTone(i.screenUV.xy, _Tone08, _Tone08_TexelSize);
                    }
                    else
                    {
                        tone = ApplyTone(i.screenUV.xy, _Tone00, _Tone00_TexelSize);
                    }
                #elif (_TONE_COUNT_3)
                    if (test > _Tone08_Min)
                    {
                        tone = ApplyTone(i.screenUV.xy, _Tone08, _Tone08_TexelSize);
                    }
                    else if (test > _Tone04_Min)
                    {
                        tone = ApplyTone(i.screenUV.xy, _Tone04, _Tone04_TexelSize);
                    }
                    else
                    {
                        tone = ApplyTone(i.screenUV.xy, _Tone00, _Tone00_TexelSize);
                    }
                #elif (_TONE_COUNT_5)
                    if (test > _Tone08_Min)
                    {
                        tone = ApplyTone(i.screenUV.xy, _Tone08, _Tone08_TexelSize);
                    }
                    else if (test > _Tone05_Min)
                    {
                        tone = ApplyTone(i.screenUV.xy, _Tone05, _Tone05_TexelSize);
                    }
                    else if (test > _Tone04_Min)
                    {
                        tone = ApplyTone(i.screenUV.xy, _Tone04, _Tone04_TexelSize);
                    }
                    else if (test > _Tone03_Min)
                    {
                        tone = ApplyTone(i.screenUV.xy, _Tone03, _Tone03_TexelSize);
                    }
                    else
                    {
                        tone = ApplyTone(i.screenUV.xy, _Tone00, _Tone00_TexelSize);
                    }
                #elif (_TONE_COUNT_7)
                    if (test > _Tone08_Min)
                    {
                        tone = ApplyTone(i.screenUV.xy, _Tone08, _Tone08_TexelSize);
                    }
                    else if (test > _Tone06_Min)
                    {
                        tone = ApplyTone(i.screenUV.xy, _Tone06, _Tone06_TexelSize);
                    }
                    else if (test > _Tone05_Min)
                    {
                        tone = ApplyTone(i.screenUV.xy, _Tone05, _Tone05_TexelSize);
                    }
                    else if (test > _Tone04_Min)
                    {
                        tone = ApplyTone(i.screenUV.xy, _Tone04, _Tone04_TexelSize);
                    }
                    else if (test > _Tone03_Min)
                    {
                        tone = ApplyTone(i.screenUV.xy, _Tone03, _Tone03_TexelSize);
                    }
                    else if (test > _Tone02_Min)
                    {
                        tone = ApplyTone(i.screenUV.xy, _Tone02, _Tone02_TexelSize);
                    }
                    else
                    {
                        tone = ApplyTone(i.screenUV.xy, _Tone00, _Tone00_TexelSize);
                    }
                #else
                    if (test > _Tone08_Min)
                    {
                        tone = ApplyTone(i.screenUV.xy, _Tone08, _Tone08_TexelSize);
                    }
                    else if (test > _Tone07_Min)
                    {
                        tone = ApplyTone(i.screenUV.xy, _Tone07, _Tone07_TexelSize);
                    }
                    else if (test > _Tone06_Min)
                    {
                        tone = ApplyTone(i.screenUV.xy, _Tone06, _Tone06_TexelSize);
                    }
                    else if (test > _Tone05_Min)
                    {
                        tone = ApplyTone(i.screenUV.xy, _Tone05, _Tone05_TexelSize);
                    }
                    else if (test > _Tone04_Min)
                    {
                        tone = ApplyTone(i.screenUV.xy, _Tone04, _Tone04_TexelSize);
                    }
                    else if (test > _Tone03_Min)
                    {
                        tone = ApplyTone(i.screenUV.xy, _Tone03, _Tone03_TexelSize);
                    }
                    else if (test > _Tone02_Min)
                    {
                        tone = ApplyTone(i.screenUV.xy, _Tone02, _Tone02_TexelSize);
                    }
                    else if (test > _Tone01_Min)
                    {
                        tone = ApplyTone(i.screenUV.xy, _Tone01, _Tone01_TexelSize);
                    }
                    else
                    {
                        tone = ApplyTone(i.screenUV.xy, _Tone00, _Tone00_TexelSize);
                    }
                #endif

                #if (_BLEND_MODE_NORMAL)
                    c = lerp(c, tone, _BlendAmount);
                #elif (_BLEND_MODE_MULTIPLY)
                    c = lerp(c, c * tone, _BlendAmount);
                #elif (_BLEND_MODE_ADD)
                    c = lerp(c, clamp(c + tone, 0.0, 1.0), _BlendAmount);
                #else
                    c = tone;
                #endif

                #if (_USE_POST)
                    c = lerp(c, lerp(_PostScreen, c, test), _PostScreen.a);
                    c = lerp(c, c * _PostMultiply, _PostMultiply.a);
                #endif
                
                return c;
            }
            ENDCG
        }

        Pass
        {
            Cull Front

            CGPROGRAM

            #pragma shader_feature _ _USE_OUTLINE

            #pragma vertex vert
            #pragma fragment frag

            #if (_USE_OUTLINE)

                half4 _OutlineColor;
                half _OutlineWidth;

                float4 vert(float4 position : POSITION, float3 normal : NORMAL) : SV_POSITION
                {
                    float4 clipPosition = UnityObjectToClipPos(position);
                    float3 clipNormal = mul((float3x3) UNITY_MATRIX_VP, mul((float3x3) UNITY_MATRIX_M, normal));

                    float2 offset = normalize(clipNormal.xy) / _ScreenParams.xy * _OutlineWidth * _OutlineColor.a * clipPosition.w * 2;
                    clipPosition.xy += offset;

                    return clipPosition;
                }

                half4 frag() : SV_TARGET
                {
                    return _OutlineColor;
                }

            #else

                float4 vert(float4 position : POSITION, float3 normal : NORMAL) : SV_POSITION
                {
                    return UnityObjectToClipPos(position);
                }

                half4 frag() : SV_TARGET
                {
                    return fixed4(0,0,0,0);
                }

            #endif

            ENDCG
        }
    }
}
