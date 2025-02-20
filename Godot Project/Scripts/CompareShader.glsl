#[compute]
#version 450

// Invocations in the (x, y, z) dimension
layout(local_size_x = 32, local_size_y = 32, local_size_z = 1) in;

layout(rgba8, binding = 0) restrict uniform image2D tex1;
layout(rgba8, binding = 1) readonly restrict uniform image2D tex2;

layout(set = 0, binding = 2) restrict buffer Parameters {
float threshold;
} parameters;

void main() {
    ivec2 uv = ivec2(gl_GlobalInvocationID.xy);  // Pixel coordinates

    vec4 color1 = imageLoad(tex1, uv);
    vec4 color2 = imageLoad(tex2, uv);
    
    float b1 = (color1.r + color1.g + color1.b)/3;
    float b2 = (color2.r + color2.g + color2.b)/3;

    float targetC = abs(b1-b2);
    targetC *= step(parameters.threshold,targetC);
    imageStore(tex1, uv, vec4(targetC ,targetC,targetC,1));
}
     