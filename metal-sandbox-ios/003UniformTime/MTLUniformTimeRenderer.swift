//
//  MTLUniformTimeRenderer.swift
//  metal-sandbox-ios
//
//  Created by Renshi Asada on 2024/10/26.
//

import Foundation
import MetalKit

class MTLUniformTimeRenderer {
    let device: MTLDevice
    var commandQueue: MTLCommandQueue?
    var renderPipelineState: MTLRenderPipelineState?
    var indexBuffer: MTLBuffer?
    
    var sceneTime: TimeInterval = 0.0
    var lastRenderTime: TimeInterval
    
    init(device: MTLDevice) {
        self.device = device
        lastRenderTime = CACurrentMediaTime()
        
        guard let queue = device.makeCommandQueue() else {
            return
        }
        self.commandQueue = queue
        
        guard let library = device.makeDefaultLibrary() else {
            return
        }
        
        let vertexFunction = library.makeFunction(name: "uniform_time_vertex_main")
        let fragmentFunction = library.makeFunction(name: "uniform_time_fragment_main")
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
        let timestep = currentTime - lastRenderTime
        
        encorder.setRenderPipelineState(renderPipelineState!)
        
        let w = Float(mtkView.frame.size.width)
        let h = Float(mtkView.frame.size.height)
        var vertexuniforms = UniformTimeVertexUniforms(resolution: simd_float2(w, h))
        var fragmentUniforms = UniformTimeFragmentUniforms(time: Float(sceneTime))
        var verticies: [UniformTimeVertex] = [
            UniformTimeVertex(position: vector_float2(0.0,   0.0)),
            UniformTimeVertex(position: vector_float2(  w,   0.0)),
            UniformTimeVertex(position: vector_float2(  w,     h)),
            UniformTimeVertex(position: vector_float2(0.0,     h))
        ]
        encorder.setVertexBytes(&verticies, length: MemoryLayout<UniformTimeVertex>.stride * verticies.count, index: 0)
        encorder.setVertexBytes(&vertexuniforms, length: MemoryLayout<UniformTimeVertexUniforms>.stride, index: 1)
        encorder.setFragmentBytes(&fragmentUniforms, length: MemoryLayout<UniformTimeFragmentUniforms>.stride, index: 0)
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
        
        sceneTime += timestep
        lastRenderTime = currentTime
    }
}
