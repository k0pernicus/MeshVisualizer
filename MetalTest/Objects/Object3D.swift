//
//  Object3D.swift
//  MetalTest
//
//  Created by Antonin on 30/07/2022.
//

import Foundation

class Object3D: BaseObject3D {
    // The position of the object in the world space
    var position: simd_float3
    var angle: simd_float3
    var rotation_angle_z: Float?
    var allows_transformation: Bool
    
    init(position: simd_float3, angle: simd_float3, allows_transformation: Bool = false) {
        self.position = position
        self.angle = angle
        self.allows_transformation = allows_transformation
        if self.allows_transformation {
            self.rotation_angle_z = Float.random(in: 0..<1)
        }
    }
    
    func update() {
        guard let rotation_angle = self.rotation_angle_z else {
            return
        }
        self.angle.z += rotation_angle
        if self.angle.z > Algebra.MAX_ANGLE {
            self.angle.z -= Algebra.MAX_ANGLE
        }
    }
}
