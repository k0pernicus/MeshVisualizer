//
//  LinearAlgebra.swift
//  MeshVisualizer
//
//  Created by Antonin on 30/07/2022.
//

import Foundation

enum Algebra {
    
    static let MAX_ANGLE: Float = 360.0

    enum TrigAxis {
    case x
    case y
    case z
    }

    static func Identity() -> float4x4 {
        return float4x4(
            [1.0, 0.0, 0.0, 0.0],
            [0.0, 1.0, 0.0, 0.0],
            [0.0, 0.0, 1.0, 0.0],
            [0.0, 0.0, 0.0, 1.0]
        );
    }

    static func Identity(translation: simd_float3) -> float4x4 {
        return float4x4(
            [          1.0,           0.0,           0.0, 0.0],
            [          0.0,           1.0,           0.0, 0.0],
            [          0.0,           0.0,           1.0, 0.0],
            [translation.x, translation.y, translation.z, 1.0]
        );
    }
    
    static func Identity(angle: simd_float3) -> float4x4 {
        let x_angle: Float = angle.x * .pi / 180.0 // gamma
        let y_angle: Float = angle.y * .pi / 180.0 // beta
        let z_angle: Float = angle.z * .pi / 180.0 // alpha
        return (
            Identity(angle: z_angle, around: .z) *
            Identity(angle: y_angle, around: .y) *
            Identity(angle: x_angle, around: .x)
        )
    }

    static func Identity(angle: Float, around axis: TrigAxis) -> float4x4 {
        switch (axis) {
        case TrigAxis.x:
            return float4x4(
                [1,           0,           0, 0],
                [0,  cos(angle),  sin(angle), 0],
                [0, -sin(angle),  cos(angle), 0],
                [0,           0,           0, 1]
            )
        case TrigAxis.y:
            return float4x4(
                [cos(angle), 0, -sin(angle), 0],
                [         0, 1,           0, 0],
                [sin(angle), 0,  cos(angle), 0],
                [         0, 0,           0, 1]
            )
        case TrigAxis.z:
            return float4x4(
                [ cos(angle), sin(angle), 0, 0],
                [-sin(angle), cos(angle), 0, 0],
                [          0,          0, 1, 0],
                [          0,          0, 0, 1]
            )
        }
    }

    static func LookAt(camera: simd_float3, object: simd_float3, up: simd_float3) -> float4x4 {
        let forward = simd.normalize(object - camera)
        let right = simd.normalize(simd.cross(up, forward))
        let gUp = simd.normalize(simd.cross(forward, right))
        return float4x4(
            [                right[0],                 gUp[0],                 forward[0], 0],
            [                right[1],                 gUp[1],                 forward[1], 0],
            [                right[2],                 gUp[2],                 forward[2], 0],
            [-simd.dot(right, camera), -simd.dot(gUp, camera), -simd.dot(forward, camera), 1]
        )
    }
    
    // Translated from cpp, from 3dgep.com
    static func PerspectiveProjection(fieldOfViewY fovy: Float, aspect: Float, nearLimit: Float, farLimit: Float) -> float4x4 {
        let A: Float = aspect * 1 / tan(fovy * .pi / 360)
        let B: Float = 1 / tan(fovy * .pi / 360)
        let C: Float = farLimit / (farLimit - nearLimit)
        let D: Float = 1
        let E: Float = -nearLimit * farLimit / (farLimit - nearLimit)
        return float4x4(
            [A, 0, 0, 0],
            [0, B, 0, 0],
            [0, 0, C, D],
            [0, 0, E, 0]
        )
    }
}
