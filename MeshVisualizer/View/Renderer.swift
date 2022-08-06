//
//  Renderer.swift
//  MeshVisualizer
//
//  Created by Antonin on 26/07/2022.
//

import Foundation
import MetalKit

let DEFAULT_FAR_CAMERA_LIMIT: Float = 1000
let DEFAULT_FIELD_OF_VIEW_Y_AXIS: Float = 45

class Renderer: NSObject, MTKViewDelegate {
    var parent: ContentView
    var metalDevice: MTLDevice!
    var metalCommandQueue: MTLCommandQueue!
   
    let allocator: MTKMeshBufferAllocator!
    let materialAllocator: MTKTextureLoader
    
    let pipelineState: MTLRenderPipelineState
    let depthStencilState: MTLDepthStencilState
    
    var scene: RenderScene
    
    init(_ parent: ContentView, scene: RenderScene) {
        self.parent = parent
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            self.metalDevice = metalDevice
        }
        self.metalCommandQueue = metalDevice.makeCommandQueue()
        self.allocator = MTKMeshBufferAllocator(device: self.metalDevice)
        self.materialAllocator = MTKTextureLoader(device: self.metalDevice)
        for component in scene.components {
            component.initMesh(device: self.metalDevice, allocator: self.allocator)
            component.initMaterial(device: self.metalDevice, allocator: self.materialAllocator)
        }
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        let library = metalDevice.makeDefaultLibrary()
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertexShader")
        if (scene.renderTexture) {
            pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "texFragmentShader")
        } else {
            pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragmentShader")
        }
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        // TODO: find a solution for this problem
        pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(scene.components[0].mesh!.metalMesh.vertexDescriptor)
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
        renderEncoder?.setDepthStencilState(self.depthStencilState)
        
        // Set the camera
        var cameraData: CameraParameters = CameraParameters()
        cameraData.view = Algebra.LookAt(
            camera: scene.camera.position,
            object: scene.camera.position + scene.camera.forward,
            up: scene.camera.up
        )
        cameraData.projection = Algebra.PerspectiveProjection(
            fieldOfViewY: DEFAULT_FIELD_OF_VIEW_Y_AXIS,
            aspect: Float(DEFAULT_RENDERER_HEIGHT / DEFAULT_RENDERER_WIDTH),
            nearLimit: 0.1,
            farLimit: DEFAULT_FAR_CAMERA_LIMIT
        )
        renderEncoder?.setVertexBytes(&cameraData, length: MemoryLayout<CameraParameters>.stride, index: 2)
        
        scene.render(renderEncoder: renderEncoder!)
        
        renderEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
