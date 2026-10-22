#version 320 es

precision highp float;
in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

const float PIXELS = 700.0; // Lower is more pixelated

void main() {
    vec2 uv = v_texcoord;
    
    // Snap UVs to a grid
    float dx = 1.0 / PIXELS;
    float dy = 1.0 / PIXELS;
    
    vec2 pixel_uv = vec2(
        dx * floor(uv.x / dx),
        dy * floor(uv.y / dy)
    );

    fragColor = texture(tex, pixel_uv);
}
