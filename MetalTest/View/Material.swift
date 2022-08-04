//
//  Material.swift
//  MetalTest
//
//  Created by Antonin on 03/08/2022.
//

import Foundation
import MetalKit

struct Material {
    
    let texture: MTLTexture
    let sampler: MTLSamplerState
    
    init(device: MTLDevice, allocator: MTKTextureLoader, filename: String) {
        guard let texURL = Bundle.main.url(forResource: filename, withExtension: "jpg") else {
            fatalError("cannot load .jpg file")
        }
        
        let options : [MTKTextureLoader.Option: Any] = [
            .SRGB: false,
            .generateMipmaps: true,
        ]
        
        do {
            self.texture = try allocator.newTexture(URL: texURL, options: options)
        } catch {
            fatalError("could not load the texture")
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
