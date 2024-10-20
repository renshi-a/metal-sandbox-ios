//
//  LightingShadertypes.h
//  metal-sandbox-ios
//
//  Created by Renshi Asada on 2024/10/20.
//

#ifndef LightingShadertypes_h
#define LightingShadertypes_h

#include <simd/simd.h>

typedef struct LightingUniforms {
    simd_float2 resolution;
} LightingUniforms;

typedef struct LightingVertex {
    vector_float2 position;
} LightingVertex;

#endif /* LightingShadertypes_h */
