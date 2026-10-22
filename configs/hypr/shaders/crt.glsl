#version 320 es

precision highp float;
in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

// Constants
const float PI = 3.1415926535;

// Configuration
const float CURVE_INTENSITY = 0.05; // Fisheye strength (3.0-5.0 range usually for strong, but we iterate)
const float VIGNETTE_STRENGTH = 0.45; // 0.0 to 1.0
const float VIGNETTE_INTENSITY = 3.0;
const float SCANLINE_COUNT = 360.0;
const float SCANLINE_INTENSITY = 0.35;

vec2 curve(vec2 uv) {
    vec2 cc = uv - 0.5;
    vec2 dist = cc;
    // Stronger distortion at edges
    dist *= 1.0 + (dot(cc, cc) * CURVE_INTENSITY * 8.0);
    return dist + 0.5;
}

void main() {
    vec2 uv = v_texcoord;
    
    // 1. Fisheye Curve
    // We warp the UV coordinates
    vec2 curved_uv = curve(uv);
    
    // Check if we are outside the screen area (black border for rounded CRT look)
    if (curved_uv.x < 0.0 || curved_uv.x > 1.0 || curved_uv.y < 0.0 || curved_uv.y > 1.0) {
        fragColor = vec4(0.0, 0.0, 0.0, 1.0);
        return;
    }

    // 2. Sample texture with curved UV
    vec3 color = texture(tex, curved_uv).rgb;

    // 3. Scanlines
    // Simple sine wave based on Y coordinate
    float s = sin(curved_uv.y * SCANLINE_COUNT * PI * 2.0);
    float scanline = 1.0 - (0.5 + 0.5 * s) * SCANLINE_INTENSITY;
    color *= scanline;

    // 4. Strong Vignette
    // Calculate distance from center
    vec2 uv_vig = curved_uv * (1.0 - curved_uv.yx);
    float vig = uv_vig.x * uv_vig.y * 15.0; // 15.0 is a magic number for spread
    vig = pow(vig, VIGNETTE_STRENGTH); // Curve of the falloff
    
    // Invert and clamp for darkening
    // The previous formula creates a mask where center is 1 and edges are 0.
    // Let's make it simpler for "strong" look
    
    float v = length(curved_uv - 0.5);
    // Darken as we get further from center
    float vignette = smoothstep(0.7, 0.35, v * 1.0); 
    // Mix it in
    color *= vignette;
    
    // Optional: Slight Chromatic Aberration for realism
    // vec3 color_r = texture(tex, curved_uv - vec2(0.003, 0.0)).rgb;
    // vec3 color_b = texture(tex, curved_uv + vec2(0.003, 0.0)).rgb;
    // color.r = color_r.r;
    // color.b = color_b.b;

    fragColor = vec4(color, 1.0);
}
