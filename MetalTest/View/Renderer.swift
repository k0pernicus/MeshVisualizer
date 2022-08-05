//
//  Renderer.swift
//  MetalTest
//
//  Created by Antonin on 26/07/2022.
//

import Foundation
import MetalKit

let texturedExample: Bool = false

class Renderer: NSObject, MTKViewDelegate {
    var parent: ContentView
    var metalDevice: MTLDevice!
    var metalCommandQueue: MTLCommandQueue!
   
    let allocator: MTKMeshBufferAllocator!
    let materialAllocator: MTKTextureLoader
    
    let pipelineState: MTLRenderPipelineState
    let depthStencilState: MTLDepthStencilState
    
    var scene: RenderScene
    let mesh: Mesh
    let material: Material
    
    init(_ parent: ContentView, scene: RenderScene) {
        self.parent = parent
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            self.metalDevice = metalDevice
        }
        self.metalCommandQueue = metalDevice.makeCommandQueue()
        self.allocator = MTKMeshBufferAllocator(device: self.metalDevice)
        self.materialAllocator = MTKTextureLoader(device: self.metalDevice)
        
        self.mesh = Mesh(device: self.metalDevice, allocator: self.allocator, filename: "Crate")
        self.material = Material(device: self.metalDevice, allocator: self.materialAllocator, filename: "Crate")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        let library = metalDevice.makeDefaultLibrary()
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertexShader")
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragmentShader")
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(self.mesh.metalMesh.vertexDescriptor)
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.isDepthWriteEnabled = true
        self.depthStencilState = self.metalDevice.makeDepthStencilState(descriptor: depthStencilDescriptor)!
        
        do {
            try pipelineState = metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("cannot create the render pipeline state")
        }
        
        self.scene = scene
        
        super.init()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in view: MTKView) {
        scene.update()
        
        guard let drawable = view.currentDrawable else {
            return
        }
        
        let commandBuffer = metalCommandQueue.makeCommandBuffer()
        
        let renderPassDescriptor = view.currentRenderPassDescriptor
        renderPassDescriptor?.colorAttachments[0].clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        renderPassDescriptor?.colorAttachments[0].loadAction = .clear
        renderPassDescriptor?.colorAttachments[0].storeAction = .store
        
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor!)
        renderEncoder?.setRenderPipelineState(self.pipelineState)
        
        var cameraData: CameraParameters = CameraParameters()
        cameraData.view = Algebra.LookAt(
            camera: scene.camera.position,
            object: scene.camera.position + scene.camera.forward,
            up: scene.camera.up
        )
        cameraData.projection = Algebra.PerspectiveProjection(
            fovy: 45, aspect: Float(RENDERER_HEIGHT / RENDERER_WIDTH), near: 0.1, far: 44
        )
        renderEncoder?.setVertexBytes(&cameraData, length: MemoryLayout<CameraParameters>.stride, index: 2)
        
        renderEncoder?.setVertexBuffer(self.mesh.metalMesh.vertexBuffers[0].buffer, offset: 0, index: 0)
        renderEncoder?.setFragmentTexture(self.material.texture, index: 0)
        renderEncoder?.setDepthStencilState(self.depthStencilState)
        renderEncoder?.setFragmentSamplerState(self.material.sampler, index: 0)
        
        // TODO: move to the scene ?
        for component in scene.components {
            var transformationModel: matrix_float4x4 = Algebra.Identity(angle: component.angle)
            transformationModel = Algebra.Identity(translation: component.position) * transformationModel
            renderEncoder?.setVertexBytes(&transformationModel, length: MemoryLayout<matrix_float4x4>.stride, index: 1)
            for submesh in self.mesh.metalMesh.submeshes {
                renderEncoder?.drawIndexedPrimitives(
                    type: .triangle,
                    indexCount: submesh.indexCount,
                    indexType: submesh.indexType,
                    indexBuffer: submesh.indexBuffer.buffer,
                    indexBufferOffset: submesh.indexBuffer.offset
                )
            }
        }
        
        renderEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
