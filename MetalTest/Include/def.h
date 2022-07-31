//
//  def.h
//  MetalTest
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
};

#endif /* DEF_H */
