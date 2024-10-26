//
//  MTLUniformTimeViewController.swift
//  metal-sandbox-ios
//
//  Created by Renshi Asada on 2024/10/26.
//

import UIKit
import SwiftUI
import MetalKit

struct MTLUniformTimeView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> MTLUniformTimeViewController {
        return MTLUniformTimeViewController()
    }
    
    func updateUIViewController(_ uiViewController: MTLUniformTimeViewController, context: Context) {
        
    }
}

class MTLUniformTimeViewController: UIViewController, MTKViewDelegate {
    
    var renderer: MTLUniformTimeRenderer!
    
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
        
        renderer = MTLUniformTimeRenderer(device: device)
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in view: MTKView) {
        renderer.draw(mtkView: view)
    }
}
