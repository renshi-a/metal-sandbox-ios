//
//  ClearColorShaderTypes.h
//  metal-sandbox-ios
//
//  Created by Renshi Asada on 2024/10/20.
//

#ifndef ClearColorShaderTypes_h
#define ClearColorShaderTypes_h

#include <simd/simd.h>

typedef struct ClearColorUniforms {
    simd_float2 resolution;
} Uniforms;

typedef struct ClearColorVertex {
    vector_float2 position;
} Vertex;

#endif /* ClearColorShaderTypes_h */
