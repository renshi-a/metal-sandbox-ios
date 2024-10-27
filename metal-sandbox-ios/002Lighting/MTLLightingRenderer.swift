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
    
    // buffer
    var indexBuffer: MTLBuffer?
    
    // states
    var renderPipelineState: MTLRenderPipelineState?
    var depthStencilState: MTLDepthStencilState?
    
    var angle: Float = 0.0
    
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
        let renderDescriptor = MTLRenderPipelineDescriptor()
        renderDescriptor.colorAttachments[0].pixelFormat = .rgba8Unorm_srgb
        renderDescriptor.depthAttachmentPixelFormat = .depth16Unorm
        renderDescriptor.vertexFunction = vertexFunction
        renderDescriptor.fragmentFunction = fragmentFunction
        self.renderPipelineState = try? device.makeRenderPipelineState(descriptor: renderDescriptor)
        
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.isDepthWriteEnabled = true
        self.depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDescriptor)
        
        let indices: [UInt16] = [
            // front
            0, 1, 2,
            2, 3, 0,
            
            // right
            1, 7, 6,
            6, 2, 1,
            
            // back
            7, 4, 5,
            5, 6, 7,
            
            // left
            5, 4, 3,
            3, 4, 0,
            
            // top
            5, 2, 6,
            2, 5, 3,
            
            // bottom
            1, 7, 0,
            0, 4, 7
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
        mtkView.depthStencilPixelFormat = .depth16Unorm
        mtkView.clearDepth = 1.0
        
        guard let commandBuffer = commandQueue?.makeCommandBuffer() else {
            print("MTLLightingRenderer.draw() Cloudn't create CommandBuffer.")
            return
        }
        
        guard let renderPassDescriptor = mtkView.currentRenderPassDescriptor else {
            print("MTLLightingRenderer.draw() Cloudn't get RenderPassDescriptor.")
            return
        }
        
        guard let encorder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            print("MTLLightingRenderer.draw() Cloudn't create RenderCommandEncoder.")
            return
        }
        
        encorder.setDepthStencilState(depthStencilState!)
        encorder.setRenderPipelineState(renderPipelineState!)
        
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
        var matrix = LightingMath.rotateYMatrix(angle)
        var uniforms = LightingUniforms(modelMatrix: matrix)
        
        encorder.setVertexBytes(&verticies, length: MemoryLayout<LightingVertex>.stride * verticies.count, index: 0)
        encorder.setVertexBytes(&uniforms, length: MemoryLayout<LightingUniforms>.stride, index: 1)
        encorder.drawIndexedPrimitives(type: .triangle,
                                       indexCount: 6 * 6,
                                       indexType: .uint16,
                                       indexBuffer: self.indexBuffer!,
                                       indexBufferOffset: 0,
                                       instanceCount: 2 * 6)
        
        encorder.endEncoding()
        
        guard let drawable = mtkView.currentDrawable else {
            print("MTLLightingRenderer.draw() Cloudn't get currentDrawable.")
            return
        }
        commandBuffer.present(drawable)
        
        commandBuffer.commit()
        
        angle += 0.01
    }
}
