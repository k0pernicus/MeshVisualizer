//
//  MetalTestApp.swift
//  MetalTest
//
//  Created by Antonin on 26/07/2022.
//

import SwiftUI

let DEFAULT_RENDERER_HEIGHT: CGFloat = 920
let DEFAULT_RENDERER_WIDTH: CGFloat = 1280

@main
struct MetalTestApp: App {
    @StateObject private var scene = threeCrates
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(scene)
        }
    }
}


