//
//  Triangle.swift
//  MetalTest
//
//  Created by Antonin on 30/07/2022.
//

import Foundation

class Basic: Object3D {
    // The position of the object in the world space
    var position: simd_float3
    var angle: simd_float3
    
    init(position: simd_float3, angle: simd_float3) {
        self.position = position
        self.angle = angle
    }
    
    func update() {}
}
