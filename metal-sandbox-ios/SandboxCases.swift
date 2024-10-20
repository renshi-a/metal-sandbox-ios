//
//  SandboxCases.swift
//  metal-sandbox-ios
//
//  Created by Renshi Asada on 2024/10/20.
//

import Foundation

enum SandboxCases: CaseIterable {
    case clearColor
    case lighting
    
    var displayTitle: String {
        switch self {
        case .clearColor:
            "Clear Color"
            
        case .lighting:
            "Lighting"
        }
    }
}
