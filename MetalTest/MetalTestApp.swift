//
//  MetalTestApp.swift
//  MetalTest
//
//  Created by Antonin on 26/07/2022.
//

import SwiftUI

let RENDERER_HEIGHT: CGFloat = 920
let RENDERER_WIDTH: CGFloat = 1280

@main
struct MetalTestApp: App {
    @StateObject private var scene = RenderScene(components: [
        Object3D(
            position: [28.0, 0.0, 0.0],
            angle: [0.0, 0.0, 0.0],
            allows_transformation: true,
            meshFilename: "Crate",
            materialFilename: "Noise"
        ),
        Object3D(
            position: [28.0, 0.0, 5.0],
            angle: [0.0, 0.0, 0.0],
            allows_transformation: true,
            meshFilename: "Crate",
            materialFilename: "Candy"
        ),
        Object3D(
            position: [28.0, 0.0, 10.0],
            angle: [0.0, 0.0, 0.0],
            allows_transformation: true,
            meshFilename: "Crate",
            materialFilename: "Noise"
        ),
    ], rotate: true)
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(scene)
        }
    }
}


