//
//  Light.swift
//  MeshVisualizer
//
//  Created by Antonin on 07/08/2022.
//

import Foundation
import MetalKit

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
    var mesh: Mesh?
    var material: Material?
    
    var forward: vector_float3
    var color: vector_float3
    let type: LightType
    var intensity: Float
    let uses_radians: Bool
    
    init(
        angle: simd_float3,
        color: simd_float3,
        type: LightType,
        intensity: Float = 1.0,
        uses_radians: Bool = false
    ) {
        self.position = [0.0, 0.0, 0.0]
        self.angle = angle
        self.forward = [0.0, 0.0, 0.0]
        self.color = color
        self.type = type
        self.uses_radians = uses_radians
        self.intensity = intensity
        
        // Compute the first forward
        self.update()
        self.mesh = nil
        self.material = nil
    }
    
    /// Allocates memory and initializes a mesh to render
    /// This function takes a look first in the cache parameter if the mesh is not already used
    /// If the mesh, based on the filename, exists, then the content will be used again in order to optimize
    /// the resources allocation.
    /// Otherwise, the MTKMesh object is created, and the cache is modified in order to store it in the cache first,
    /// to be reused after.
    func initMesh(device: MTLDevice, allocator: MTKMeshBufferAllocator) {
        self.mesh = Mesh(device: device, allocator: allocator, filename: "Sphere")
    }
    
    /// Allocates memory and initializes a material (or texture) to render
    /// This function takes a look first in the cache parameter if the material is not already used
    /// If the material, based on the filename, exists, then the content will be used again in order to optimize
    /// the resources allocation.
    /// Otherwise, the texture object is created, and the cache is modified in order to store it in the cache first,
    /// to be reused after.
    func initMaterial(device: MTLDevice, allocator: MTKTextureLoader, cache: inout [String: Material]) {
        let filename = "Candy"
        if self.material != nil { return }
        guard let existingMaterial = cache[filename] else {
            self.material = Material(device: device, allocator: allocator, filename: filename)
            cache[filename] = self.material
            return
        }
        self.material = existingMaterial
    }
    
    private func rotate() {
        self.angle.z += 1
        if self.angle.z > Algebra.MAX_ANGLE {
            self.angle.z -= Algebra.MAX_ANGLE
        }
        self.angle.y += 1
        if self.angle.y > Algebra.MAX_ANGLE {
            self.angle.y -= Algebra.MAX_ANGLE
        }
    }
    
    func update() {
        rotate()
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
