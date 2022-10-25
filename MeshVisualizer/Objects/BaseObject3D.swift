//
//  BaseObject3D.swift
//  MeshVisualizer
//
//  Created by Antonin on 30/07/2022.
//

import Foundation

/// The skeleton of a basic 3D object
protocol BaseObject3D: ObservableObject {
    /// The position of the object in the world space
    var position: simd_float3 { get set }
    /// The visualization angle of the object in the world space
    var angle: simd_float3 { get set }
    /// A name to describe the object
    var tag: String { get }
    
    /// Function to update the attributes of the BaseObject3D, each
    /// time the render function must be called
    func update()
}

extension BaseObject3D {
    func rotateAround(axis: Algebra.TrigAxis, degree: Float) {
        switch (axis) {
        case Algebra.TrigAxis.x: self.angle.x += degree
        case Algebra.TrigAxis.y: self.angle.y += degree
        case Algebra.TrigAxis.z: self.angle.z += degree
        }
    }
    
    func moveBasedOn(axis: Algebra.TrigAxis, delta: Float) {
        switch (axis) {
        case Algebra.TrigAxis.x: self.position.x += delta
        case Algebra.TrigAxis.y: self.position.y += delta
        case Algebra.TrigAxis.z: self.position.z += delta
        }
    }
}
