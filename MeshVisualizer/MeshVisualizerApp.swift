//
//  MeshVisualizerApp.swift
//  MeshVisualizer
//
//  Created by Antonin on 26/07/2022.
//

import SwiftUI

@main
struct MeshVisualizerApp: App {
    @StateObject private var scene = threeCrates
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(scene)
        }
    }
}


