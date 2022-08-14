//
//  SettingsPanelView.swift
//  MeshVisualizer
//
//  Created by Antonin on 14/08/2022.
//

import SwiftUI

struct SettingsPanelView: View {
    private var height: CGFloat
    private var width: CGFloat
    
    @EnvironmentObject var scene: RenderScene
    
    init(panelHeight height: CGFloat, panelWidth width: CGFloat) {
        self.height = height
        self.width = width
    }
    
    var body: some View {
        List {
            Group {
                // All about the current scene
                Section(header: Text("\(scene.tag)").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/))
                {
                    Text("Running at \(scene.fps) FPS")
                    Section(header: Text("Camera settings").font(.headline)) {
                        Text(String(format:"Angle: [%.2f,%.2f,%.2f]", scene.camera.angle.x, scene.camera.angle.y,scene.camera.angle.z))
                        Text(String(format:"Position: [%.2f,%.2f,%.2f]", scene.camera.position.x, scene.camera.position.y,scene.camera.position.z))
                        
                    }
                    if (scene.light != nil) {
                        let light = scene.light!
                        Section(header: Text("Light settings").font(.headline)) {
                            Text(String(format:"Angle: [%.2f,%.2f,%.2f]", light.angle.x, light.angle.y,light.angle.z))
                            Text(String(format:"Position: [%.2f,%.2f,%.2f]", light.position.x, light.position.y,light.position.z))
                        }
                    }
                }
                
                // All about the rendered objects
                Section(header: Text("\(scene.components.count) objects").font(.title))
                {
                    ForEach(0 ..< scene.components.count, id: \.self) { index in
                        Section(header: Text("\(scene.components[index].tag)").font(.subheadline)) {
                            Text(String(format:"Angle: [%.2f,%.2f,%.2f]",scene.components[index].angle.x,scene.components[index].angle.y,scene.components[index].angle.z))
                            Text(String(format:"Position: [%.2f,%.2f,%.2f]",scene.components[index].position.x, scene.components[index].position.y,scene.components[index].position.z))
                            Text("Mesh used: \(scene.components[index].meshFilename ?? "No mesh")")
                            Text("Material used: \(scene.components[index].materialFilename ?? "No material")")
                        }
                    }
                }
            }
        }
        .listStyle(SidebarListStyle())
        .frame(
            minWidth: width,
            idealWidth: width,
            maxWidth: width,
            minHeight: height,
            idealHeight: height,
            maxHeight: .infinity,
            alignment: .center
        )
    }
}
