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
    float3 normal;
};

vertex VertexOut lighting_vertex_main(uint vertexID [[vertex_id]],
                                      constant LightingVertex* vertices [[buffer(0)]],
                                      constant LightingUniforms& uniforms [[buffer(1)]]) {
    VertexOut out;
    out.position = uniforms.modelMatrix * float4(vertices[vertexID].position, 1.0);
    float3x3 normalMatrix = float3x3(uniforms.modelMatrix.columns[0].xyz,
                                     uniforms.modelMatrix.columns[1].xyz,
                                     uniforms.modelMatrix.columns[2].xyz);
    out.normal = normalMatrix * vertices[vertexID].position;
    
    return out;
}
