//
//  Scene.swift
//  MetalTest
//
//  Created by Antonin on 30/07/2022.
//

import Foundation
import SwiftUI

let DEFAULT_CAMERA_POSITION: vector_float3 = [-1.0, 0.0, 0.0]
let DEFAULT_CAMERA_ANGLE: vector_float3 = [0.0, 75.0, 0.0]

/// This is supposed to be the Scene object, but as Swift
/// as already a Scene object for SwiftUI, I can't named it
/// like that.
class RenderScene: ObservableObject {
    
    @Published var camera: Camera
    @Published var components: [Object3D]
    @Published var frameCount: Int = 0
    
    private var endDate: Date // Compute FPS
    
    init(components: [Object3D], rotate: Bool = true) {
        self.camera = Camera(
            position: DEFAULT_CAMERA_POSITION,
            angle: DEFAULT_CAMERA_ANGLE
        )
        self.components = components
        self.endDate = Date().addingTimeInterval(1)
    }
    
    func update() {
        let dDiff = Date().compare(self.endDate)
        // Reset FPS counter if needed
        if (dDiff == .orderedSame || dDiff == .orderedDescending) {
            print("FPS: \(self.frameCount)")
            // End is (now + 1sec)
            self.endDate = Date().addingTimeInterval(1)
            self.frameCount = 0
        }
        // Update the camera position in the world
        camera.update()
        for component in components {
            component.update()
        }
        self.frameCount += 1;
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
    
    func focusCamera(magnitude: CGFloat) {
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
