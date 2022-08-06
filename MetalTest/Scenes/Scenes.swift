//
//  SimpleObject.swift
//  MetalTest
//
//  Created by Antonin on 06/08/2022.
//

import Foundation

/// Renders a Crate object in an empty scene, with Noise texture
let simpleCrate = RenderScene(components: [
    Object3D(
        position: [28.0, 0.0, 0.0],
        angle: [0.0, 0.0, 0.0],
        allows_transformation: true,
        meshFilename: "Crate",
        materialFilename: "Noise"
    ),
], rotate: true)

/// Renders three Crate objects, on top of each others, in an empty scene,
/// with different textures
let threeCrates = RenderScene(components: [
    Object3D(
        position: [28.0, 0.0, 0.0],
        angle: [0.0, 0.0, 0.0],
        allows_transformation: true,
        meshFilename: "Crate",
        materialFilename: "Crate"
    ),
    Object3D(
        position: [28.0, 0.0, 5.0],
        angle: [0.0, 0.0, 0.0],
        allows_transformation: true,
        meshFilename: "Crate",
        materialFilename: "Noise"
    ),
    Object3D(
        position: [28.0, 0.0, 10.0],
        angle: [0.0, 0.0, 0.0],
        allows_transformation: true,
        meshFilename: "Crate",
        materialFilename: "Candy"
    ),
], rotate: true)

/// Renders three Crate objects, on top of each others, in an empty scene,
/// with different textures
let ironMan = RenderScene(components: [
    Object3D(
        position: [400.0, 0.0, 0.0],
        angle: [90.0, 0.0, 0.0],
        allows_transformation: true,
        meshFilename: "IronMan"
    ),
], rotate: false, renderTexture: false)
