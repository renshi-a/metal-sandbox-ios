//
//  LightingVertex.metal
//  metal-sandbox-ios
//
//  Created by Renshi Asada on 2024/10/20.
//

#include "LightingShadertypes.h"

#include <metal_stdlib>

using namespace metal;

struct VertexOut {
    float4 position [[position]];
};

vertex VertexOut lighting_vertex_main(uint vertexID [[vertex_id]],
                                      constant LightingVertex* vertices [[buffer(0)]],
                                      constant LightingUniforms& uniforms [[buffer(1)]]) {
    VertexOut out;
    out.position = uniforms.modelMatrix * float4(vertices[vertexID].position, 1.0);
    
    return out;
}
