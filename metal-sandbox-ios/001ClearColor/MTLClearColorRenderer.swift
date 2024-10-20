//
//  MTLClearColorRenderer.swift
//  metal-sandbox-ios
//
//  Created by Renshi Asada on 2024/10/20.
//

import Foundation
import MetalKit

class MTLClearColorRenderer {
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
        
        let vertexFunction = library.makeFunction(name: "clear_color_vertex_main")
        let fragmentFunction = library.makeFunction(name: "clear_color_fragment_main")
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
        
        encorder.setRenderPipelineState(renderPipelineState!)
        
        let w = Float(mtkView.frame.size.width)
        let h = Float(mtkView.frame.size.height)
        let resolusion = simd_make_float2(w, h);
        var uniforms = ClearColorUniforms(resolution: resolusion)
        var verticies: [ClearColorVertex] = [
            ClearColorVertex(position: vector_float2(0.0,   0.0)),
            ClearColorVertex(position: vector_float2(  w,   0.0)),
            ClearColorVertex(position: vector_float2(  w,     h)),
            ClearColorVertex(position: vector_float2(0.0,     h))
        ]
        encorder.setVertexBytes(&verticies, length: MemoryLayout<ClearColorVertex>.stride * verticies.count, index: 0)
        encorder.setVertexBytes(&uniforms, length: MemoryLayout<ClearColorUniforms>.stride, index: 1)
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
