//
//  SimpleObject.swift
//  MeshVisualizer
//
//  Created by Antonin on 06/08/2022.
//

import Foundation

let DEFAULT_LIGHT_ANGLE: vector_float3 = [0.0, 90.0, 0.0] // [0.0, 120.0, 45.0]
let DEFAULT_LIGHT_COLOR: vector_float3 = [1.0, 1.0, 1.0]

let light = Light(
    angle: DEFAULT_LIGHT_ANGLE,
    color: DEFAULT_LIGHT_COLOR,
    type: .directional
)

/// Renders a Crate object in an empty scene, with Noise texture
let simpleCrate = RenderScene(light: light, components: [
    Object3D(
        tag: "crate 0",
        position: [28.0, 0.0, 0.0],
        angle: [0.0, 0.0, 0.0],
        allows_transformation: true,
        meshFilename: "Crate",
        materialFilename: "Noise"
    ),
], rotate: true)

/// Renders three Crate objects, on top of each others, in an empty scene,
/// with different textures
let threeCrates = RenderScene(light: light, components: [
    Object3D(
        tag: "crate 0",
        position: [28.0, 0.0, 0.0],
        angle: [0.0, 0.0, 0.0],
        allows_transformation: true,
        meshFilename: "Crate",
        materialFilename: "Crate"
    ),
    Object3D(
        tag: "crate 1",
        position: [28.0, 0.0, 5.0],
        angle: [0.0, 0.0, 0.0],
        allows_transformation: true,
        meshFilename: "Crate",
        materialFilename: "Noise"
    ),
    Object3D(
        tag: "crate 2",
        position: [28.0, 0.0, 10.0],
        angle: [0.0, 0.0, 0.0],
        allows_transformation: true,
        meshFilename: "Crate",
        materialFilename: "Candy"
    ),
], rotate: true)

/// Renders three Crate objects, on top of each others, in an empty scene,
/// with different textures
let ironMan = RenderScene(light: light, components: [
    Object3D(
        tag: "ironman 0",
        position: [400.0, 0.0, 0.0],
        angle: [90.0, 0.0, 0.0],
        allows_transformation: true,
        meshFilename: "IronMan"
    ),
], rotate: false, enableTextureRendering: false)
