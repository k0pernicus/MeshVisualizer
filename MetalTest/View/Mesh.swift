//
//  Mesh.swift
//  MetalTest
//
//  Created by Antonin on 31/07/2022.
//

import Foundation
import MetalKit

class Mesh {
        
    let modelIOMesh: MDLMesh // Load object render
    let metalMesh: MTKMesh // The converted object to render
    
    init(device: MTLDevice, allocator: MTKMeshBufferAllocator, filename: String) {
        guard let objMeshURL = Bundle.main.url(forResource: filename, withExtension: "obj") else {
            fatalError("cannot load .obj file")
        }
        
        let meshVertexDescriptor = MTLVertexDescriptor()
        var offset: Int = 0
        
        meshVertexDescriptor.attributes[0].format = .float3
        meshVertexDescriptor.attributes[0].offset = offset
        meshVertexDescriptor.attributes[0].bufferIndex = 0
        
        offset += MemoryLayout<SIMD3<Float>>.stride
        
        meshVertexDescriptor.layouts[0].stride = offset
        
        let meshDescriptor = MTKModelIOVertexDescriptorFromMetal(meshVertexDescriptor)
        (meshDescriptor.attributes[0] as! MDLVertexAttribute).name = MDLVertexAttributePosition
        
        let asset = MDLAsset(url: objMeshURL, vertexDescriptor: meshDescriptor, bufferAllocator: allocator)
        
        self.modelIOMesh = asset.childObjects(of: MDLMesh.self).first as! MDLMesh
        do {
            self.metalMesh = try MTKMesh(mesh: self.modelIOMesh, device: device)
        } catch {
            fatalError("cannot convert the model IO to MTKMesh")
        }
    }
    
}


