//
//  MTLLightingRenderer.swift
//  metal-sandbox-ios
//
//  Created by Renshi Asada on 2024/10/20.
//

import Foundation
import MetalKit

class MTLLightingRenderer {
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
        
        let vertexFunction = library.makeFunction(name: "lighting_vertex_main")
        let fragmentFunction = library.makeFunction(name: "lighting_fragment_main")
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.colorAttachments[0].pixelFormat = .rgba8Unorm_srgb
        descriptor.vertexFunction = vertexFunction
        descriptor.fragmentFunction = fragmentFunction
        self.renderPipelineState = try? device.makeRenderPipelineState(descriptor: descriptor)
        
        let indices: [UInt16] = [
            // front
            0, 1, 2,
            2, 3, 0,
            
            // right
            
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
        var uniforms = LightingUniforms(resolution: resolusion)
        var verticies: [LightingVertex] = [
            // front
            LightingVertex(position: vector_float3(-0.5, -0.5, 0.5)),
            LightingVertex(position: vector_float3( 0.5, -0.5, 0.5)),
            LightingVertex(position: vector_float3( 0.5,  0.5, 0.5)),
            LightingVertex(position: vector_float3(-0.5,  0.5, 0.5)),
            
            // back
            LightingVertex(position: vector_float3(-0.5, -0.5, -0.5)),
            LightingVertex(position: vector_float3(-0.5,  0.5, -0.5)),
            LightingVertex(position: vector_float3( 0.5,  0.5, -0.5)),
            LightingVertex(position: vector_float3( 0.5, -0.5, -0.5)),
        ]
        encorder.setVertexBytes(&verticies, length: MemoryLayout<LightingVertex>.stride * verticies.count, index: 0)
        encorder.setVertexBytes(&uniforms, length: MemoryLayout<LightingUniforms>.stride, index: 1)
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
