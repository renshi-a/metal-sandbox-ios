//
//  LightingMath.swift
//  metal-sandbox-ios
//
//  Created by Renshi Asada on 2024/10/26.
//

import Foundation

enum LightingMath {
    static func rotateYMatrix(_ a: Float) -> simd_float4x4 {
        let col0 = simd_float4( cosf(a), 0.0, sinf(a), 0.0 )
        let col1 = simd_float4( 0.0, 1.0, 0.0, 0.0 )
        let col2 = simd_float4(-sinf(a), 0.0, cosf(a), 0.0)
        let col3 = simd_float4( 0.0, 0.0, 0.0, 1.0)
        return simd_float4x4(columns:(col0, col1, col2, col3))
    }
}
