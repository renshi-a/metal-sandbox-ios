//
//  001ClearColorFragment.metal
//  metal-sandbox-ios
//
//  Created by Renshi Asada on 2024/10/20.
//

#include <metal_stdlib>
using namespace metal;

struct FragmentIn {
    float4 position [[position]];
};

[[fragment]]
float4 clear_color_fragment_main(FragmentIn in [[stage_in]]) {
    return float4(0.f, 0.f, 1.f, 1.0f);
}
