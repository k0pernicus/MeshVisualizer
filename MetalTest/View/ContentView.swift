//
//  ContentView.swift
//  MetalTest
//
//  Created by Antonin on 26/07/2022.
//

import SwiftUI
import MetalKit

struct ContentView: UIViewRepresentable {
    
    @EnvironmentObject var scene: RenderScene
    
    func makeCoordinator() -> Renderer {
        Renderer(self, scene: scene)
    }
    
    func makeUIView(context: UIViewRepresentableContext<ContentView>) -> MTKView {
        let mtkView = MTKView()
        mtkView.delegate = context.coordinator
        mtkView.preferredFramesPerSecond = 60 // TODO: handle pro-motion ?
        mtkView.enableSetNeedsDisplay = true
        
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            mtkView.device = metalDevice
        }
        
        mtkView.framebufferOnly = false
        mtkView.drawableSize = mtkView.frame.size
        mtkView.isPaused = false
        mtkView.depthStencilPixelFormat = .depth32Float
        mtkView.depthStencilAttachmentTextureUsage = .renderTarget
        
        return mtkView
    }
    
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<ContentView>) {
        
    }
}
