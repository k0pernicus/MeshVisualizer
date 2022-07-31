//
//  Camera.swift
//  MetalTest
//
//  Created by Antonin on 30/07/2022.
//

import Foundation

class Camera: Object3D {
    // The position of the object in the world space
    var position: simd_float3
    var angle: simd_float3 // Should be in degrees!
    
    // The associated transformation matrices
    var forward: vector_float3
    var right: vector_float3
    var up: vector_float3
    
    init(position: vector_float3, angle: vector_float3) {
        self.position = position
        self.angle = angle
        self.forward = [0.0, 0.0, 0.0]
        self.right = [0.0, 0.0, 0.0]
        self.up = [0.0, 0.0, 0.0]
    }
    
    /// The update function includes the radians conversion
    func update() {
        self.forward = [
            cos(self.angle[2] * .pi / 180.0) * sin(self.angle[1] * .pi / 180.0),
            sin(self.angle[2] * .pi / 180.0) * sin(self.angle[1] * .pi / 180.0),
            cos(self.angle[1] * .pi / 180.0)
        ]
        let gUp: vector_float3 = [0.0, 0.0, 1.0]
        self.right = simd.cross(gUp, self.forward)
        self.up = simd.cross(self.forward, self.right)
    }
}