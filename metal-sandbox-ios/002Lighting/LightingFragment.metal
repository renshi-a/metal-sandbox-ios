//
//  LightingFragment.metal
//  metal-sandbox-ios
//
//  Created by Renshi Asada on 2024/10/20.
//

#include <metal_stdlib>
using namespace metal;

struct LightingFragmentIn {
    float4 position [[position]];
    float3 normal;
};

[[fragment]]
float4 lighting_fragment_main(LightingFragmentIn in [[stage_in]]) {
    float3 light = normalize(float3(1.0, 1.0, 0.8));
    float3 normal = normalize(in.normal);
    
    float s = saturate( dot( light, normal) );
    float3 col = float3(0.f, 1.f, 1.f);
    return float4(col * 0.1 + col * s, 1.0);
}
