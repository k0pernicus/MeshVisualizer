//
//  AppView.swift
//  MeshVisualizer
//
//  Created by Antonin on 01/08/2022.
//

import SwiftUI

/// Minimal height of the game engine window
private let minSideBarHeight: CGFloat = 720

/// Minimal width of the right side bar
private let minSideBarWidth: CGFloat = 250

let DEFAULT_RENDERER_HEIGHT: CGFloat = 800
let DEFAULT_RENDERER_WIDTH: CGFloat = 1000

struct AppView: View {
    
    @EnvironmentObject var scene: RenderScene
    
    var body: some View {
        HStack{
            Spacer()
            ContentView()
                .frame(width: DEFAULT_RENDERER_WIDTH, height: DEFAULT_RENDERER_HEIGHT, alignment: .center)
                .gesture(
                    DragGesture(minimumDistance: 2.0)
                        .onChanged { gesture in
                            scene.spinCamera(offset: gesture.translation)
                        }
                )
                .gesture(
                    MagnificationGesture()
                        .onChanged { gesture in
                            scene.zoomCamera(magnitude: gesture.magnitude)
                        }
                )
                .gesture(
                    RotationGesture()
                        .onChanged { gesture in
                            scene.rotateCamera(degrees: gesture.degrees, around: Algebra.TrigAxis.z)
                        }
                )
                .onTapGesture(count: 3, perform: {
                    scene.resetCameraPosition()
                })
                .border(.black, width: 5)
            Spacer()
            SettingsPanelView(panelHeight: minSideBarHeight, panelWidth: minSideBarWidth)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray)
    }
}
