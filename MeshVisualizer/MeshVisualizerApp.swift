//
//  MeshVisualizerApp.swift
//  MeshVisualizer
//
//  Created by Antonin on 26/07/2022.
//

import SwiftUI

class ShowPanel: ObservableObject {
    @Published var show: Bool = false
    
    func toggle() {
        self.show = !self.show
    }
}

@main
struct MeshVisualizerApp: App {
    @StateObject private var scene = threeCrates
    @StateObject private var showPanel = ShowPanel()
    
    /// Minimal height of the game engine window
    private let minSideBarHeight: CGFloat = 720

    /// Minimal width of the right side bar
    private let minSideBarWidth: CGFloat = 250
    
    var body: some Scene {
        WindowGroup {
            HStack {
                AppView()
                    .environmentObject(scene)
                SettingsPanelView(panelHeight: minSideBarHeight, panelWidth: minSideBarWidth)
                    .environmentObject(scene)
            }
            .navigationTitle("Mesh Visualizer")
//            .toolbar{
//                ToolbarItemGroup {
//                    Button(action: {showPanel.toggle()}, label: {
//                        Image(systemName: "sidebar.right")
//                    })
//                        .help(Text("Toggle the right panel"))
//                }
//            }
        }
    }
}


