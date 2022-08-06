//
//  Material.swift
//  MetalTest
//
//  Created by Antonin on 03/08/2022.
//

import Foundation
import MetalKit

/// Default options:
/// * Do not consider the texture as SRGB,
/// * Generate mipmap by default for better results.
let DEFAULT_OPTIONS : [MTKTextureLoader.Option: Any] = [
    .SRGB: false,
    .generateMipmaps: true
]

/// Allocate resources for a new texture, or material
struct Material {
    
    let texture: MTLTexture
    let sampler: MTLSamplerState
    
    init(device: MTLDevice, allocator: MTKTextureLoader, filename: String, options: [MTKTextureLoader.Option: Any] = DEFAULT_OPTIONS) {
        guard let texURL = Bundle.main.url(forResource: filename, withExtension: "jpg") else {
            fatalError("cannot load material file '\(filename).jpg'")
        }
        
        do {
            self.texture = try allocator.newTexture(URL: texURL, options: options)
        } catch {
            fatalError("error allocating the texture with URL '\(texURL)'")
        }
        
        let samplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor.sAddressMode = .repeat
        samplerDescriptor.tAddressMode = .repeat
        samplerDescriptor.minFilter = .nearest
        samplerDescriptor.magFilter = .linear
        samplerDescriptor.mipFilter = .linear
        samplerDescriptor.maxAnisotropy = 8

        self.sampler = device.makeSamplerState(descriptor: samplerDescriptor)!
    }
    
}
