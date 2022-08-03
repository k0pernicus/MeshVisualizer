//
//  Shaders.metal
//  MetalTest
//
//  Created by Antonin on 26/07/2022.
//

#include <metal_stdlib>
using namespace metal;

#include "Include/def.h"

struct VertexIn {
    float4 position [[ attribute(0) ]];
};

struct Fragment {
    float4 position [[position]];
    float4 color;
};

vertex Fragment vertexShader(
     const VertexIn vertex_in [[ stage_in ]],
     const constant matrix_float4x4 &modelTransformation [[ buffer(1) ]],
     constant CameraParameters &camera [[ buffer(2) ]]
) {
    Fragment output;
    output.position = camera.projection * camera.view * modelTransformation * vertex_in.position;
    output.color = float4(1.0, 1.0, 1.0, 1.0); // TODO: allow texture
    
    return output;
}

fragment float4 fragmentShader(Fragment input [[ stage_in ]]) {
    return input.color;
}
