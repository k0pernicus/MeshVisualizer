//
//  Shaders.metal
//  MeshVisualizer
//
//  Created by Antonin on 26/07/2022.
//

#include <metal_stdlib>
using namespace metal;

#include "Include/def.h"

struct VertexIn {
    float4 position [[ attribute(0) ]];
    float2 texCoord [[ attribute(1) ]];
    float3 normal   [[ attribute(2) ]];
};

struct Fragment {
    float4 position [[position]]; // world space position
    float2 texCoord;
    float3 normal;
    float3 cameraPosition; // for reflection
    float3 fragmentPosition; // differenciate with 'position' as we want model space, not world space
};

vertex Fragment vertexShader(
     const VertexIn vertex_in [[ stage_in ]],
     const constant matrix_float4x4 &modelTransformation [[ buffer(1) ]],
     constant CameraParameters &camera [[ buffer(2) ]]
) {
    matrix_float3x3 dimModel;
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            dimModel[j][i] = modelTransformation[j][i];
        }
    }
    
    Fragment output;
    output.position = camera.projection * camera.view * modelTransformation * vertex_in.position;
    output.texCoord = vertex_in.texCoord;
    output.normal = dimModel * vertex_in.normal;
    output.fragmentPosition = float3(modelTransformation * vertex_in.position);
    
    return output;
}

/// Fragment to be used when apposing strip fragments (no texture, only a
/// single black color for each object's vertex)
fragment float4 fragmentShader(
    Fragment input [[ stage_in ]],
    texture2d<float> objectTexture [[ texture(0) ]],
    sampler samplerObject [[ sampler(0) ]]
) {
    return float4(0.0, 0.0, 0.0, 1.0);
}

/// Fragment to be used when apposing a texture to the object
fragment float4 texFragmentShader(
    Fragment input [[ stage_in ]],
    texture2d<float> objectTexture [[ texture(0) ]],
    sampler samplerObject [[ sampler(0) ]],
    constant LightParameters &light [[ buffer (0) ]]
) {
    // Get the base color (color of the texture object)
    float3 baseColor = float3(objectTexture.sample(samplerObject, input.texCoord));
    // Compute an ambient light
    float3 ambientColor = 0.2 * baseColor; // TODO: pass the value as function parameter
    // Compute now the light amount for each vertex
    float lightAmount = max(0.0, dot(input.normal, light.forward));
    // Finalize the amount of color to diffuse
    ambientColor += lightAmount * baseColor * light.color;
    return float4(ambientColor, 1.0);
}
