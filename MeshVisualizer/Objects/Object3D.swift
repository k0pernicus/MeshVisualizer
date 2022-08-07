//
//  Object3D.swift
//  MeshVisualizer
//
//  Created by Antonin on 30/07/2022.
//

import Foundation
import Metal
import MetalKit

/// A 3D object, to be implemented in a given
/// render scene
class Object3D: BaseObject3D {
    var tag: String
    var position: simd_float3
    var angle: simd_float3
    
    var meshFilename: String?
    var mesh: Mesh?
    
    var materialFilename: String?
    var material: Material?
    
    var rotation_angle_z: Float?
    
    init(
        tag: String,
        position: simd_float3, angle: simd_float3,
        allows_transformation: Bool = false,
        meshFilename: String? = nil, materialFilename: String? = nil
    ) {
        self.tag = tag
        self.position = position
        self.angle = angle
        if allows_transformation {
            self.rotation_angle_z = Float.random(in: 0..<1)
        }
        self.meshFilename = meshFilename
        self.materialFilename = materialFilename
    }
    
    /// Allocates memory and initializes a mesh to render
    /// This function takes a look first in the cache parameter if the mesh is not already used
    /// If the mesh, based on the filename, exists, then the content will be used again in order to optimize
    /// the resources allocation.
    /// Otherwise, the MTKMesh object is created, and the cache is modified in order to store it in the cache first,
    /// to be reused after.
    func initMesh(device: MTLDevice, allocator: MTKMeshBufferAllocator, cache: inout [String: Mesh]) {
        if self.mesh != nil { return }
        guard let filename = self.meshFilename else { return }
        guard let existingMesh = cache[filename] else {
            self.mesh = Mesh(device: device, allocator: allocator, filename: filename)
            cache[filename] = self.mesh
            return
        }
        self.mesh = existingMesh
    }
    
    /// Allocates memory and initializes a material (or texture) to render
    /// This function takes a look first in the cache parameter if the material is not already used
    /// If the material, based on the filename, exists, then the content will be used again in order to optimize
    /// the resources allocation.
    /// Otherwise, the texture object is created, and the cache is modified in order to store it in the cache first,
    /// to be reused after.
    func initMaterial(device: MTLDevice, allocator: MTKTextureLoader, cache: inout [String: Material]) {
        if self.material != nil { return }
        guard let filename = self.materialFilename else { return }
        guard let existingMaterial = cache[filename] else {
            self.material = Material(device: device, allocator: allocator, filename: filename)
            cache[filename] = self.material
            return
        }
        self.material = existingMaterial
    }
    
    /// Basic rotation animation for the moment, in order to
    /// test and manage the architecture of the project
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
