//
//  Mesh.swift
//  MeshVisualizer
//
//  Created by Antonin on 31/07/2022.
//

import Foundation
import MetalKit

class Mesh {
        
    /// Load object render
    let modelIOMesh: MDLMesh
    /// The converted (Metal) object to render
    let metalMesh: MTKMesh
    /// The height of the asset
    let height: Float
    /// The width of the asset
    let width: Float
    /// The depth of the asset
    let depth: Float
    
    init(device: MTLDevice, allocator: MTKMeshBufferAllocator, filename: String) {
        guard let objMeshURL = Bundle.main.url(forResource: filename, withExtension: "obj") else {
            fatalError("cannot load .obj file")
        }
        
        let meshVertexDescriptor = MTLVertexDescriptor()
        var offset: Int = 0
        
        // Position
        meshVertexDescriptor.attributes[0].format = .float3
        meshVertexDescriptor.attributes[0].offset = offset
        meshVertexDescriptor.attributes[0].bufferIndex = 0
        offset += MemoryLayout<SIMD3<Float>>.stride
        
        // Texture
        meshVertexDescriptor.attributes[1].format = .float2
        meshVertexDescriptor.attributes[1].offset = offset
        meshVertexDescriptor.attributes[1].bufferIndex = 0
        offset += MemoryLayout<SIMD2<Float>>.stride
        
        // Normal vector (light)
        meshVertexDescriptor.attributes[2].format = .float3
        meshVertexDescriptor.attributes[2].offset = offset
        meshVertexDescriptor.attributes[2].bufferIndex = 0
        offset += MemoryLayout<SIMD3<Float>>.stride
        
        meshVertexDescriptor.layouts[0].stride = offset
        
        let meshDescriptor = MTKModelIOVertexDescriptorFromMetal(meshVertexDescriptor)
        (meshDescriptor.attributes[0] as! MDLVertexAttribute).name = MDLVertexAttributePosition
        (meshDescriptor.attributes[1] as! MDLVertexAttribute).name = MDLVertexAttributeTextureCoordinate
        (meshDescriptor.attributes[2] as! MDLVertexAttribute).name = MDLVertexAttributeNormal
        
        let asset = MDLAsset(url: objMeshURL, vertexDescriptor: meshDescriptor, bufferAllocator: allocator)
        
        let maxBounds = asset.boundingBox.maxBounds
        let minBounds = asset.boundingBox.minBounds
        
        // TODO: Update this in case of animation
        self.width = maxBounds.x - minBounds.x
        self.height = maxBounds.y - minBounds.y
        self.depth = maxBounds.z - minBounds.z
        
        self.modelIOMesh = asset.childObjects(of: MDLMesh.self).first as! MDLMesh
        do {
            self.metalMesh = try MTKMesh(mesh: self.modelIOMesh, device: device)
        } catch {
            fatalError("cannot convert the model IO to MTKMesh")
        }
    }
    
}


