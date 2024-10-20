//
//  ClearColorVertex.metal
//  metal-sandbox-ios
//
//  Created by Renshi Asada on 2024/10/20.
//

#include "ClearColorShaderTypes.h"

#include <metal_stdlib>

using namespace metal;

struct VertexOut {
    float4 position [[position]];
};

vertex VertexOut clear_color_vertex_main(uint vertexID [[vertex_id]],
                             constant ClearColorVertex* vertices [[buffer(0)]],
                             constant ClearColorUniforms& uniforms [[buffer(1)]]) {
    float2 position = vertices[vertexID].position.xy;
    float2 resolution = uniforms.resolution;
    
    VertexOut out;
    out.position = vector_float4(0.0, 0.0, 0.0, 1.0);
    out.position.xy = position / (resolution / 2.0) - 1.0;
    float2 yFlip = { 1.0, -1.0 };
    out.position.xy *= yFlip;
    
    return out;
}
