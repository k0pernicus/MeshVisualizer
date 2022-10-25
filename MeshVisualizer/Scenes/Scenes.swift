//
//  SimpleObject.swift
//  MeshVisualizer
//
//  Created by Antonin on 06/08/2022.
//

import Foundation

let DEFAULT_LIGHT_POSITION: vector_float3 = [28.0, 0.0, 22]
let DEFAULT_LIGHT_ANGLE: vector_float3 = [0.0, 180.0, 0.0] // [0.0, 120.0, 45.0]
let DEFAULT_LIGHT_COLOR: vector_float3 = [1.0, 1.0, 1.0]

let DEFAULT_LIGHT = Light(
    position: DEFAULT_LIGHT_POSITION,
    angle: DEFAULT_LIGHT_ANGLE,
    color: DEFAULT_LIGHT_COLOR,
    type: .directional,
    intensity: 0.002
)

/// Renders a Crate object in an empty scene, with Noise texture
let simpleCrate = RenderScene(tag: "simpleCrate", components: [
    Object3D(
        tag: "crate 0",
        position: [28.0, 0.0, 0.0],
        angle: [0.0, 0.0, 0.0],
        allows_transformation: true,
        meshFilename: "Crate",
        materialFilename: "Noise"
    ),
], light: nil, rotate: true)

/// Renders three Crate objects, on top of each others, in an empty scene,
/// with different textures
let threeCrates = RenderScene(tag: "threeCrates", components: [
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
        materialFilename: "Crate"
    ),
    Object3D(
        tag: "crate 2",
        position: [28.0, 0.0, 10.0],
        angle: [0.0, 0.0, 0.0],
        allows_transformation: true,
        meshFilename: "Crate",
        materialFilename: "Candy"
    ),
], light: DEFAULT_LIGHT, rotate: true)

/// Renders Iron Man. Yes.
let ironMan = RenderScene(tag: "ironMan", components: [
    Object3D(
        tag: "ironman 0",
        position: [400.0, 0.0, 0.0],
        angle: [90.0, 0.0, 0.0],
        allows_transformation: true,
        meshFilename: "IronMan"
    ),
], light: nil, rotate: false, enableTextureRendering: false)

/// Renders the "hello world" of graphics: the famous teapot
let teaPot = RenderScene(tag: "teaPot", components: [
    Object3D(
        tag: "teapot 0",
        position: [28.0, 0.0, 0.0],
        angle: [90.0, 0.0, 90.0],
        allows_transformation: false,
        meshFilename: "Tea_Pot",
        materialFilename: "Noise"
    ),
], light: nil, rotate: false, enableTextureRendering: true)
