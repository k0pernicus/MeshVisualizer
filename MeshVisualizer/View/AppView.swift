//
//  AppView.swift
//  MeshVisualizer
//
//  Created by Antonin on 01/08/2022.
//

import SwiftUI

struct AppView: View {
    
    @EnvironmentObject var scene: RenderScene
    
    var body: some View {
        ZStack{
            ContentView()
                .frame(width: DEFAULT_RENDERER_WIDTH, height: DEFAULT_RENDERER_HEIGHT, alignment: .center)
                .aspectRatio(contentMode: .fit)
                .gesture(
                    DragGesture(minimumDistance: 2.0)
                        .onChanged { gesture in
                            scene.spinCamera(offset: gesture.translation)
                        }
                )
                .gesture(
                    MagnificationGesture()
                        .onChanged { gesture in
                            scene.focusCamera(magnitude: gesture.magnitude)
                        }
                )
                .gesture(
                    RotationGesture()
                        .onChanged { gesture in
                            scene.rotateCamera(degrees: gesture.degrees)
                        }
                )
                .onTapGesture(count: 3, perform: {
                    scene.resetCameraPosition()
                })
        }
        .aspectRatio(contentMode: .fill)
        .fixedSize()
        .background(Color.gray)
    }
}

