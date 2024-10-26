//
//  GLFragCoordFragment.metal
//  metal-sandbox-ios
//
//  Created by Renshi Asada on 2024/10/26.
//

#include "GLFragCoordShaderTypes.h"

#include <metal_stdlib>
using namespace metal;

struct FragmentIn {
    float4 position [[position]];
};

[[fragment]]
float4 gl_fragcoord_fragment_main(FragmentIn in [[stage_in]],
                                 constant GLFragCoordFragmentUniforms& uniforms [[buffer(0)]] ) {
    float2 v = in.position.xy / uniforms.resolution;
    return float4(v.x, v.y, 0.f, 1.0f);
}
