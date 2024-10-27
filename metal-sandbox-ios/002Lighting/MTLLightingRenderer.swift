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
            4, 5, 6,
            6, 7, 4,
            
            // back
            8, 9, 10,
            10, 11, 8,
            
            // left
            12, 13, 14,
            14, 15, 12,
            
            // top
            16, 17, 18,
            18, 19, 16,
            
            // bottom
            20, 21, 22,
            22, 23, 20
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
            LightingVertex(position: vector_float3(-0.5, -0.5, 0.5), normal: vector_float3(0.0, 0.0, 1.0)),
            LightingVertex(position: vector_float3( 0.5, -0.5, 0.5), normal: vector_float3(0.0, 0.0, 1.0)),
            LightingVertex(position: vector_float3( 0.5,  0.5, 0.5), normal: vector_float3(0.0, 0.0, 1.0)),
            LightingVertex(position: vector_float3(-0.5,  0.5, 0.5), normal: vector_float3(0.0, 0.0, 1.0)),
            
            // right
            LightingVertex(position: vector_float3( 0.5, -0.5, 0.5), normal: vector_float3(1.0, 0.0, 0.0)),
            LightingVertex(position: vector_float3( 0.5, -0.5, -0.5), normal: vector_float3(1.0, 0.0, 0.0)),
            LightingVertex(position: vector_float3( 0.5,  0.5, -0.5), normal: vector_float3(1.0, 0.0, 0.0)),
            LightingVertex(position: vector_float3( 0.5,  0.5, 0.5), normal: vector_float3(1.0, 0.0, 0.0)),
            
            // back
            LightingVertex(position: vector_float3( 0.5, -0.5, -0.5), normal: vector_float3(0.0, 0.0, -1.0)),
            LightingVertex(position: vector_float3( -0.5, -0.5, -0.5), normal: vector_float3(0.0, 0.0, -1.0)),
            LightingVertex(position: vector_float3( -0.5,  0.5, -0.5), normal: vector_float3(0.0, 0.0, -1.0)),
            LightingVertex(position: vector_float3( 0.5,  0.5, -0.5), normal: vector_float3(0.0, 0.0, -1.0)),
            
            // left
            LightingVertex(position: vector_float3( -0.5, -0.5, -0.5), normal: vector_float3(-1.0, 0.0, 0.0)),
            LightingVertex(position: vector_float3( -0.5, -0.5, 0.5), normal: vector_float3(-1.0, 0.0, 0.0)),
            LightingVertex(position: vector_float3( -0.5,  0.5, 0.5), normal: vector_float3(-1.0, 0.0, 0.0)),
            LightingVertex(position: vector_float3( -0.5,  0.5, -0.5), normal: vector_float3(-1.0, 0.0, 0.0)),
            
            // top
            LightingVertex(position: vector_float3( -0.5,  0.5, 0.5), normal: vector_float3(0.0, 1.0, 0.0)),
            LightingVertex(position: vector_float3(  0.5,  0.5, 0.5), normal: vector_float3(0.0, 1.0, 0.0)),
            LightingVertex(position: vector_float3(  0.5,  0.5, -0.5), normal: vector_float3(0.0, 1.0, 0.0)),
            LightingVertex(position: vector_float3( -0.5,  0.5, -0.5), normal: vector_float3(0.0, 1.0, 0.0)),
            
            // bottom
            LightingVertex(position: vector_float3( -0.5, -0.5, -0.5), normal: vector_float3(0.0, -1.0, 0.0)),
            LightingVertex(position: vector_float3(  0.5, -0.5, -0.5), normal: vector_float3(0.0, -1.0, 0.0)),
            LightingVertex(position: vector_float3(  0.5, -0.5,  0.5), normal: vector_float3(0.0, -1.0, 0.0)),
            LightingVertex(position: vector_float3( -0.5, -0.5,  0.5), normal: vector_float3(0.0, -1.0, 0.0)),
        ]
        let matrix = LightingMath.rotateYMatrix(angle)
        var uniforms = LightingUniforms(modelMatrix: matrix)
        
        encorder.setVertexBytes(&verticies, length: MemoryLayout<LightingVertex>.stride * verticies.count, index: 0)
        encorder.setVertexBytes(&uniforms, length: MemoryLayout<LightingUniforms>.stride, index: 1)
        
        encorder.setCullMode(.back)
        encorder.setFrontFacing(.counterClockwise)
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
