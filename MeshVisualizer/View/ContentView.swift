//
//  ContentView.swift
//  MeshVisualizer
//
//  Created by Antonin on 26/07/2022.
//

import SwiftUI
import MetalKit

// TODO: handle pro-motion ?
let DEFAULT_PREFERRED_FPS : Int = 120

struct ContentView: UIViewRepresentable {
    
    @EnvironmentObject var scene: RenderScene
    
    func makeCoordinator() -> Renderer {
        Renderer(self, scene: scene)
    }
    
    func makeUIView(context: UIViewRepresentableContext<ContentView>) -> MTKView {
        let mtkView = MTKView()
        mtkView.delegate = context.coordinator
        mtkView.preferredFramesPerSecond = DEFAULT_PREFERRED_FPS
        mtkView.enableSetNeedsDisplay = true
        
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            mtkView.device = metalDevice
        }
        
        mtkView.framebufferOnly = false
        mtkView.drawableSize = mtkView.frame.size
        mtkView.isPaused = false
        mtkView.depthStencilPixelFormat = .depth32Float
        // TODO: check if useful
        mtkView.depthStencilAttachmentTextureUsage = .renderTarget
        
        return mtkView
    }
    
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<ContentView>) {
        
    }
}
