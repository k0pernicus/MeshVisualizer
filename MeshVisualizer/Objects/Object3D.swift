//
//  Object3D.swift
//  MeshVisualizer
//
//  Created by Antonin on 30/07/2022.
//

import Foundation
import Metal
import MetalKit

class Object3D: BaseObject3D {
    // The position of the object in the world space
    var position: simd_float3
    var angle: simd_float3
    var meshFilename: String?
    var materialFilename: String?
    var mesh: Mesh?
    var material: Material?
    var rotation_angle_z: Float?
    var allows_transformation: Bool
    
    init(
        position: simd_float3, angle: simd_float3,
        allows_transformation: Bool = false,
        meshFilename: String? = nil, materialFilename: String? = nil
    ) {
        self.position = position
        self.angle = angle
        self.allows_transformation = allows_transformation
        if self.allows_transformation {
            self.rotation_angle_z = Float.random(in: 0..<1)
        }
        self.meshFilename = meshFilename
        self.materialFilename = materialFilename
    }
    
    func initMesh(device: MTLDevice, allocator: MTKMeshBufferAllocator) {
        // TODO: Should check in a hashmap before any implementation
        if self.mesh != nil { return }
        guard let filename = self.meshFilename else { return }
        self.mesh = Mesh(device: device, allocator: allocator, filename: filename)
    }
    
    func initMaterial(device: MTLDevice, allocator: MTKTextureLoader) {
        // TODO: Should check in a hashmap before any implementation
        if self.material != nil { return }
        guard let filename = self.materialFilename else { return }
        self.material = Material(device: device, allocator: allocator, filename: filename)
    }
    
    func update() {
        // TODO: Should use the transformation attribute,
        // not the rotation by default!
        // Rotation is set by default for test purposes **ONLY**
        guard let rotation_angle = self.rotation_angle_z else {
            return
        }
        self.angle.z += rotation_angle
        if self.angle.z > Algebra.MAX_ANGLE {
            self.angle.z -= Algebra.MAX_ANGLE
        }
    }
}
