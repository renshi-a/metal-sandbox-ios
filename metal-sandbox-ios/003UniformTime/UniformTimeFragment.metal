//
//  UniformTimeFragment.metal
//  metal-sandbox-ios
//
//  Created by Renshi Asada on 2024/10/26.
//

#include "UniformTImeShaderTypes.h"

#include <metal_stdlib>
using namespace metal;

struct FragmentIn {
    float4 position [[position]];
};

[[fragment]]
float4 uniform_time_fragment_main(FragmentIn in [[stage_in]],
                                 constant UniformTimeFragmentUniforms& uniforms [[buffer(0)]] ) {
    return float4(abs(sin(uniforms.time)), 0.f, 0.f, 1.0f);
}

