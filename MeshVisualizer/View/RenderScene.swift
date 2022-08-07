//
//  Scene.swift
//  MeshVisualizer
//
//  Created by Antonin on 30/07/2022.
//

import os
import Foundation
import SwiftUI

let DEFAULT_CAMERA_POSITION: vector_float3 = [-1.0, 0.0, 25.0]
let DEFAULT_CAMERA_ANGLE: vector_float3 = [-45.0, 132.0, 0.0]

private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "render_scene")

/// This is supposed to be the Scene object, but as Swift
/// as already a Scene object for SwiftUI, I can't named it
/// like that.
class RenderScene: ObservableObject {
    /// The camera in the scene
    @Published var camera: Camera
    /// The light in the scene
    @Published var light: Light
    /// Each object that is figuring in the current scene
    @Published var components: [Object3D]
    /// Enable / disable texture rendering (on live)
    @Published var enableTextureRendering: Bool
    /// If set, strip render each object as set of lines, and
    /// do not draw the triangles (for debugging perspective)
    @Published var strip: Bool = false
    
    /// FPS
    private var frameCount: Int = 0
    /// The number of seconds since the first frame
    private var sec: Int = 0
    /// Internal private attribute in order to compute
    /// the FPS
    private var endDate: Date // Compute FPS
    /// Private structure in order to not allocate multiple times the
    /// same mesh
    public var meshesCache: [String: Mesh] // TODO: should be private
    /// Private structure in order to not allocate multiple times the
    /// same material
    public var materialsCache: [String: Material] // TODO: should be private
    
    init(light: Light, components: [Object3D], rotate: Bool = true, enableTextureRendering: Bool = true) {
        self.light = light
        self.camera = Camera(
            position: DEFAULT_CAMERA_POSITION,
            angle: DEFAULT_CAMERA_ANGLE
        )
        self.components = components
        // To compute the FPS, we need to determine the limit
        // to get the frames count (now + 1sec)
        self.endDate = Date().addingTimeInterval(1)
        self.enableTextureRendering = enableTextureRendering
        self.meshesCache = [:]
        self.materialsCache = [:]
    }
    
    func update() {
        let dDiff = Date().compare(self.endDate)
        // Reset FPS counter if needed
        if (dDiff == .orderedSame || dDiff == .orderedDescending) {
            self.sec += 1
            self.endDate = Date().addingTimeInterval(1)
            logger.debug("[\(self.sec)]: \(self.frameCount) FPS")
            self.frameCount = 0
        }
        // Update the camera position in the world
        camera.update()
        light.update()
        for component in components {
            component.update()
        }
        self.frameCount += 1;
    }
    
    /// For each internal component, fills and set the vertex buffer and draw each element
    func render(renderEncoder: MTLRenderCommandEncoder) {
        for component in components {
            renderEncoder.setVertexBuffer(component.mesh!.metalMesh.vertexBuffers[0].buffer, offset: 0, index: 0)
            if enableTextureRendering {
                renderEncoder.setFragmentSamplerState(component.material!.sampler, index: 0)
                renderEncoder.setFragmentTexture(component.material!.texture, index: 0)
            }
            var transformationModel: matrix_float4x4 = Algebra.Identity(angle: component.angle)
            transformationModel = Algebra.Identity(translation: component.position) * transformationModel
            renderEncoder.setVertexBytes(&transformationModel, length: MemoryLayout<matrix_float4x4>.stride, index: 1)
            for submesh in component.mesh!.metalMesh.submeshes {
                renderEncoder.drawIndexedPrimitives(
                    type: self.strip ? .line : .triangle,
                    indexCount: submesh.indexCount,
                    indexType: submesh.indexType,
                    indexBuffer: submesh.indexBuffer.buffer,
                    indexBufferOffset: submesh.indexBuffer.offset
                )
            }
        }
    }
    
    func spinCamera(offset: CGSize) {
        let dTheta: Float = Float(offset.width) * 0.005
        let dPhi: Float = Float(offset.height) * 0.005
        
        camera.angle.z += dTheta
        camera.angle.y += dPhi
        
        if camera.angle.z < 0 || camera.angle.z >= Algebra.MAX_ANGLE {
            camera.angle.z -= Algebra.MAX_ANGLE
        }
        if camera.angle.y < 1 {
            camera.angle.y = 1
        } else if camera.angle.y > 179 {
            camera.angle.y = 179
        }
    }
    
    func zoomCamera(magnitude: CGFloat) {
        camera.position.x +=
            (magnitude < 1.0) ?
                -(Float(magnitude) + 1.0) :
                Float(magnitude)
    }
    
    func rotateCamera(degrees: CGFloat) {
        camera.angle.z += Float(degrees) / 20
        // camera.position.y += Float(degrees) / 100
    }
    
    func resetCameraPosition() {
        camera.position = DEFAULT_CAMERA_POSITION
        camera.angle = DEFAULT_CAMERA_ANGLE
    }
}
