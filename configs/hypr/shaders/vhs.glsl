#version 320 es
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

// A static random function that doesn't use time
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    vec2 uv = v_texcoord;
    
    // 1. Static Chromatic Aberration
    float offset = 0.003;
    float r = texture(tex, uv - vec2(offset, 0.0)).r;
    float g = texture(tex, uv).g;
    float b = texture(tex, uv + vec2(offset, 0.0)).b;
    
    vec3 color = vec3(r, g, b);
    
    // 2. Static Grain/Noise
    // Using UV as seed makes it static but textured
    float noise = rand(uv) * 0.12;
    color += noise;
    
    // 3. Static Scanlines
    color *= 0.92 + 0.08 * sin(uv.y * 600.0);

    // 4. Slight vignette for retro feel
    float vig = 16.0 * uv.x * uv.y * (1.0 - uv.x) * (1.0 - uv.y);
    color *= mix(0.7, 1.0, pow(vig, 0.1));

    fragColor = vec4(color, 1.0);
}