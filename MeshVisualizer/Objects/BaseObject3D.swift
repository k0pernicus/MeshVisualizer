//
//  BaseObject3D.swift
//  MeshVisualizer
//
//  Created by Antonin on 30/07/2022.
//

import Foundation

/// The skeleton of a basic 3D object
protocol BaseObject3D {
    /// The position of the object in the world space
    var position: simd_float3 { get }
    /// The visualization angle of the object in the world space
    var angle: simd_float3 { get set }
    /// A name to describe the object
    var tag: String { get }
    
    /// Function to update the attributes of the BaseObject3D, each
    /// time the render function must be called
    func update()
}
