//
//  MetalTestApp.swift
//  MetalTest
//
//  Created by Antonin on 26/07/2022.
//

import SwiftUI

let WIDTH: CGFloat = 1920
let HEIGHT: CGFloat = 1080

@main
struct MetalTestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: WIDTH, height: HEIGHT, alignment: .center)
        }
    }
}
