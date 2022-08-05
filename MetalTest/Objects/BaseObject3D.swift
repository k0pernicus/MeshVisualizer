//
//  BaseObject3D.swift
//  MetalTest
//
//  Created by Antonin on 30/07/2022.
//

import Foundation

protocol BaseObject3D {
    // The position of the object in the world space
    var position: simd_float3 { get }
    var angle: simd_float3 { get set }
    
    func update()
}
