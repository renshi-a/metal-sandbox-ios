//
//  GLFragCoordShaderTypes.h
//  metal-sandbox-ios
//
//  Created by Renshi Asada on 2024/10/26.
//

#ifndef GLFragCoordShaderTypes_h
#define GLFragCoordShaderTypes_h

typedef struct GLFragCoordVertex {
    vector_float2 position;
} GLFragCoordVertex;

typedef struct GLFragCoordVertexUniforms {
    simd_float2 resolution;
} GLFragCoordVertexUniforms;

typedef struct GLFragCoordFragmentUniforms {
    simd_float2 resolution;
} GLFragCoordFragmentUniforms;

#endif /* GLFragCoordShaderTypes_h */
