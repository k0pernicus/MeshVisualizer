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
            allows_transformation: true
        ),
        Object3D(
            position: [28.0, 0.0, 5.0],
            angle: [0.0, 0.0, 0.0],
            allows_transformation: true
        ),
        Object3D(
            position: [28.0, 0.0, 10.0],
            angle: [0.0, 0.0, 0.0],
            allows_transformation: true
        ),
        Object3D(
            position: [28.0, 0.0, 15.0],
            angle: [0.0, 0.0, 0.0],
            allows_transformation: true
        ),
    ], rotate: true)
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(scene)
        }
    }
}
