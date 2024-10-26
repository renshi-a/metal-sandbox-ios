//
//  UniformTImeShaderTypes.h
//  metal-sandbox-ios
//
//  Created by Renshi Asada on 2024/10/26.
//

#ifndef UniformTImeShaderTypes_h
#define UniformTImeShaderTypes_h

typedef struct UniformTimeVertex {
    vector_float2 position;
} UniformTimeVertex;

typedef struct UniformTimeVertexUniforms {
    simd_float2 resolution;
} UniformTimeVertexUniforms;

typedef struct UniformTimeFragmentUniforms {
    float time;
} UniformTimeFragmentUniforms;

#endif /* UniformTImeShaderTypes_h */
