//
//  MTLGLFragCoordRenderer.swift
//  metal-sandbox-ios
//
//  Created by Renshi Asada on 2024/10/26.
//

import Foundation
import MetalKit

class MTLGLFragCoordRenderer {
    let device: MTLDevice
    var commandQueue: MTLCommandQueue?
    var renderPipelineState: MTLRenderPipelineState?
    var indexBuffer: MTLBuffer?
    
    init(device: MTLDevice) {
        self.device = device
        
        guard let queue = device.makeCommandQueue() else {
            return
        }
        self.commandQueue = queue
        
        guard let library = device.makeDefaultLibrary() else {
            return
        }
        
        let vertexFunction = library.makeFunction(name: "gl_fragcoord_vertex_main")
        let fragmentFunction = library.makeFunction(name: "gl_fragcoord_fragment_main")
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.colorAttachments[0].pixelFormat = .rgba8Unorm_srgb
        descriptor.vertexFunction = vertexFunction
        descriptor.fragmentFunction = fragmentFunction
        self.renderPipelineState = try? device.makeRenderPipelineState(descriptor: descriptor)
        
        let indices: [UInt16] = [
            0, 1, 3,
            1, 2, 3,
        ]
        let length = MemoryLayout<UInt16>.size * indices.count
        guard let buffer = device.makeBuffer(length: length) else {
            return
        }
        self.indexBuffer = buffer
        memcpy(indexBuffer!.contents(), indices, length);
    }
    
    public func draw(mtkView: MTKView) {
        mtkView.colorPixelFormat = .rgba8Unorm_srgb
        mtkView.clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        guard let commandBuffer = commandQueue?.makeCommandBuffer() else {
            return
        }
        
        guard let renderPassDescriptor = mtkView.currentRenderPassDescriptor else {
            return
        }
        
        guard let encorder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        
        let currentTime = CACurrentMediaTime()
        
        encorder.setRenderPipelineState(renderPipelineState!)
        
        let w = Float(mtkView.frame.size.width)
        let h = Float(mtkView.frame.size.height)
        var vertexuniforms = GLFragCoordVertexUniforms(resolution: simd_float2(w, h))
        var fragmentUniforms = GLFragCoordFragmentUniforms(resolution: simd_float2(w, h))
        var verticies: [GLFragCoordVertex] = [
            GLFragCoordVertex(position: vector_float2(0.0,   0.0)),
            GLFragCoordVertex(position: vector_float2(  w,   0.0)),
            GLFragCoordVertex(position: vector_float2(  w,     h)),
            GLFragCoordVertex(position: vector_float2(0.0,     h))
        ]
        encorder.setVertexBytes(&verticies, length: MemoryLayout<GLFragCoordVertex>.stride * verticies.count, index: 0)
        encorder.setVertexBytes(&vertexuniforms, length: MemoryLayout<GLFragCoordVertexUniforms>.stride, index: 1)
        encorder.setFragmentBytes(&fragmentUniforms, length: MemoryLayout<GLFragCoordFragmentUniforms>.stride, index: 0)
        encorder.drawIndexedPrimitives(type: .triangle,
                                       indexCount: 6,
                                       indexType: .uint16,
                                       indexBuffer: self.indexBuffer!,
                                       indexBufferOffset: 0,
                                       instanceCount: 2)
        
        encorder.endEncoding()
        
        guard let drawable = mtkView.currentDrawable else {
            return
        }
        commandBuffer.present(drawable)
        
        commandBuffer.commit()
    }
}
