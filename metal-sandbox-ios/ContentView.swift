//
//  ContentView.swift
//  metal-sandbox-ios
//
//  Created by Renshi Asada on 2024/10/20.
//

import SwiftUI

struct ContentView: View {
    
    @State var sandboxCases: SandboxCases = .clearColor
    
    var body: some View {
        VStack(spacing: .zero) {
            switch sandboxCases {
            case .clearColor:
                ClearColorView()
            }
        }
    }
}

#Preview {
    ContentView()
}
