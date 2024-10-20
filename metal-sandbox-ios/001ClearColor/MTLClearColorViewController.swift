//
//  MTLClearColorViewController.swift
//  metal-sandbox-ios
//
//  Created by Renshi Asada on 2024/10/20.
//

import UIKit
import SwiftUI
import MetalKit

struct MTLClearColorView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> MTLClearColorViewController {
        return MTLClearColorViewController()
    }
    
    func updateUIViewController(_ uiViewController: MTLClearColorViewController, context: Context) {
        
    }
}

class MTLClearColorViewController: UIViewController, MTKViewDelegate {
    
    var renderer: MTLClearColorRenderer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let device = MTLCreateSystemDefaultDevice() else {
            return
        }
        
        let mtkView = MTKView(frame: .zero, device: device)
        mtkView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mtkView)
        
        NSLayoutConstraint.activate([
            mtkView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mtkView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mtkView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mtkView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        mtkView.delegate = self;
        
        renderer = MTLClearColorRenderer(device: device)
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in view: MTKView) {
        renderer.draw(mtkView: view)
    }
}
