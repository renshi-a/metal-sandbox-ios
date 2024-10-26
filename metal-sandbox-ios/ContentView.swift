//
//  ContentView.swift
//  metal-sandbox-ios
//
//  Created by Renshi Asada on 2024/10/20.
//

import SwiftUI

struct ContentView: View {
    
    @State var showSandboxList: Bool = false
    @State var currentSandbox: SandboxCases = .clearColor
    
    var body: some View {
        NavigationStack {
            VStack(spacing: .zero) {
                switch currentSandbox {
                case .clearColor:
                    ClearColorView()
                
                case .lighting:
                    LightingView()
                    
                case .uniformTime:
                    UniformTimeView()
                    
                case .glFragCoord:
                    GLFragCoordView()
                }
            }
            .navigationTitle(currentSandbox.displayTitle)
            .navigationBarTitleDisplayMode(.inline)
            .overlay(alignment: .topTrailing) {
                Button(action: { self.showSandboxList = true }, label: {
                    Image(systemName: "cube.transparent")
                        .font(.system(.title))
                        .foregroundStyle(.gray)
                        .padding()
                })
            }
            .sheet(isPresented: $showSandboxList) {
                List {
                    ForEach(SandboxCases.allCases, id: \.self) { sandbox in
                        HStack {
                            Text(sandbox.displayTitle)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(.caption))
                                .foregroundStyle(.gray)
                        }
                        .padding(8)
                        .contentShape(.rect)
                        .onTapGesture {
                            self.currentSandbox = sandbox
                            self.showSandboxList = false
                        }
                    }
                }
            }
        }
    }
}
