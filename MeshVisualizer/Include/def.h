//
//  def.h
//  MeshVisualizer
//
//  Created by Antonin on 26/07/2022.
//
//  The purpose of this header is to use
//  common data structures definitions for
//  both the Swift application and the Metal
//  shaders.

#ifndef DEF_H
#define DEF_H

#include <simd/simd.h>
struct Vertex {
    vector_float3 position;
    vector_float4 color;
};

struct CameraParameters {
    matrix_float4x4 view;
    matrix_float4x4 projection;
    vector_float3 position;
};

struct ObjectParameters {
    uint8_t isLightObject;
};

struct LightParameters {
    vector_float3 forward;
    vector_float3 color;
    float intensity;
};

enum LightType {
    Directional,
    // TODO: Spot, Point, ...
};

#endif /* DEF_H */
