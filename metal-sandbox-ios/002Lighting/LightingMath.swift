//
//  LightingMath.swift
//  metal-sandbox-ios
//
//  Created by Renshi Asada on 2024/10/26.
//

import Foundation

enum LightingMath {
    static func rotateMatrix(angle: Float) -> simd_float4x4 {
        let col0 = simd_float4(0.0)
        let col1 = simd_float4(0.0)
        let col2 = simd_float4(0.0)
        let col3 = simd_float4(0.0)
        return simd_float4x4(columns:(col0, col1, col2, col3))
    }
}
