//
//  Scene.swift
//  MetalTest
//
//  Created by Antonin on 30/07/2022.
//

import Foundation

/// This is supposed to be the Scene object, but as Swift
/// as already a Scene object for SwiftUI, I can't named it
/// like that.
struct RenderScene {
    
    let camera: Camera
    let components: [Object3D]
    let rng: [Float]
    
    init(components: [Object3D], rotate: Bool = true) {
        self.camera = Camera(
            position: [-1.0, 0.0, 0.0],
            angle: [0.0, 75.0, 0.0]
        )
        self.components = components
        self.rng = rotate ?
            [Float.random(in: 0..<1), Float.random(in: 0..<1), Float.random(in: 0..<1)] :
            [0.0, 0.0, 0.0]
    }
    
    func update() {
        // Update the camera position in the world
        camera.update()
        // Update the position of the world's components
        // based on the camera view
        for component in components {
            var component = component
            /*
            component.angle.x += self.rng[0]
            if component.angle.x > Algebra.MAX_ANGLE {
                component.angle.x -= Algebra.MAX_ANGLE
            }
            component.angle.y += self.rng[1]
            if component.angle.y > Algebra.MAX_ANGLE {
                component.angle.y -= Algebra.MAX_ANGLE
            }
            */
            component.angle.z += self.rng[2]
            if component.angle.z > Algebra.MAX_ANGLE {
                component.angle.z -= Algebra.MAX_ANGLE
            }
        }
    }
    
}
