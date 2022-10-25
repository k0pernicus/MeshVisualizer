//
//  AppView.swift
//  MeshVisualizer
//
//  Created by Antonin on 01/08/2022.
//

import SwiftUI

let DEFAULT_RENDERER_HEIGHT: CGFloat = 840
let DEFAULT_RENDERER_WIDTH: CGFloat = 1170

struct AppView: View {
    
    @EnvironmentObject var sceneState: RenderScene
    
    var body: some View {
        HStack{
            Spacer()
            ContentView()
                .frame(width: DEFAULT_RENDERER_WIDTH, height: DEFAULT_RENDERER_HEIGHT, alignment: .center)
                .gesture(
                    DragGesture(minimumDistance: 2.0)
                        .onChanged { gesture in
                            sceneState.moveCamera(offset: gesture.translation)
                        }
                )
                .gesture(
                    MagnificationGesture()
                        .onChanged { gesture in
                            sceneState.zoomCamera(magnitude: gesture.magnitude)
                        }
                )
                .gesture(
                    RotationGesture()
                        .onChanged { gesture in
                            sceneState.rotateCamera(degrees: gesture.degrees, around: Algebra.TrigAxis.z)
                        }
                )
                .onTapGesture(count: 3, perform: {
                    sceneState.resetCamera()
                })
                .border(.black, width: 5)
        }
    }
}
