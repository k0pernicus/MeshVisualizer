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
        Basic(
            position: [8.0, 0.0, 0.0],
            angle: [90.0, 0.0, 0.0]
        ),
    ], rotate: true)
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(scene)
        }
    }
}
