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
    @Published var light: Light?
    /// Each object that is figuring in the current scene
    @Published var components: [Object3D]
    /// Enable / disable texture rendering (on live)
    @Published var enableTextureRendering: Bool
    /// If set, strip render each object as set of lines, and
    /// do not draw the triangles (for debugging perspective)
    @Published var strip: Bool = false
    /// The number of frames per second computed
    /// during the previous frame
    @Published var fps: Int = 0
    
    public let tag: String
    /// Increment at each rendering pass, and reset
    /// after one second to compute the number of
    /// computed frames per second (see fps attribute)
    var frameCount: Int = 0
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
    
    init(
        tag: String,
        components: [Object3D],
        light: Light?,
        rotate: Bool = true,
        enableTextureRendering: Bool = true
    ) {
        self.tag = tag
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
            self.fps = self.frameCount
            self.frameCount = 0
        }
        // Update the camera position in the world
        camera.update()
        if light != nil {
            light!.update()
        }
        components.forEach { component in component.update() }
        self.frameCount += 1;
        self.updateView()
    }
    
    func updateView() {
        self.objectWillChange.send()
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
            // All the component rendering must be
            // impacted by the amount of light it projects
            var componentParams: ObjectParameters = ObjectParameters(isLightObject: 0);
            renderEncoder.setVertexBytes(
                &componentParams,
                length: MemoryLayout<ObjectParameters>.stride,
                index: 3
            )
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
        // Render the light if it exists
        if (light != nil) {
            let lightComponent = light!
            renderEncoder.setVertexBuffer(lightComponent.mesh!.metalMesh.vertexBuffers[0].buffer, offset: 0, index: 0)
            var transformationModel: matrix_float4x4 = Algebra.Identity(angle: lightComponent.angle)
            transformationModel = Algebra.Identity(translation: lightComponent.position) * transformationModel
            renderEncoder.setVertexBytes(&transformationModel, length: MemoryLayout<matrix_float4x4>.stride, index: 1)
            // The light object rendering must not be
            // impacted by the amount of light it projects
            var lightParams: ObjectParameters = ObjectParameters(isLightObject: 1);
            renderEncoder.setVertexBytes(
                &lightParams,
                length: MemoryLayout<ObjectParameters>.stride,
                index: 3
            )
            for submesh in lightComponent.mesh!.metalMesh.submeshes {
                renderEncoder.drawIndexedPrimitives(
                    type: .line,
                    indexCount: submesh.indexCount,
                    indexType: submesh.indexType,
                    indexBuffer: submesh.indexBuffer.buffer,
                    indexBufferOffset: submesh.indexBuffer.offset
                )
            }
        }
    }
    
    /// Moves the y and z angles of the camera, based on an offset.
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
    
    /// Zoom-in and zoom-out the scene based on the magnitude parameter.
    /// Zoom-in if the magnitude is positive, otherwise zoom-out.
    func zoomCamera(magnitude: CGFloat) {
        camera.position.z +=
            (magnitude < 1.0) ?
                -(Float(magnitude) + 1.0) :
                Float(magnitude)
    }
    
    /// Moves the position of the camera around and x and y axises,
    /// based on the offset width and height.
    /// The offset is multiplied with a coefficient (default: 0.002) in order
    /// to reduce the drastic position movement, which is smoother than
    /// the default one (1.0).
    /// You can disable the drag / mouse vertical invertion setting the
    /// `verticalInvertion` parameter to `false`.
    func moveCamera(
        offset: CGSize,
        smoothFactor factor: Float = 0.002,
        verticalInvertion: Bool = false,
        horizontalInvertion: Bool = true
    ) {
        let dTheta: Float = Float(offset.width) * factor
        let dPhi: Float = Float(offset.height) * factor
        
        camera.moveBasedOn(axis: Algebra.TrigAxis.y, delta: horizontalInvertion ? -(dTheta) : dTheta)
        camera.moveBasedOn(axis: Algebra.TrigAxis.x, delta: verticalInvertion ? -(dPhi) : dPhi)
    }
    
    /// Rotates the camera object around a given axis, for a certain number of degrees.
    func rotateCamera(degrees: CGFloat, around axis: Algebra.TrigAxis) {
        let degrees = Float(degrees) / 20 // Slow down the rotation
        camera.rotateAround(axis: axis, degree: degrees)
    }
    
    /// Put back the default camera position and angle settings
    func resetCamera() {
        camera.position = DEFAULT_CAMERA_POSITION
        camera.angle = DEFAULT_CAMERA_ANGLE
    }
}
