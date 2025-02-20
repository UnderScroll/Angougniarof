#[compute]
#version 450

layout(local_size_x = 64, local_size_y = 64, local_size_z = 1) in;

layout(set = 0, binding = 0, rgba8) readonly uniform image2D image;
layout(set = 0, binding = 1, std430) restrict buffer OutData {
    atomic_uint sum;
} outData;

void main() {
    vec4 texel = imageLoad(image, gl_LocalInvocationID.xy);
}