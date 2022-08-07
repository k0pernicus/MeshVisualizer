//
//  Light.swift
//  MeshVisualizer
//
//  Created by Antonin on 07/08/2022.
//

import Foundation

class Light: BaseObject3D {
    /// The type of light to implement
    enum LightType {
        case directional
        case pointlight
        case spotlight
    }
    
    var position: simd_float3
    var angle: simd_float3
    var tag: String = "camera"
    
    var forward: vector_float3
    var color: vector_float3
    let type: LightType
    let uses_radians: Bool
    
    init(angle: simd_float3, color: simd_float3, type: LightType, uses_radians: Bool = false) {
        self.position = [0.0, 0.0, 0.0]
        self.angle = angle
        self.forward = [0.0, 0.0, 0.0]
        self.color = color
        self.type = type
        self.uses_radians = uses_radians
        
        // Compute the first forward
        self.update()
    }
    
    func update() {
        switch (self.type) {
        case .directional:
            if self.uses_radians {
                self.forward = [
                    cos(self.angle[2]) * sin(self.angle[1]),
                    sin(self.angle[2]) * sin(self.angle[1]),
                    cos(self.angle[1]),
                ]
            } else {
                self.forward = [
                    cos(self.angle[2] * .pi / 180.0) * sin(self.angle[1] * .pi / 180.0),
                    sin(self.angle[2] * .pi / 180.0) * sin(self.angle[1] * .pi / 180.0),
                    cos(self.angle[1] * .pi / 180.0),
                ]
            }
            break
        default:
            fatalError("Light with direction \(self.type) is not implemented yet")
        }
    }
    
}
