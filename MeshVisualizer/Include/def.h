//
//  def.h
//  MeshVisualizer
//
//  Created by Antonin on 26/07/2022.
//

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

struct LightParameters {
    vector_float3 forward;
    vector_float3 color;
};

enum LightType {
    Directional,
    // TODO: Spot, Point, ...
};

#endif /* DEF_H */
