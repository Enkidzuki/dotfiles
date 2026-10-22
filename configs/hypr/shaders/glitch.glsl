#version 320 es

precision highp float;
in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

// Glitch parameters
const float CHROMA_STR = 0.015;
const float TIME_VAL = 1.0; // We don't have a time uniform by default, but we can simulate static glitch

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

void main() {
    vec2 uv = v_texcoord;
    
    // Horizontal tearing logic (deterministic based on Y)
    float noise = hash(vec2(floor(uv.y * 20.0), 0.0));
    if (noise > 0.95) {
        uv.x += (hash(vec2(uv.y, 1.0)) - 0.5) * 0.05;
    }

    // RGB Split
    float r = texture(tex, uv + vec2(CHROMA_STR, 0.0)).r;
    float g = texture(tex, uv).g;
    float b = texture(tex, uv - vec2(CHROMA_STR, 0.0)).b;

    vec3 color = vec3(r, g, b);
    
    // Subtle static noise
    float s = hash(uv);
    color += (s - 0.5) * 0.05;

    fragColor = vec4(color, 1.0);
}
