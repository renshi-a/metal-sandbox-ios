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
};

[[fragment]]
float4 lighting_fragment_main(LightingFragmentIn in [[stage_in]]) {
    return float4(0.f, 1.f, 1.f, 1.0f);
}
