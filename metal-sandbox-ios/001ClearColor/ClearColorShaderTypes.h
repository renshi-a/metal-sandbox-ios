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
} ClearColorUniforms;

typedef struct ClearColorVertex {
    vector_float2 position;
} ClearColorVertex;

#endif /* ClearColorShaderTypes_h */
